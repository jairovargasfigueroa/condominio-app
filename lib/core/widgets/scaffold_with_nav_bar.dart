import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/features/auth/presentation/providers/auth_provider.dart';

/// Widget que contiene el BottomNavigationBar y maneja la navegación
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userRole = authProvider.userRole;

        // Configurar tabs según el rol del usuario
        List<BottomNavigationBarItem> tabs;
        if (userRole == 'guardia') {
          tabs = const [
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
            BottomNavigationBarItem(
              icon: Icon(Icons.security),
              label: 'Guardia',
            ),
          ];
        } else {
          // Rol residente o por defecto
          tabs = const [
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ];
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Condominio App'),
            backgroundColor: Color.fromARGB(255, 4, 143, 250),
            foregroundColor: Colors.white,
            actions: [
              // Información del usuario
              if (authProvider.user != null)
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Center(
                    child: Text(
                      '👋 ${authProvider.user!.fullName} (${userRole ?? 'usuario'})',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),

              // Botón de logout
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'logout') {
                    final authProvider = context.read<AuthProvider>();
                    await authProvider.logout();
                    // La redirección al login se maneja automáticamente por el router
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Cerrar Sesión'),
                          ],
                        ),
                      ),
                    ],
              ),
            ],
          ),
          body: navigationShell,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex:
                userRole == 'guardia' && navigationShell.currentIndex == 2
                    ? 1 // Mostrar índice 1 cuando el guardia está en el branch 2
                    : navigationShell.currentIndex,
            onTap: (index) {
              // Mapear índice según el rol del usuario
              int targetBranch = index;

              if (userRole == 'guardia') {
                // Para guardias: índice 0 = Users (branch 0), índice 1 = Guardia (branch 2)
                if (index == 1) {
                  targetBranch = 2; // Ir al branch del guardia
                }
              } else {
                // Para residentes: índice 0 = Users (branch 0), índice 1 = Perfil (branch 1)
                targetBranch = index;
              }

              navigationShell.goBranch(targetBranch);
            },
            items: tabs,
          ),
        );
      },
    );
  }
}
