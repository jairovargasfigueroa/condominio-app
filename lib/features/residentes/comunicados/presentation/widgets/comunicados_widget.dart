// comunicados_widget.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/comunicado_model.dart';

class ComunicadosWidget extends StatelessWidget {
  final List<ComunicadoModel> comunicados;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRefresh;

  const ComunicadosWidget({
    Key? key,
    required this.comunicados,
    required this.isLoading,
    this.errorMessage,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✨ Si hay error, mostrarlo
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: onRefresh, child: Text('Reintentar')),
          ],
        ),
      );
    }

    // ✨ Si está cargando, mostrar indicador
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando comunicados...', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    // ✨ Si no hay comunicados
    if (comunicados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, color: Colors.grey, size: 64),
            SizedBox(height: 16),
            Text(
              'No hay comunicados disponibles',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Desliza hacia abajo para actualizar',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    // ✨ Lista de comunicados con RefreshIndicator
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        // Esperar un poco para que se vea el indicador
        await Future.delayed(Duration(milliseconds: 500));
      },
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: comunicados.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final comunicado = comunicados[index];
          return ComunicadoCard(
            comunicado: comunicado,
            onTap: () {
              // Navegar al detalle
              context.push('/residente/comunicado/${comunicado.id}');
            },
          );
        },
      ),
    );
  }
}

/// Card individual de comunicado
class ComunicadoCard extends StatelessWidget {
  final ComunicadoModel comunicado;
  final VoidCallback onTap;

  const ComunicadoCard({
    Key? key,
    required this.comunicado,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con fecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _formatearFecha(comunicado.fechaPublicacion),
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Título
              Text(
                comunicado.titulo,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),

              // Preview del contenido
              Text(
                comunicado.contenido,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha).inDays;

    if (diferencia == 0) {
      return 'Hoy';
    } else if (diferencia == 1) {
      return 'Ayer';
    } else if (diferencia < 7) {
      return 'Hace $diferencia días';
    } else {
      return '${fecha.day}/${fecha.month}/${fecha.year}';
    }
  }
}
