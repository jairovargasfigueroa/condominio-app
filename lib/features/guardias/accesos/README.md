# Feature: Accesos

Este feature permite a los guardias registrar manualmente los accesos (entradas y salidas) de los usuarios del condominio.

## Estructura del Feature

```
accesos/
├── data/
│   ├── models/
│   │   ├── acceso_model.dart                 # Modelo base para accesos
│   │   ├── create_acceso_request.dart        # Modelo para crear acceso
│   │   └── acceso_response_model.dart        # Modelo de respuesta del API
│   ├── services/
│   │   └── accesos_service.dart              # Servicio para comunicación con API
│   └── repositories/
│       └── accesos_repository.dart           # Repositorio para manejar datos
└── presentation/
    ├── providers/
    │   └── accesos_provider.dart             # Estado y lógica de negocio
    ├── screens/
    │   ├── accesos_screen.dart               # Pantalla principal de accesos
    │   └── create_acceso_screen.dart         # Pantalla para registrar acceso
    └── widgets/
        └── create_acceso_form.dart           # Formulario de registro
```

## Funcionalidad

### Registro de Acceso

- **Endpoint**: `POST /api/accesos/`
- **Parámetros**:
  ```json
  {
    "usuario": 1,
    "tipo_acceso": "ENTRADA"
  }
  ```

### Tipos de Acceso

- `ENTRADA`: Registro de entrada al condominio
- `SALIDA`: Registro de salida del condominio

## Uso

### 1. Provider

```dart
// Crear instancia del provider
final accesosProvider = AccesosProvider();

// Registrar un acceso
await accesosProvider.createAcceso(
  usuario: 1,
  tipoAcceso: 'ENTRADA',
);
```

### 2. Pantallas

- **AccesosScreen**: Pantalla principal con botón para registrar accesos
- **CreateAccesoScreen**: Pantalla con formulario para registrar nuevo acceso

### 3. Navegación

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ChangeNotifierProvider(
      create: (context) => AccesosProvider(),
      child: AccesosScreen(),
    ),
  ),
);
```

## Características

- ✅ Registro simple de accesos con solo usuario y tipo
- ✅ Validación de campos del formulario
- ✅ Manejo de estados de carga y errores
- ✅ Interfaz intuitiva para guardias
- ✅ Notificaciones de éxito/error
- ✅ Limpieza automática del formulario después de registro exitoso

## Notas de Implementación

- El feature sigue el patrón de arquitectura limpia usado en el proyecto
- Utiliza Provider para manejo de estado
- Los errores son manejados y mostrados al usuario
- El formulario incluye validaciones básicas
- La interfaz está diseñada específicamente para uso por guardias
