import 'residente_model.dart';

/// Modelo para la respuesta de la API /api/residentes/perfil/
class PerfilResponse {
  final bool success;
  final PerfilData data;
  final String message;

  PerfilResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory PerfilResponse.fromJson(Map<String, dynamic> json) {
    return PerfilResponse(
      success: json['success'] ?? false,
      data: PerfilData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

/// Datos del perfil del residente logueado
class PerfilData {
  final int id;
  final UsuarioData usuario;
  final String zona;
  final ViviendaModel? vivienda; // Puede ser null si no tiene vivienda asignada

  PerfilData({
    required this.id,
    required this.usuario,
    required this.zona,
    this.vivienda,
  });

  factory PerfilData.fromJson(Map<String, dynamic> json) {
    return PerfilData(
      id: json['id'] ?? 0,
      usuario: UsuarioData.fromJson(json['usuario'] ?? {}),
      zona: json['zona'] ?? '',
      vivienda:
          json['vivienda'] != null
              ? ViviendaModel.fromJson(json['vivienda'])
              : null,
    );
  }
}

/// Datos del usuario dentro del perfil
class UsuarioData {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String telefono;
  final String fechaNacimiento;
  final String dateJoined;

  UsuarioData({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.telefono,
    required this.fechaNacimiento,
    required this.dateJoined,
  });

  factory UsuarioData.fromJson(Map<String, dynamic> json) {
    return UsuarioData(
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
