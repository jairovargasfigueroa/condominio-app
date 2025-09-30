/// Modelo de datos para los comunicados del condominio
///
/// Representa un comunicado basado en la respuesta real de la API
class ComunicadoModel {
  final int id;
  final String titulo;
  final String contenido;
  final DateTime fechaPublicacion;

  ComunicadoModel({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.fechaPublicacion,
  });

  /// Crea una instancia desde JSON (respuesta API)
  factory ComunicadoModel.fromJson(Map<String, dynamic> json) {
    return ComunicadoModel(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      contenido: json['contenido'] as String,
      fechaPublicacion: DateTime.parse(json['fecha_publicacion'] as String),
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'contenido': contenido,
      'fecha_publicacion': fechaPublicacion.toIso8601String(),
    };
  }

  /// Crea una copia con campos modificados
  ComunicadoModel copyWith({
    int? id,
    String? titulo,
    String? contenido,
    DateTime? fechaPublicacion,
  }) {
    return ComunicadoModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      contenido: contenido ?? this.contenido,
      fechaPublicacion: fechaPublicacion ?? this.fechaPublicacion,
    );
  }

  /// Formatea la fecha para mostrar en la UI
  String get fechaFormateada {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fechaPublicacion);

    if (diferencia.inDays == 0) {
      return 'Hoy ${fechaPublicacion.hour.toString().padLeft(2, '0')}:${fechaPublicacion.minute.toString().padLeft(2, '0')}';
    } else if (diferencia.inDays == 1) {
      return 'Ayer ${fechaPublicacion.hour.toString().padLeft(2, '0')}:${fechaPublicacion.minute.toString().padLeft(2, '0')}';
    } else if (diferencia.inDays < 7) {
      return '${diferencia.inDays} días atrás';
    } else {
      return '${fechaPublicacion.day}/${fechaPublicacion.month}/${fechaPublicacion.year}';
    }
  }

  /// Obtiene un preview del contenido (primeras 100 caracteres)
  String get contentPreview {
    if (contenido.length <= 100) return contenido;
    return '${contenido.substring(0, 100)}...';
  }

  @override
  String toString() {
    return 'ComunicadoModel{id: $id, titulo: $titulo}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ComunicadoModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Modelo para la respuesta paginada de la lista de comunicados
/// Basado en la respuesta real de la API
class ComunicadosResponse {
  final bool success;
  final String message;
  final List<ComunicadoModel> data;
  final int totalItems;
  final int totalPages;
  final int currentPage;

  ComunicadosResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
  });

  /// Crea una instancia desde la respuesta JSON de la API
  factory ComunicadosResponse.fromJson(Map<String, dynamic> json) {
    return ComunicadosResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data:
          (json['data'] as List<dynamic>)
              .map(
                (item) =>
                    ComunicadoModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      totalItems: json['total_items'] as int,
      totalPages: json['total_pages'] as int,
      currentPage: json['current_page'] as int,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
      'total_items': totalItems,
      'total_pages': totalPages,
      'current_page': currentPage,
    };
  }
}

/// Modelo para la respuesta de un comunicado individual
/// Basado en la respuesta real de la API
class ComunicadoSingleResponse {
  final bool success;
  final String message;
  final ComunicadoModel data;

  ComunicadoSingleResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Crea una instancia desde la respuesta JSON de la API
  factory ComunicadoSingleResponse.fromJson(Map<String, dynamic> json) {
    return ComunicadoSingleResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ComunicadoModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}
