/// Modelo de datos para las expensas del residente
///
/// Representa una expensa basada en la respuesta real de la API
class ExpensaModel {
  final int id;
  final ViviendaModel vivienda;
  final int mes;
  final int anio;
  final String montoPagado;
  final String estado;
  final String? metodoPago;
  final DateTime fechaVencimiento;
  final DateTime fechaCreacion;

  ExpensaModel({
    required this.id,
    required this.vivienda,
    required this.mes,
    required this.anio,
    required this.montoPagado,
    required this.estado,
    this.metodoPago,
    required this.fechaVencimiento,
    required this.fechaCreacion,
  });

  /// Crea una instancia desde JSON (respuesta API)
  factory ExpensaModel.fromJson(Map<String, dynamic> json) {
    return ExpensaModel(
      id: json['id'] as int,
      vivienda: ViviendaModel.fromJson(json['vivienda']),
      mes: json['mes'] as int,
      anio: json['año'] as int, // En el JSON viene como 'año'
      montoPagado: json['monto_pagado'] as String,
      estado: json['estado'] as String,
      metodoPago: json['metodo_pago'] as String?,
      fechaVencimiento: DateTime.parse(json['fecha_vencimiento'] as String),
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vivienda': vivienda.toJson(),
      'mes': mes,
      'año': anio, // En el JSON se envía como 'año'
      'monto_pagado': montoPagado,
      'estado': estado,
      'metodo_pago': metodoPago,
      'fecha_vencimiento': fechaVencimiento.toIso8601String(),
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }

  /// Crea una copia con campos modificados
  ExpensaModel copyWith({
    int? id,
    ViviendaModel? vivienda,
    int? mes,
    int? anio,
    String? montoPagado,
    String? estado,
    String? metodoPago,
    DateTime? fechaVencimiento,
    DateTime? fechaCreacion,
  }) {
    return ExpensaModel(
      id: id ?? this.id,
      vivienda: vivienda ?? this.vivienda,
      mes: mes ?? this.mes,
      anio: anio ?? this.anio,
      montoPagado: montoPagado ?? this.montoPagado,
      estado: estado ?? this.estado,
      metodoPago: metodoPago ?? this.metodoPago,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  /// Getter para obtener el monto como double
  double get montoComoDouble {
    return double.tryParse(montoPagado) ?? 0.0;
  }

  /// Getter para el nombre del mes
  String get nombreMes {
    const meses = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return meses[mes];
  }

  /// Getter para descripción completa
  String get descripcionCompleta {
    return 'Expensa $nombreMes $anio';
  }

  /// Verifica si la expensa está vencida
  bool get estaVencida {
    return estado == 'pendiente' && DateTime.now().isAfter(fechaVencimiento);
  }

  @override
  String toString() {
    return 'ExpensaModel(id: $id, descripcion: $descripcionCompleta, estado: $estado)';
  }
}

/// Modelo para los datos de vivienda dentro de la expensa
class ViviendaModel {
  final int id;
  final String numero;
  final String direccion;

  ViviendaModel({
    required this.id,
    required this.numero,
    required this.direccion,
  });

  factory ViviendaModel.fromJson(Map<String, dynamic> json) {
    return ViviendaModel(
      id: json['id'] as int,
      numero: json['numero'] as String,
      direccion: json['direccion'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'numero': numero, 'direccion': direccion};
  }

  @override
  String toString() {
    return 'ViviendaModel(numero: $numero, direccion: $direccion)';
  }
}

/// Modelo para la respuesta de lista de expensas
class ExpensasResponse {
  final bool success;
  final String message;
  final List<ExpensaModel> results; // Mantenemos 'results' como nombre interno
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final InfoExpensas? info;

  ExpensasResponse({
    required this.success,
    required this.message,
    required this.results,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    this.info,
  });

  factory ExpensasResponse.fromJson(Map<String, dynamic> json) {
    // La respuesta viene con 'data' pero internamente usamos 'results'
    final dataList = json['data'] as List<dynamic>? ?? [];

    return ExpensasResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      results:
          dataList
              .map(
                (item) => ExpensaModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      totalItems: json['total_items'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 0,
      currentPage: json['current_page'] as int? ?? 0,
      info:
          json['info'] != null
              ? InfoExpensas.fromJson(json['info'] as Map<String, dynamic>)
              : null,
    );
  }
}

/// Modelo para la información adicional en la respuesta de expensas
class InfoExpensas {
  final String tipoUsuario;
  final bool tieneVivienda;
  final String mensaje;

  InfoExpensas({
    required this.tipoUsuario,
    required this.tieneVivienda,
    required this.mensaje,
  });

  factory InfoExpensas.fromJson(Map<String, dynamic> json) {
    return InfoExpensas(
      tipoUsuario: json['tipo_usuario'] as String? ?? '',
      tieneVivienda: json['tiene_vivienda'] as bool? ?? false,
      mensaje: json['mensaje'] as String? ?? '',
    );
  }
}
