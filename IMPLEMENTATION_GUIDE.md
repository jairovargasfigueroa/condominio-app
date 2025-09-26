# 📱 Guía de Implementación - App Condominio

## 🎯 **Objetivo del Proyecto**

App móvil para condominio con 2 tipos de usuarios:

- **👮‍♂️ Guardias**: Control de acceso, registro de visitantes
- **🏠 Residentes**: Pre-registro de visitantes, notificaciones

---

## 📦 **Librerías a Instalar**

### **Comando de instalación:**

```bash
flutter pub add go_router gap flutter_secure_storage image_picker firebase_core firebase_messaging
```

### **Resultado en pubspec.yaml:**

```yaml
dependencies:
  flutter:
    sdk: flutter

  # YA TIENES:
  cupertino_icons: ^1.0.8
  http: ^1.5.0
  provider: ^6.1.5+1

  # NUEVAS:
  go_router: ^14.6.1 # 🧭 Navegación con rutas protegidas
  gap: ^3.0.1 # 🎨 Espaciado consistente
  flutter_secure_storage: ^9.2.2 # 🔐 Almacenamiento seguro de tokens
  image_picker: ^1.1.2 # 📸 Cámara para fotos de visitantes
  firebase_core: ^3.6.0 # 🔥 Firebase base
  firebase_messaging: ^15.1.3 # 🔔 Notificaciones push
```

---

## 🏗️ **Estructura de Archivos a Crear**

```
lib/
├── core/
│   ├── routes/
│   │   └── app_routes.dart          # 🧭 Configuración de rutas
│   ├── services/
│   │   ├── auth_service.dart        # 🔐 Manejo de autenticación
│   │   ├── storage_service.dart     # 💾 Almacenamiento seguro
│   │   └── notification_service.dart # 🔔 Push notifications
│   └── constants/
│       └── app_constants.dart       # 📋 URLs, keys, etc.
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── login_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── login_screen.dart
│   │       └── providers/
│   │           └── auth_provider.dart
│   │
│   ├── dashboard/
│   │   └── presentation/
│   │       └── screens/
│   │           ├── guard_dashboard.dart     # 👮‍♂️ Dashboard guardia
│   │           └── resident_dashboard.dart  # 🏠 Dashboard residente
│   │
│   └── visitors/
│       ├── data/
│       │   └── models/
│       │       └── visitor_model.dart
│       └── presentation/
│           └── screens/
│               ├── register_visitor_screen.dart  # 📝 Registro visitantes
│               └── visitor_list_screen.dart      # 📋 Lista visitantes
│
└── main.dart
```

---

## 🔧 **Implementación Paso a Paso**

### **1. 🧭 go_router - Navegación con Autenticación**

**Archivo: `lib/core/routes/app_routes.dart`**

```dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/guard_dashboard.dart';
import '../../features/dashboard/presentation/screens/resident_dashboard.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // 🔐 Ruta de login
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),

      // 👮‍♂️ Dashboard guardia
      GoRoute(
        path: '/guard-dashboard',
        builder: (context, state) => GuardDashboard(),
      ),

      // 🏠 Dashboard residente
      GoRoute(
        path: '/resident-dashboard',
        builder: (context, state) => ResidentDashboard(),
      ),
    ],
  );
}
```

**Uso en main.dart:**

```dart
import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Condominio App',
      routerConfig: AppRoutes.router,
    );
  }
}
```

### **2. 🔐 flutter_secure_storage - Tokens JWT**

**Archivo: `lib/core/services/storage_service.dart`**

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  // Guardar token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Obtener token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Guardar rol del usuario
  static Future<void> saveUserRole(String role) async {
    await _storage.write(key: 'user_role', value: role);
  }

  // Obtener rol
  static Future<String?> getUserRole() async {
    return await _storage.read(key: 'user_role');
  }

  // Limpiar datos (logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

**Uso en login:**

```dart
// Después de login exitoso
await StorageService.saveToken(response.token);
await StorageService.saveUserRole(response.role); // 'guard' o 'resident'

// Para verificar si está logueado
String? token = await StorageService.getToken();
if (token != null) {
  // Usuario logueado
}
```

### **3. 📸 image_picker - Fotos de Visitantes**

