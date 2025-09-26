import 'dart:convert';

import 'package:my_flutter_app/core/api/api_client.dart';
import 'package:my_flutter_app/features/guardias/perfil/data/models/guardia_model.dart';
import 'package:my_flutter_app/features/guardias/perfil/data/models/guardia_perfil_response_model.dart';

class GuardiaRemoteService {
  /// Obtiene el perfil del guardia logueado usando el token del header
  /// API: GET /api/guardias/perfil/
  /// No requiere parámetros - usa el token para identificar al usuario
  Future<GuardiaPerfilData> getPerfilActual() async {
    final response = await ApiClient.get('/api/guardias/perfil/');

    print('📡 GET Guardia Perfil Status Code: ${response.statusCode}');
    print('📦 GET Guardia Perfil Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ Perfil de guardia obtenido exitosamente');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final guardiaPerfilResponse = GuardiaPerfilResponse.fromJson(
        jsonResponse,
      );

      if (guardiaPerfilResponse.success) {
        return guardiaPerfilResponse.data;
      } else {
        throw Exception(guardiaPerfilResponse.message);
      }
    } else {
      print('❌ Error al obtener perfil de guardia: ${response.statusCode}');
      throw Exception('Error al cargar perfil del guardia logueado');
    }
  }

  /// Método para obtener guardia por ID (compatibilidad futura)
  Future<GuardiaModel> getGuardia(int id) async {
    final response = await ApiClient.get('/api/guardias/$id/');

    print('📡 Status Code: ${response.statusCode}');
    print('📦 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ Petición exitosa');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print('🔍 Estructura del JSON: ${jsonResponse.keys}');

      return GuardiaModel.fromJson(jsonResponse);
    } else {
      print('❌ Error en petición: ${response.statusCode}');
      throw Exception('Error al cargar guardia');
    }
  }
}
