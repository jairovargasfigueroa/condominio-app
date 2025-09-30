import 'dart:convert';
import '../../../../../core/api/api_client.dart';
import '../models/expensa_model.dart';

/// Servicio para manejar las operaciones de expensas con la API
///
/// Maneja todas las llamadas HTTP relacionadas con expensas:
/// - Obtener lista de expensas del usuario logueado
class ExpensasApiService {
  /// Obtiene todas las expensas del residente actual
  ///
  /// Endpoint: GET /api/expensas/mis_expensas/
  /// Headers: Authorization Bearer token
  /// Returns: ExpensasResponse con lista de expensas
  Future<ExpensasResponse> obtenerMisExpensas() async {
    try {
      print('📡 ExpensasApiService - Obteniendo expensas...');

      final response = await ApiClient.get('/api/expensas/mis_expensas/');

      print('📦 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final expensasResponse = ExpensasResponse.fromJson(jsonResponse);

        print(
          '✅ ExpensasApiService - ${expensasResponse.results.length} expensas obtenidas',
        );
        return expensasResponse;
      } else {
        print(
          '❌ ExpensasApiService - Error ${response.statusCode}: ${response.body}',
        );
        throw Exception('Error al obtener expensas: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 ExpensasApiService - Exception: $e');
      rethrow;
    }
  }
}
