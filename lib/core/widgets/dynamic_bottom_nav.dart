import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Componente que renderiza dinámicamente el BottomNavigationBar
/// según el rol del usuario autenticado
///
/// CÓMO EXTENDER PARA AGREGAR NUEVAS PANTALLAS:
/// 1. Agregar la nueva ruta en _getCurrentIndex()
/// 2. Agregar el caso en _onTabTapped()
/// 3. Agregar el BottomNavigationBarItem en _getNavigationItems()
/// 4. Crear la nueva pantalla en features/{rol}/presentation/screens/
/// 5. Agregar la ruta en app_router.dart dentro del ShellRoute correspondiente
class DynamicBottomNav extends StatelessWidget {
  /// El rol del usuario actual (ej: 'residente', 'guardia')
  final String? userRole;

  const DynamicBottomNav({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    // Si no hay rol definido, no mostrar navegación
    if (userRole == null) {
      return const SizedBox.shrink();
    }

    // Obtener la ruta actual para determinar el tab activo
    final location = GoRouterState.of(context).uri.toString();

    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(location, userRole!),
      onTap: (index) => _onTabTapped(context, index, userRole!),
      type: BottomNavigationBarType.fixed,
      items: _getNavigationItems(userRole!),
    );
  }

  /// Determina el índice del tab activo basado en la ruta actual
  int _getCurrentIndex(String location, String role) {
    if (role == 'residente') {
      if (location.contains('/residente/perfil')) return 0;
      if (location.contains('/residente/reservas')) return 1;
      // EJEMPLO: if (location.contains('/residente/pagos')) return 2;
    } else if (role == 'guardia') {
      if (location.contains('/guardia/perfil')) return 0;
      if (location.contains('/guardia/accesos')) return 1;
      // EJEMPLO: if (location.contains('/guardia/rondas')) return 2;
      // EJEMPLO: if (location.contains('/guardia/reportes')) return 3;
    }
    return 0; // Default al primer tab
  }

  /// Maneja la navegación cuando se toca un tab
  void _onTabTapped(BuildContext context, int index, String role) {
    String route;

    if (role == 'residente') {
      switch (index) {
        case 0:
          route = '/residente/perfil';
          break;
        case 1:
          route = '/residente/reservas';
          break;
        // EJEMPLO PARA AGREGAR NUEVAS PANTALLAS:
        // case 2:
        //   route = '/residente/pagos';
        //   break;
        default:
          route = '/residente/perfil';
      }
    } else if (role == 'guardia') {
      switch (index) {
        case 0:
          route = '/guardia/perfil';
          break;
        case 1:
          route = '/guardia/accesos';
          break;
        // EJEMPLO PARA AGREGAR NUEVAS PANTALLAS:
        // case 2:
        //   route = '/guardia/rondas';
        //   break;
        // case 3:
        //   route = '/guardia/reportes';
        //   break;
        default:
          route = '/guardia/perfil';
      }
    } else {
      return; // Rol no reconocido
    }

    context.go(route);
  }

  /// Retorna los items de navegación específicos para cada rol
  List<BottomNavigationBarItem> _getNavigationItems(String role) {
    if (role == 'residente') {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_available),
          label: 'Reservas',
        ),
        // EJEMPLO PARA AGREGAR NUEVOS TABS:
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.payment),
        //   label: 'Pagos',
        // ),
      ];
    } else if (role == 'guardia') {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Accesos'),
        // EJEMPLO PARA AGREGAR NUEVOS TABS:
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.security),
        //   label: 'Rondas',
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.report),
        //   label: 'Reportes',
        // ),
      ];
    }

    // Fallback para roles no reconocidos
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
    ];
  }
}
