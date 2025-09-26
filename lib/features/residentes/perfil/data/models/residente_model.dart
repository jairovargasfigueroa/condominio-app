// Clase del modelo para residente
class ResidenteModel {
  final int id;
  final UsuarioModel usuario;
  final String zona;

  // Constructor parametrizado con datos requeridos
  ResidenteModel({required this.id, required this.usuario, required this.zona});

  // de JSON a Objeto
  factory ResidenteModel.fromJson(Map<String, dynamic> json) {
    return ResidenteModel(
      id: json['id'],
      usuario: UsuarioModel.fromJson(json['usuario']),
      zona: json['zona'] ?? '',
    );
  }

  // de Objeto a JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'usuario': usuario.toJson(), 'zona': zona};
  }
}

// Clase del modelo para usuario anidado
class UsuarioModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? telefono;
  final String? fechaNacimiento;
  final String dateJoined;

  // Constructor parametrizado con datos requeridos
  UsuarioModel({
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
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
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
}
