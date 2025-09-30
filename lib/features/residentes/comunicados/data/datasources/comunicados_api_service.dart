import 'dart:convert';
import '../../../../../core/api/api_client.dart';
import '../models/comunicado_model.dart';

/// Servicio para manejar las operaciones de comunicados con la API
///
/// Maneja todas las llamadas HTTP relacionadas con comunicados:
/// - Obtener lista de comunicados
/// - Obtener comunicado específico
class ComunicadosApiService {
  /// Obtiene todos los comunicados del residente actual
  ///
  /// Endpoint: GET /api/comunicados
  /// Headers: Authorization Bearer token
  /// Returns: ComunicadosResponse con lista de comunicados
  Future<ComunicadosResponse> obtenerComunicados() async {
    try {
      print('📡 ComunicadosApiService - Obteniendo comunicados...');

      final response = await ApiClient.get('/api/comunicados');

      print('📦 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final comunicadosResponse = ComunicadosResponse.fromJson(jsonResponse);

        print(
          '✅ ComunicadosApiService - ${comunicadosResponse.data.length} comunicados obtenidos',
        );
        return comunicadosResponse;
      } else {
        print(
          '❌ ComunicadosApiService - Error ${response.statusCode}: ${response.body}',
        );
        throw Exception('Error al obtener comunicados: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 ComunicadosApiService - Exception: $e');
      rethrow;
    }
  }

  /// Obtiene un comunicado específico por ID
  ///
  /// Endpoint: GET /api/comunicados/{id}
  /// Parameters: id del comunicado
  /// Returns: ComunicadoSingleResponse con comunicado completo
  Future<ComunicadoSingleResponse> obtenerComunicado(int id) async {
    try {
      print('📡 ComunicadosApiService - Obteniendo comunicado ID: $id');

      final response = await ApiClient.get('/api/comunicados/$id');

      print('📦 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final comunicadoResponse = ComunicadoSingleResponse.fromJson(
          jsonResponse,
        );

        print(
          '✅ ComunicadosApiService - Comunicado obtenido: ${comunicadoResponse.data.titulo}',
        );
        return comunicadoResponse;
      } else if (response.statusCode == 404) {
        print('❌ ComunicadosApiService - Comunicado no encontrado: $id');
        throw Exception('Comunicado no encontrado');
      } else {
        print(
          '❌ ComunicadosApiService - Error ${response.statusCode}: ${response.body}',
        );
        throw Exception('Error al obtener comunicado: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 ComunicadosApiService - Exception: $e');
      rethrow;
    }
  }

  /// Marca un comunicado como leído
  ///
  /// Endpoint: POST /api/lectura-comunicados/
  /// Body: { "comunicado_id": id }
  /// El usuario se obtiene automáticamente del token JWT
  Future<void> marcarComoLeido(int comunicadoId) async {
    try {
      print('📡 ComunicadosApiService - Marcando como leído ID: $comunicadoId');

      final response = await ApiClient.post(
        '/api/lectura-comunicados/',
        body: {'comunicado_id': comunicadoId},
      );

      print('📦 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(
          '✅ ComunicadosApiService - Comunicado marcado como leído: $comunicadoId',
        );
      } else {
        print(
          '❌ ComunicadosApiService - Error ${response.statusCode}: ${response.body}',
        );
        throw Exception('Error al marcar como leído: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 ComunicadosApiService - Exception al marcar como leído: $e');
      rethrow;
    }
  }
}
