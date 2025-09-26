import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/features/guardias/perfil/presentation/providers/guardia_provider.dart';

class GuardiaWidget extends StatelessWidget {
  const GuardiaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GuardiaProvider>(
      builder: (context, guardiaProvider, child) {
        final perfil = guardiaProvider.perfilGuardia;

        if (perfil == null) {
          return const Center(
            child: Text('No hay información del guardia disponible'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con información básica
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            guardiaProvider.nombreCompleto.isNotEmpty
                                ? guardiaProvider.nombreCompleto[0]
                                    .toUpperCase()
                                : 'G',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guardiaProvider.nombreCompleto,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Guardia de Seguridad',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    guardiaProvider.activo
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color:
                                        guardiaProvider.activo
                                            ? Colors.green
                                            : Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    guardiaProvider.activo
                                        ? 'Activo'
                                        : 'Inactivo',
                                    style: TextStyle(
                                      color:
                                          guardiaProvider.activo
                                              ? Colors.green
                                              : Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Información de contacto
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información de Contacto',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      Icons.email,
                      'Email',
                      guardiaProvider.email,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      Icons.phone,
                      'Teléfono',
                      guardiaProvider.telefono,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Información laboral
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información Laboral',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      Icons.schedule,
                      'Turno',
                      guardiaProvider.turno,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      Icons.badge,
                      'ID Guardia',
                      '#${perfil.id}',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      Icons.person,
                      'Usuario',
                      perfil.usuario.username,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botón de actualizar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    guardiaProvider.isLoading
                        ? null
                        : () {
                          guardiaProvider.reloadPerfil();
                        },
                icon:
                    guardiaProvider.isLoading
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.refresh),
                label: Text(
                  guardiaProvider.isLoading
                      ? 'Actualizando...'
                      : 'Actualizar Información',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : 'No disponible',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
