import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/providers/app_providers.dart';
import 'package:my_flutter_app/core/routing/app_router.dart';
import 'package:my_flutter_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_flutter_app/core/services/notification_service.dart';
import 'firebase_options.dart';

/// Función para manejar mensajes en background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('🔔 Mensaje recibido en background: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔔 Configurar handler para mensajes en background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 📱 Inicializar servicio de notificaciones
  await NotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final router = createAppRouter(authProvider);

          return MaterialApp.router(
            title: 'Condominio App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 4, 143, 250),
              ),
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
