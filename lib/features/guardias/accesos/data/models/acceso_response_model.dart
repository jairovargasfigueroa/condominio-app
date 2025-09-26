/// Modelo para la respuesta del API al crear un acceso
class AccesoResponse {
  final bool success;
  final String message;
  final AccesoData? data;

  AccesoResponse({required this.success, required this.message, this.data});

  factory AccesoResponse.fromJson(Map<String, dynamic> json) {
    return AccesoResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? AccesoData.fromJson(json['data']) : null,
    );
  }
}

/// Datos del acceso en la respuesta
class AccesoData {
  final int id;
  final UsuarioData usuario;
  final String fecha;
  final String hora;
  final String tipoAcceso;

  AccesoData({
    required this.id,
    required this.usuario,
    required this.fecha,
    required this.hora,
    required this.tipoAcceso,
  });

  factory AccesoData.fromJson(Map<String, dynamic> json) {
    return AccesoData(
      id: json['id'] as int,
      usuario: UsuarioData.fromJson(json['usuario']),
      fecha: json['fecha'] as String,
      hora: json['hora'] as String,
      tipoAcceso: json['tipo_acceso'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuario.toJson(),
      'fecha': fecha,
      'hora': hora,
      'tipo_acceso': tipoAcceso,
    };
  }
}

/// Datos del usuario en la respuesta del acceso
class UsuarioData {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? telefono;
  final String? fotoPerfilUrl;

  UsuarioData({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.telefono,
    this.fotoPerfilUrl,
  });

  factory UsuarioData.fromJson(Map<String, dynamic> json) {
    return UsuarioData(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      telefono: json['telefono'] as String?,
      fotoPerfilUrl: json['foto_perfil_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      if (telefono != null) 'telefono': telefono,
      if (fotoPerfilUrl != null) 'foto_perfil_url': fotoPerfilUrl,
    };
  }

  /// Nombre completo del usuario
  String get nombreCompleto => '$firstName $lastName';
}
