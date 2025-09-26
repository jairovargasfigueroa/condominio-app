import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/features/auth/presentation/screens/login_screen.dart';
import 'package:my_flutter_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:my_flutter_app/features/users/presentation/screens/user_screen.dart';
import 'package:my_flutter_app/features/residentes/perfil/presentation/screens/residente_screen.dart';
import 'package:my_flutter_app/features/residentes/reservas/presentation/screens/reservas_screen.dart';
import 'package:my_flutter_app/features/guardias/perfil/presentation/screens/guardia_screen.dart';
import 'package:my_flutter_app/features/guardias/accesos/presentation/screens/accesos_screen.dart';
import 'package:my_flutter_app/core/widgets/app_layout_with_tabs.dart';
import 'route_names.dart';

/// Router principal de la aplicación con navegación basada en roles
///
/// ESTRUCTURA:
/// - Login: Pantalla independiente sin navegación
/// - ShellRoute: Layout con tabs que contiene todas las pantallas autenticadas
///   └── Rutas específicas por rol (residente/guardia)
///
/// CÓMO AGREGAR NUEVAS RUTAS:
/// 1. Agregar la ruta en route_names.dart
/// 2. Crear la pantalla en features/{rol}/presentation/screens/
/// 3. Agregar la ruta aquí dentro del ShellRoute correspondiente
/// 4. Actualizar DynamicBottomNav para incluir el nuevo tab
GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: RouteNames.login,
    refreshListenable: authProvider,

    redirect: (context, state) {
      final isLoggedIn = authProvider.isLoggedIn;
      final userRole = authProvider.userRole;
      final isOnLoginPage = state.fullPath == RouteNames.login;

      print(
        '🧭 Router redirect - Role: $userRole, isLoggedIn: $isLoggedIn, currentPath: ${state.fullPath}',
      );

      // Si no está logueado y no está en login, ir a login
      if (!isLoggedIn && !isOnLoginPage) {
        print('🔓 Redirigiendo a login - usuario no autenticado');
        return RouteNames.login;
      }

      // Si está logueado y en login, redirigir por rol
      if (isLoggedIn && isOnLoginPage) {
        if (userRole == 'residente') {
          print('✅ Redirigiendo a perfil residente');
          return RouteNames.residentePerfil;
        } else if (userRole == 'guardia') {
          print('✅ Redirigiendo a perfil guardia');
          return RouteNames.guardiaPerfilNew;
        }
        return RouteNames.residentePerfil; // Fallback
      }

      return null;
    },

    routes: [
      // 🔑 Ruta de Login (sin navegación)
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),

      // 🏠 ShellRoute para navegación con pestañas
      ShellRoute(
        builder: (context, state, child) {
          return AppLayoutWithTabs(child: child);
        },
        routes: [
          // 🏠 Rutas para RESIDENTES
          GoRoute(
            path: RouteNames.residentePerfil,
            name: 'residente_perfil',
            builder: (context, state) => ResidenteScreen(),
          ),
          GoRoute(
            path: RouteNames.residenteReservas,
            name: 'residente_reservas',
            builder: (context, state) => ReservasScreen(),
          ),
          // EJEMPLO: Para agregar nuevas pantallas de residente
          // GoRoute(
          //   path: '/residente/pagos',
          //   name: 'residente_pagos',
          //   builder: (context, state) => const PagosScreen(),
          // ),

          // 🛡️ Rutas para GUARDIAS
          GoRoute(
            path: RouteNames.guardiaPerfilNew,
            name: 'guardia_perfil',
            builder: (context, state) => GuardiaScreen(),
          ),
          GoRoute(
            path: RouteNames.guardiaAccesos,
            name: 'guardia_accesos',
            builder: (context, state) => AccesosScreen(),
          ),
          // EJEMPLO: Para agregar nuevas pantallas de guardia
          // GoRoute(
          //   path: '/guardia/rondas',
          //   name: 'guardia_rondas',
          //   builder: (context, state) => const RondasScreen(),
          // ),

          // 👥 Ruta de Users (común - opcional)
          GoRoute(
            path: RouteNames.users,
            name: 'users',
            builder: (context, state) => UserScreen(),
          ),
        ],
      ),
    ],
  );
}
