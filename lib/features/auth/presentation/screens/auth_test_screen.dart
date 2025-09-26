import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:my_flutter_app/features/users/presentation/providers/user_provider.dart';

/// Pantalla de prueba para verificar que el interceptor funciona correctamente
class AuthTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🧪 Prueba de Autenticación'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Estado de autenticación
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '🔐 Estado de Autenticación',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Logueado: ${authProvider.isLoggedIn ? '✅ SÍ' : '❌ NO'}',
                        ),
                        Text(
                          'Token: ${authProvider.token?.substring(0, 20) ?? 'Sin token'}...',
                        ),
                        if (authProvider.errorMessage != null)
                          Text(
                            'Error: ${authProvider.errorMessage}',
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 16),

            // Botones de prueba
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Column(
                  children: [
                    // Login simulado
                    ElevatedButton(
                      onPressed:
                          authProvider.isLoading
                              ? null
                              : () {
                                authProvider.login(
                                  'test@example.com',
                                  'password123',
                                );
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        authProvider.isLoading
                            ? '⏳ Cargando...'
                            : '🔑 Hacer Login',
                      ),
                    ),

                    SizedBox(height: 8),

                    // Logout
                    ElevatedButton(
                      onPressed:
                          authProvider.isLoggedIn
                              ? () {
                                authProvider.logout();
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('🚪 Logout'),
                    ),

                    SizedBox(height: 16),

                    // Probar petición con token
                    ElevatedButton(
                      onPressed: () {
                        final userProvider = context.read<UserProvider>();
                        userProvider.loadUsers();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '📡 Petición enviada - revisa la consola',
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('📡 Probar Petición con Token'),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 16),

            // Instrucciones
            Card(
              color: Colors.grey[100],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📋 Instrucciones de Prueba:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('1. Presiona "🔑 Hacer Login" para simular login'),
                    Text('2. Verifica que aparezca el token en el estado'),
                    Text('3. Presiona "📡 Probar Petición" para hacer request'),
                    Text(
                      '4. Revisa la consola - debe mostrar header Authorization',
                    ),
                    Text('5. Presiona "🚪 Logout" para limpiar token'),
                    Text('6. Prueba hacer petición sin token'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
