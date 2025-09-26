/// Modelo para la respuesta del login desde tu API
class LoginResponse {
  final bool success;
  final LoginData data;
  final String message;

  LoginResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      data: LoginData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

/// Datos del login que incluye user y tokens
class LoginData {
  final UserData user;
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  LoginData({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: UserData.fromJson(json['user'] ?? {}),
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
    );
  }
}

/// Datos del usuario logueado
class UserData {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String telefono;
  final String fechaNacimiento;
  final String dateJoined;
  final String role; // ✨ NUEVO: rol del usuario (residente/guardia)

  UserData({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.telefono,
    required this.fechaNacimiento,
    required this.dateJoined,
    required this.role, // ✨ NUEVO
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      telefono: json['telefono'] ?? '',
      fechaNacimiento: json['fecha_nacimiento'] ?? '',
      dateJoined: json['date_joined'] ?? '',
      role:
          json['rol'] ??
          'residente', // 🔧 CORREGIDO: backend envía 'rol', no 'role'
    );
  }

  /// Nombre completo del usuario
  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? username : name;
  }
}
