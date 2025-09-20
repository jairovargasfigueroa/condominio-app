// import 'dart:convert';

//Clase del modelo
class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? telefono;
  final String? fechaNacimiento;
  final String dateJoined;
  //se pone final por buena practica de dart
  //tiene que ver con que lo widget son inmutables
  //entonces es para no crear otro widget al cambiar el estado
  // de l variable

  //constructor parametrizado con datos requeridos
  UserModel({
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
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
