class FacialValidationResult {
  final bool success;
  final String message;
  final FacialValidationData? data;

  FacialValidationResult({
    required this.success,
    required this.message,
    this.data,
  });

  factory FacialValidationResult.fromJson(Map<String, dynamic> json) {
    return FacialValidationResult(
      success: json['success'] as bool,
      message: json['message'] as String,
      data:
          json['data'] != null
              ? FacialValidationData.fromJson(json['data'])
              : null,
    );
  }

  @override
  String toString() {
    return 'FacialValidationResult(success: $success, message: $message, data: $data)';
  }
}

class FacialValidationData {
  final FacialValidationUser user;
  final double confidence;
  final String faceId;

  FacialValidationData({
    required this.user,
    required this.confidence,
    required this.faceId,
  });

  factory FacialValidationData.fromJson(Map<String, dynamic> json) {
    return FacialValidationData(
      user: FacialValidationUser.fromJson(json['user']),
      confidence: (json['confidence'] as num).toDouble(),
      faceId: json['face_id'] as String,
    );
  }

  @override
  String toString() {
    return 'FacialValidationData(user: $user, confidence: $confidence, faceId: $faceId)';
  }
}

class FacialValidationUser {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String? fotoPerfilUrl;

  FacialValidationUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.fotoPerfilUrl,
  });

  factory FacialValidationUser.fromJson(Map<String, dynamic> json) {
    return FacialValidationUser(
      id: json['id'] as int,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      fotoPerfilUrl: json['foto_perfil_url'] as String?,
    );
  }

  String get fullName {
    final first = firstName.trim();
    final last = lastName.trim();
    if (first.isEmpty && last.isEmpty) return username;
    return '$first $last'.trim();
  }

  @override
  String toString() {
    return 'FacialValidationUser(id: $id, username: $username, firstName: $firstName, lastName: $lastName, fotoPerfilUrl: $fotoPerfilUrl)';
  }
}