**Uso básico:**

```dart
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VisitorRegistrationScreen extends StatefulWidget {
  @override
  _VisitorRegistrationScreenState createState() => _VisitorRegistrationScreenState();
}

class _VisitorRegistrationScreenState extends State<VisitorRegistrationScreen> {
  File? _visitorPhoto;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _visitorPhoto = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Visitante')),
      body: Column(
        children: [
          // Mostrar foto
          if (_visitorPhoto != null)
            Image.file(_visitorPhoto!, height: 200),

          Gap(20), // 🎨 Uso de Gap

          // Botón para tomar foto
          ElevatedButton.icon(
            onPressed: _takePhoto,
            icon: Icon(Icons.camera_alt),
            label: Text('Tomar Foto'),
          ),
        ],
      ),
    );
  }
}
```

### **4. 🎨 gap - Espaciado Consistente**

**Reemplaza SizedBox:**

```dart
// ❌ Antes:
SizedBox(height: 20)
SizedBox(width: 16)

// ✅ Ahora:
Gap(20)      // Espacio vertical
Gap.h(16)    // Espacio horizontal
```

### **5. 🔔 Firebase - Notificaciones Push**

**Configuración inicial:**

```dart
// lib/core/services/notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService {
  static FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp();

    // Pedir permisos
    await _messaging.requestPermission();

    // Obtener token del dispositivo
    String? token = await _messaging.getToken();
    print('📱 FCM Token: $token');
    // Enviar este token a tu backend
  }

  static Future<void> setupForegroundNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Notificación recibida: ${message.notification?.title}');
      // Mostrar notificación local
    });
  }
}
```

**En main.dart:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(MyApp());
}
```

---

## 📋 **Plan de Implementación por Fases**

### **🚀 Fase 1: Base (2-3 horas)**

- [ ] Instalar las 6 librerías
- [ ] Configurar go_router con rutas básicas
- [ ] Crear LoginScreen simple
- [ ] Implementar StorageService
- [ ] Crear dashboards vacíos (guard/resident)

### **🔐 Fase 2: Autenticación (2-3 horas)**

- [ ] Conectar login con tu backend
- [ ] Implementar guardado de token JWT
- [ ] Agregar redirección por rol
- [ ] Manejar logout
- [ ] Validar token en rutas protegidas

### **📸 Fase 3: Registro de Visitantes (2-3 horas)**

- [ ] Pantalla de registro con cámara
- [ ] Subir foto al backend
- [ ] Lista de visitantes para guardia
- [ ] Pre-registro para residentes

### **🔔 Fase 4: Notificaciones (1-2 horas)**

- [ ] Configurar Firebase
- [ ] Implementar push notifications
- [ ] Conectar con backend para envío

### **✨ Fase 5: Polish para Docente (1 hora)**

- [ ] Mejorar UI con Gap
- [ ] Agregar loading states
- [ ] Manejo de errores
- [ ] Validaciones de formularios

---

## 🎯 **Funcionalidades Finales**

### **👮‍♂️ Dashboard Guardia:**

- ✅ Ver visitantes esperados del día
- ✅ Registrar llegada con foto
- ✅ Marcar salida de visitantes
- ✅ Recibir notificaciones de nuevos pre-registros

### **🏠 Dashboard Residente:**

- ✅ Pre-registrar visitantes (nombre, fecha, hora)
- ✅ Ver historial de visitas
- ✅ Recibir notificación cuando llegue el visitante
- ✅ Cancelar pre-registros

---

## 🔗 **Conexión con Backend**

### **Headers para autenticación:**

```dart
Map<String, String> getAuthHeaders() => {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer ${await StorageService.getToken()}',
};
```

### **Endpoints sugeridos:**

```
POST /api/auth/login          # Login
GET  /api/visitors/today      # Visitantes del día
POST /api/visitors/register   # Registrar visitante
PUT  /api/visitors/{id}/arrive # Marcar llegada
```

---

## 📱 **Para el Docente**

- App compilada para Android (.apk)
- Credenciales de prueba (guardia y residente)
- Video demo de 2-3 minutos
- Este documento como documentación técnica

---

**💡 ¡Guarda este archivo y ve implementando paso a paso!**
