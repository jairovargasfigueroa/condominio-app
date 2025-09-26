/// Modelo para crear un nuevo acceso (POST request)
class CreateAccesoRequest {
  final int usuario;
  final String tipoAcceso;

  CreateAccesoRequest({required this.usuario, required this.tipoAcceso});

  /// Convierte a JSON para enviar al backend
  Map<String, dynamic> toJson() {
    return {'usuario_id': usuario, 'tipo_acceso': tipoAcceso};
  }

  /// Constructor de conveniencia para debugging
  @override
  String toString() {
    return 'CreateAccesoRequest{usuario: $usuario, tipoAcceso: $tipoAcceso}';
  }
}
