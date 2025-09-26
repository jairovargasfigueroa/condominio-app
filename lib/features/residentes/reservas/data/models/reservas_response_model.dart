/// Modelo para la respuesta de la API /api/reservas/mis-reservas/
class ReservasResponse {
  final bool success;
  final ReservasData data;
  final String message;
  final int? totalItems;
  final int? totalPages;
  final int? currentPage;

  ReservasResponse({
    required this.success,
    required this.data,
    required this.message,
    this.totalItems,
    this.totalPages,
    this.currentPage,
  });

  factory ReservasResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Manejar tanto el caso donde data es una lista como donde es un objeto
      ReservasData dataObj;
      if (json['data'] is List) {
        // Si data es una lista directa, crear ReservasData con esa lista
        dataObj = ReservasData(
          count: json['total_items'] ?? 0,
          next: null,
          previous: null,
          results: ReservasData.parseResultsFromList(json['data']),
        );
      } else {
        // Si data es un objeto, parsearlo normalmente
        dataObj = ReservasData.fromJson(json['data'] ?? {});
      }

      return ReservasResponse(
        success: json['success'] ?? false,
        data: dataObj,
        message: json['message'] ?? '',
        totalItems: json['total_items'],
        totalPages: json['total_pages'],
        currentPage: json['current_page'],
      );
    } catch (e) {
      // Si hay error en el parsing, devolver respuesta vacía pero válida
      return ReservasResponse(
        success: false,
        data: ReservasData.empty(),
        message: 'Error al procesar respuesta: $e',
      );
    }
  }
}

/// Datos paginados de reservas
class ReservasData {
  final int count;
  final String? next;
  final String? previous;
  final List<ReservaDetalle> results;

  ReservasData({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ReservasData.fromJson(Map<String, dynamic> json) {
    return ReservasData(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: parseResultsFromList(json['results']),
    );
  }

  /// Constructor para crear ReservasData vacío
  factory ReservasData.empty() {
    return ReservasData(count: 0, next: null, previous: null, results: []);
  }

  /// Método estático para parsear lista de reservas de manera segura
  static List<ReservaDetalle> parseResultsFromList(dynamic data) {
    try {
      if (data == null) return [];
      if (data is! List) return [];

      return data
          .map((item) {
            try {
              return ReservaDetalle.fromJson(item as Map<String, dynamic>);
            } catch (e) {
              print('❌ Error parseando reserva individual: $e');
              return null;
            }
          })
          .where((item) => item != null)
          .cast<ReservaDetalle>()
          .toList();
    } catch (e) {
      print('❌ Error parseando lista de reservas: $e');
      return [];
    }
  }

  /// Getters de conveniencia
  bool get isEmpty => results.isEmpty;
  bool get isNotEmpty => results.isNotEmpty;
  int get length => results.length;
}

/// Modelo simplificado para una reserva individual
class ReservaDetalle {
  final int id;
  final ResidenteBasico residente;
  final AreaComunBasica areaComun;
  final String fechaReserva;
  final String horaInicio;
  final String horaFin;
  final String montoPagado;
  final String estado;
  final String? metodoPago;

  ReservaDetalle({
    required this.id,
    required this.residente,
    required this.areaComun,
    required this.fechaReserva,
    required this.horaInicio,
    required this.horaFin,
    required this.montoPagado,
    required this.estado,
    this.metodoPago,
  });

  factory ReservaDetalle.fromJson(Map<String, dynamic> json) {
    return ReservaDetalle(
      id: json['id'] ?? 0,
      residente: ResidenteBasico.fromJson(json['residente'] ?? {}),
      areaComun: AreaComunBasica.fromJson(json['area_comun'] ?? {}),
      fechaReserva: json['fecha_reserva'] ?? '',
      horaInicio: json['hora_inicio'] ?? '',
      horaFin: json['hora_fin'] ?? '',
      montoPagado: json['monto_pagado'] ?? '0',
      estado: json['estado'] ?? '',
      metodoPago: json['metodo_pago'],
    );
  }

  /// Getters de conveniencia para la UI
  DateTime get fechaReservaDateTime =>
      DateTime.tryParse(fechaReserva) ?? DateTime.now();

  String get horarioCompleto => '$horaInicio - $horaFin';

  bool get esGratuita => areaComun.esGratuita;

  bool get estaPendiente => estado == 'pendiente';

  bool get estaConfirmada => estado == 'confirmada';

  bool get estaCompletada => estado == 'completada';
}

/// Información básica del residente para las reservas
class ResidenteBasico {
  final int id;
  final UsuarioBasico usuario;
  final String zona;

  ResidenteBasico({
    required this.id,
    required this.usuario,
    required this.zona,
  });

  factory ResidenteBasico.fromJson(Map<String, dynamic> json) {
    return ResidenteBasico(
      id: json['id'] ?? 0,
      usuario: UsuarioBasico.fromJson(json['usuario'] ?? {}),
      zona: json['zona'] ?? '',
    );
  }
}

/// Información básica del usuario para las reservas
class UsuarioBasico {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;

  UsuarioBasico({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory UsuarioBasico.fromJson(Map<String, dynamic> json) {
    return UsuarioBasico(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  /// Nombre completo del usuario
  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? username : name;
  }
}

/// Información básica del área común para las reservas
class AreaComunBasica {
  final int id;
  final String nombre;
  final String tipo;
  final String costo;

  AreaComunBasica({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.costo,
  });

  factory AreaComunBasica.fromJson(Map<String, dynamic> json) {
    return AreaComunBasica(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      tipo: json['tipo'] ?? '',
      costo: json['costo'] ?? '0',
    );
  }

  bool get esGratuita => tipo == 'gratuita';
  double get costoNumerico => double.tryParse(costo) ?? 0.0;
}
