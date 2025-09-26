/// Modelo para representar un acceso
class AccesoModel {
  final int id;
  final int usuario;
  final String tipoAcceso;
  final DateTime fechaHora;

  AccesoModel({
    required this.id,
    required this.usuario,
    required this.tipoAcceso,
    required this.fechaHora,
  });

  /// Constructor desde JSON
  factory AccesoModel.fromJson(Map<String, dynamic> json) {
    return AccesoModel(
      id: json['id'] as int,
      usuario: json['usuario'] as int,
      tipoAcceso: json['tipo_acceso'] as String,
      fechaHora: DateTime.parse(json['fecha_hora'] as String),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuario,
      'tipo_acceso': tipoAcceso,
      'fecha_hora': fechaHora.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'AccesoModel{id: $id, usuario: $usuario, tipoAcceso: $tipoAcceso, fechaHora: $fechaHora}';
  }
}
