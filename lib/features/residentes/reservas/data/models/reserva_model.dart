class ReservaModel {
  final int id;
  final ResidenteDetalle residente;
  final AreaComunDetalle areaComun;
  final String fechaReserva;
  final String horaInicio;
  final String horaFin;
  final String montoPagado;
  final String estado;
  final String? metodoPago;

  const ReservaModel({
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

  factory ReservaModel.fromJson(Map<String, dynamic> json) {
    return ReservaModel(
      id: json['id'],
      residente: ResidenteDetalle.fromJson(json['residente']),
      areaComun: AreaComunDetalle.fromJson(json['area_comun']),
      fechaReserva: json['fecha_reserva'],
      horaInicio: json['hora_inicio'],
      horaFin: json['hora_fin'],
      montoPagado: json['monto_pagado'],
      estado: json['estado'],
      metodoPago: json['metodo_pago'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'residente': residente.toJson(),
      'area_comun': areaComun.toJson(),
      'fecha_reserva': fechaReserva,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'monto_pagado': montoPagado,
      'estado': estado,
      'metodo_pago': metodoPago,
    };
  }

  /// Crea una copia de la reserva con algunos campos actualizados
  ReservaModel copyWith({
    int? id,
    ResidenteDetalle? residente,
    AreaComunDetalle? areaComun,
    String? fechaReserva,
    String? horaInicio,
    String? horaFin,
    String? montoPagado,
    String? estado,
    String? metodoPago,
  }) {
    return ReservaModel(
      id: id ?? this.id,
      residente: residente ?? this.residente,
      areaComun: areaComun ?? this.areaComun,
      fechaReserva: fechaReserva ?? this.fechaReserva,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      montoPagado: montoPagado ?? this.montoPagado,
      estado: estado ?? this.estado,
      metodoPago: metodoPago ?? this.metodoPago,
    );
  }

  /// Getters de conveniencia para la UI
  DateTime get fechaReservaDateTime => DateTime.parse(fechaReserva);

  String get horarioCompleto => '$horaInicio - $horaFin';

  bool get esGratuita => areaComun.tipo == 'gratuita';

  bool get estaPendiente => estado == 'pendiente';

  bool get estaConfirmada => estado == 'confirmada';

  bool get estaCompletada => estado == 'completada';

  @override
  String toString() {
    return 'ReservaModel(id: $id, areaComun: ${areaComun.nombre}, fecha: $fechaReserva, estado: $estado)';
  }
}

class ResidenteDetalle {
  final int id;
  final UsuarioDetalle usuario;
  final String zona;

  const ResidenteDetalle({
    required this.id,
    required this.usuario,
    required this.zona,
  });

  factory ResidenteDetalle.fromJson(Map<String, dynamic> json) {
    return ResidenteDetalle(
      id: json['id'],
      usuario: UsuarioDetalle.fromJson(json['usuario']),
      zona: json['zona'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'usuario': usuario.toJson(), 'zona': zona};
  }
}

class UsuarioDetalle {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String telefono;
  final String fechaNacimiento;
  final String dateJoined;
  final String rol;

  const UsuarioDetalle({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.telefono,
    required this.fechaNacimiento,
    required this.dateJoined,
    required this.rol,
  });

  String get nombreCompleto => '$firstName $lastName';

  factory UsuarioDetalle.fromJson(Map<String, dynamic> json) {
    return UsuarioDetalle(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      telefono: json['telefono'],
      fechaNacimiento: json['fecha_nacimiento'],
      dateJoined: json['date_joined'],
      rol: json['rol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'telefono': telefono,
      'fecha_nacimiento': fechaNacimiento,
      'date_joined': dateJoined,
      'rol': rol,
    };
  }
}

class AreaComunDetalle {
  final int id;
  final String nombre;
  final String tipo;
  final String costo;

  const AreaComunDetalle({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.costo,
  });

  factory AreaComunDetalle.fromJson(Map<String, dynamic> json) {
    return AreaComunDetalle(
      id: json['id'],
      nombre: json['nombre'],
      tipo: json['tipo'],
      costo: json['costo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'tipo': tipo, 'costo': costo};
  }

  bool get esGratuita => tipo == 'gratuita';
  double get costoNumerico => double.tryParse(costo) ?? 0.0;
}

/// Modelo para la respuesta paginada del backend
class ReservasResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<ReservaModel> results;

  const ReservasResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ReservasResponse.fromJson(Map<String, dynamic> json) {
    return ReservasResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results:
          (json['results'] as List)
              .map((item) => ReservaModel.fromJson(item))
              .toList(),
    );
  }
}
