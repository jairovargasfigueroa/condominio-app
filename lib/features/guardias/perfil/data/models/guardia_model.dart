// Clase del modelo para guardia (sin campo zona)
class GuardiaModel {
  final int id;
  final GuardiaUsuarioModel usuario;

  // Constructor parametrizado con datos requeridos
  GuardiaModel({required this.id, required this.usuario});

  // de JSON a Objeto
  factory GuardiaModel.fromJson(Map<String, dynamic> json) {
    return GuardiaModel(
      id: json['id'],
      usuario: GuardiaUsuarioModel.fromJson(json['usuario']),
    );
  }

  // de Objeto a JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'usuario': usuario.toJson()};
  }
}

// Clase del modelo para usuario anidado del guardia
class GuardiaUsuarioModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? telefono;
  final String? fechaNacimiento;
  final String dateJoined;

  // Constructor parametrizado con datos requeridos
  GuardiaUsuarioModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.telefono,
    this.fechaNacimiento,
    required this.dateJoined,
  });

  // de JSON a Objeto
  factory GuardiaUsuarioModel.fromJson(Map<String, dynamic> json) {
    return GuardiaUsuarioModel(
      id: json['id'],
      username: json['username'],
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      telefono: json['telefono'],
      fechaNacimiento: json['fecha_nacimiento'],
      dateJoined: json['date_joined'],
    );
  }

  // de Objeto a JSON
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
    };
  }

  /// Nombre completo del usuario
  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? username : name;
  }
}
