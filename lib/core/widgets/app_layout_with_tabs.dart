import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'dynamic_bottom_nav.dart';

/// Widget principal que maneja el layout con pestañas basadas en roles
///
/// Este widget se usa como wrapper en ShellRoute para mostrar un
/// BottomNavigationBar persistente que cambia según el rol del usuario
class AppLayoutWithTabs extends StatelessWidget {
  /// El contenido principal que se muestra en el cuerpo de la pantalla
  final Widget child;

  const AppLayoutWithTabs({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Si no hay usuario autenticado, mostrar solo el contenido sin tabs
        if (!authProvider.isLoggedIn) {
          return child;
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: DynamicBottomNav(
            userRole: authProvider.userRole,
          ),
        );
      },
    );
  }
}
