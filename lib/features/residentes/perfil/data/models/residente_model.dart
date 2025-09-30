// Clase del modelo para residente
class ResidenteModel {
  final int id;
  final UsuarioModel usuario;
  final String zona;
  final ViviendaModel? vivienda; // Puede ser null si no tiene vivienda asignada

  // Constructor parametrizado con datos requeridos
  ResidenteModel({
    required this.id,
    required this.usuario,
    required this.zona,
    this.vivienda,
  });

  // de JSON a Objeto
  factory ResidenteModel.fromJson(Map<String, dynamic> json) {
    return ResidenteModel(
      id: json['id'],
      usuario: UsuarioModel.fromJson(json['usuario']),
      zona: json['zona'] ?? '',
      vivienda:
          json['vivienda'] != null
              ? ViviendaModel.fromJson(json['vivienda'])
              : null,
    );
  }

  // de Objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuario.toJson(),
      'zona': zona,
      'vivienda': vivienda?.toJson(),
    };
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

// Clase del modelo para vivienda
class ViviendaModel {
  final int id;
  final String numero;
  final String direccion;
  final CategoriaModel? categoria;
  final CopropietarioModel? copropietario;

  ViviendaModel({
    required this.id,
    required this.numero,
    required this.direccion,
    this.categoria,
    this.copropietario,
  });

  factory ViviendaModel.fromJson(Map<String, dynamic> json) {
    return ViviendaModel(
      id: json['id'],
      numero: json['numero'] ?? '',
      direccion: json['direccion'] ?? '',
      categoria:
          json['categoria'] != null
              ? CategoriaModel.fromJson(json['categoria'])
              : null,
      copropietario:
          json['copropietario'] != null
              ? CopropietarioModel.fromJson(json['copropietario'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'direccion': direccion,
      'categoria': categoria?.toJson(),
      'copropietario': copropietario?.toJson(),
    };
  }
}

// Clase del modelo para categoria de vivienda
class CategoriaModel {
  final int id;
  final String nombre;
  final String? descripcion;

  CategoriaModel({required this.id, required this.nombre, this.descripcion});

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'descripcion': descripcion};
  }
}

// Clase del modelo para copropietario
class CopropietarioModel {
  final int id;
  final String nombre;
  final String? apellido;
  final String? telefono;
  final String? email;

  CopropietarioModel({
    required this.id,
    required this.nombre,
    this.apellido,
    this.telefono,
    this.email,
  });

  factory CopropietarioModel.fromJson(Map<String, dynamic> json) {
    return CopropietarioModel(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'],
      telefono: json['telefono'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'email': email,
    };
  }
}
