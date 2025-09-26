import 'dart:convert';

import 'package:my_flutter_app/core/api/api_client.dart';
import 'package:my_flutter_app/features/residentes/perfil/data/models/residente_model.dart';
import 'package:my_flutter_app/features/residentes/perfil/data/models/perfil_response_model.dart';

class ResidenteRemoteService {
  /// Obtiene el perfil del residente logueado usando el token del header
  /// API: GET /api/residentes/perfil/
  /// No requiere parámetros - usa el token para identificar al usuario
  Future<PerfilData> getPerfilActual() async {
    final response = await ApiClient.get('/api/residentes/perfil/');

    print('📡 GET Perfil Status Code: ${response.statusCode}');
    print('📦 GET Perfil Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ Perfil obtenido exitosamente');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final perfilResponse = PerfilResponse.fromJson(jsonResponse);

      if (perfilResponse.success) {
        return perfilResponse.data;
      } else {
        throw Exception(perfilResponse.message);
      }
    } else {
      print('❌ Error al obtener perfil: ${response.statusCode}');
      throw Exception('Error al cargar perfil del usuario logueado');
    }
  }

  /// Método original para obtener residente por ID (mantener por compatibilidad)
  Future<ResidenteModel> getResidente(int id) async {
    final response = await ApiClient.get('/api/residentes/$id/');

    print(
      '📡 Status Code: ${response.statusCode}',
    ); // ← Ver código de respuesta
    print('📦 Response Body: ${response.body}'); // ← Ver JSON completo

    if (response.statusCode == 200) {
      print('✅ Petición exitosa');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print('🔍 Estructura del JSON: ${jsonResponse.keys}');

      final Map<String, dynamic> residenteData =
          jsonResponse['data']; // ← O la clave que uses
      return ResidenteModel.fromJson(residenteData);
    } else {
      print('❌ Error en petición: ${response.statusCode}');
      throw Exception('Error al cargar residente');
    }
  }
}
