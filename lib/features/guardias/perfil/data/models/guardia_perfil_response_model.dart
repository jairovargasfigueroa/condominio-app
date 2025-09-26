/// Modelo para la respuesta de la API /api/guardias/perfil/
class GuardiaPerfilResponse {
  final bool success;
  final GuardiaPerfilData data;
  final String message;

  GuardiaPerfilResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory GuardiaPerfilResponse.fromJson(Map<String, dynamic> json) {
    return GuardiaPerfilResponse(
      success: json['success'] ?? false,
      data: GuardiaPerfilData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

/// Datos del perfil del guardia logueado (sin campo zona/area)
class GuardiaPerfilData {
  final int id;
  final GuardiaUsuarioData usuario;
  final String telefono;
  final String turno;
  final bool activo;

  GuardiaPerfilData({
    required this.id,
    required this.usuario,
    required this.telefono,
    required this.turno,
    required this.activo,
  });

  factory GuardiaPerfilData.fromJson(Map<String, dynamic> json) {
    return GuardiaPerfilData(
      id: json['id'] ?? 0,
      usuario: GuardiaUsuarioData.fromJson(json['usuario'] ?? {}),
      telefono: json['telefono'] ?? '',
      turno: json['turno'] ?? '',
      activo: json['activo'] ?? false,
    );
  }
}

/// Datos del usuario dentro del perfil del guardia
class GuardiaUsuarioData {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String telefono;
  final String fechaNacimiento;
  final String dateJoined;

  GuardiaUsuarioData({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.telefono,
    required this.fechaNacimiento,
    required this.dateJoined,
  });

  factory GuardiaUsuarioData.fromJson(Map<String, dynamic> json) {
    return GuardiaUsuarioData(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      telefono: json['telefono'] ?? '',
      fechaNacimiento: json['fecha_nacimiento'] ?? '',
      dateJoined: json['date_joined'] ?? '',
    );
  }

  /// Nombre completo del usuario
  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? username : name;
  }
}
