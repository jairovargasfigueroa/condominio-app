import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/providers/app_providers.dart';
import 'package:my_flutter_app/core/routing/app_router.dart';
import 'package:my_flutter_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
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
          // 🎯 Crea el router con acceso al AuthProvider
          final router = createAppRouter(authProvider);

          return MaterialApp.router(
            title: 'Condominio App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 4, 143, 250),
              ),
            ),
            routerConfig: router, // 🔧 Usa el router dinámico
          );
        },
      ),
    );
  }
}
