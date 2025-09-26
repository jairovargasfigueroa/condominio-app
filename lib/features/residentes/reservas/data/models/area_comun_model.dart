/// Modelo para área común (para dropdown de selección)
class AreaComun {
  final int id;
  final String nombre;
  final String tipo;
  final String costo;
  final String? descripcion;

  AreaComun({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.costo,
    this.descripcion,
  });

  factory AreaComun.fromJson(Map<String, dynamic> json) {
    return AreaComun(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      tipo: json['tipo'] ?? '',
      costo: json['costo'] ?? '0',
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'costo': costo,
      'descripcion': descripcion,
    };
  }

  /// Getters de conveniencia
  double get costoNumerico => double.tryParse(costo) ?? 0.0;
  bool get esGratuita => tipo == 'gratuita';
  String get displayText => '$nombre - \$${costo}';

  /// Para usar en dropdowns
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AreaComun && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => displayText;
}
