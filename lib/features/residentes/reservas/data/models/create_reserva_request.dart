/// Modelo para crear nueva reserva (POST request)
/// El residenteId se obtiene automáticamente del token JWT en el backend
class CreateReservaRequest {
  final int areaComunId;
  final String fechaReserva;
  final String horaInicio;
  final String horaFin;

  CreateReservaRequest({
    required this.areaComunId,
    required this.fechaReserva,
    required this.horaInicio,
    required this.horaFin,
  });

  /// Convierte a JSON para enviar al backend
  /// El residenteId no se envía - se extrae del token
  Map<String, dynamic> toJson() {
    return {
      'area_comun_id': areaComunId,
      'fecha_reserva': fechaReserva,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
    };
  }

  /// Constructor de conveniencia para debugging
  @override
  String toString() {
    return 'CreateReservaRequest{areaComunId: $areaComunId, fechaReserva: $fechaReserva, horaInicio: $horaInicio, horaFin: $horaFin}';
  }
}
