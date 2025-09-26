import 'dart:convert';

import 'package:my_flutter_app/core/api/api_client.dart';
import 'package:my_flutter_app/features/guardias/accesos/data/models/create_acceso_request.dart';
import 'package:my_flutter_app/features/guardias/accesos/data/models/acceso_response_model.dart';
import 'package:my_flutter_app/features/guardias/accesos/data/models/create_acceso_result.dart';

class AccesosRemoteService {
  /// Crea un nuevo registro de acceso
  /// API: POST /api/accesos/
  /// Body: CreateAccesoRequest en formato JSON
  Future<CreateAccesoResult> createAcceso(CreateAccesoRequest request) async {
    const endpoint = '/api/accesos/';
    final response = await ApiClient.post(endpoint, body: request.toJson());

    print('📡 POST Create Acceso Status Code: ${response.statusCode}');
    print('📦 POST Create Acceso Request Body: ${request.toString()}');
    print('📦 POST Create Acceso Response Body: ${response.body}');

    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (response.statusCode == 201) {
      // 201 CREATED - Éxito
      print('✅ Acceso creado exitosamente');

      return CreateAccesoResult(
        success: jsonResponse['success'] as bool,
        message: jsonResponse['message'] as String,
        data: AccesoData.fromJson(jsonResponse['data']),
      );
    } else {
      // Errores: 400, 422, 500, etc.
      print('❌ Error al crear acceso: ${response.statusCode}');

      return CreateAccesoResult(
        success: jsonResponse['success'] as bool? ?? false,
        message: jsonResponse['message'] as String,
        data: null,
      );
    }
  }
}
