// reservas_widget.dart
import 'package:flutter/material.dart';
import '../../data/models/reserva_model.dart';
import '../../data/models/reservas_response_model.dart';

class ReservasWidget extends StatelessWidget {
  final List<ReservaModel>? reservas;
  final ReservasData? reservasData; // ✨ Nuevo: datos de respuesta automática
  final bool isLoading;
  final String? errorMessage; // ✨ Nuevo: manejo de errores
  final Function() onLoadReservas;

  const ReservasWidget({
    Key? key,
    required this.reservas,
    this.reservasData, // ✨ Opcional porque puede no estar cargado aún
    required this.isLoading,
    this.errorMessage, // ✨ Opcional
    required this.onLoadReservas,
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
            ElevatedButton(
              onPressed: () => onLoadReservas(), // Botón de retry
              child: Text('Reintentar'),
            ),
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
            Text('Cargando reservas...'),
          ],
        ),
      );
    }

    // ✨ Si tenemos datos de reservas, mostrarlos automáticamente
    if (reservas != null && reservas!.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () async => onLoadReservas(),
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: reservas!.length,
          itemBuilder: (context, index) {
            final reserva = reservas![index];
            return _buildReservaCard(reserva);
          },
        ),
      );
    }

    // ✨ Si no hay reservas, mostrar mensaje vacío
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No tienes reservas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Cuando hagas una reserva aparecerá aquí',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => onLoadReservas(),
            child: Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildReservaCard(ReservaModel reserva) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event, color: Colors.blue, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    reserva.areaComun.nombre,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                _buildEstadoBadge(reserva.estado),
              ],
            ),
            Divider(height: 24),

            // Información de la reserva
            _buildInfoSection('Detalles de la Reserva', [
              _buildInfoRow('Fecha', reserva.fechaReserva),
              _buildInfoRow(
                'Horario',
                '${reserva.horaInicio} - ${reserva.horaFin}',
              ),
              _buildInfoRow('Monto', reserva.montoPagado),
              if (reserva.metodoPago != null)
                _buildInfoRow('Método de Pago', reserva.metodoPago!),
            ]),

            SizedBox(height: 16),

            // Información del área común
            _buildInfoSection('Área Común', [
              _buildInfoRow('Tipo', reserva.areaComun.tipo),
              _buildInfoRow('Costo', reserva.areaComun.costo),
            ]),

            SizedBox(height: 16),

            // Información del residente
            _buildInfoSection('Residente', [
              _buildInfoRow('Nombre', reserva.residente.usuario.nombreCompleto),
              _buildInfoRow('Zona', reserva.residente.zona),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[800])),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoBadge(String estado) {
    Color color;
    String texto;

    switch (estado.toLowerCase()) {
      case 'confirmada':
        color = Colors.green;
        texto = 'Confirmada';
        break;
      case 'pendiente':
        color = Colors.orange;
        texto = 'Pendiente';
        break;
      case 'cancelada':
        color = Colors.red;
        texto = 'Cancelada';
        break;
      default:
        color = Colors.grey;
        texto = estado.toUpperCase();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
