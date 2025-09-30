import '../datasources/expensas_api_service.dart';
import '../models/expensa_model.dart';

/// Repository que maneja la lógica de negocio para expensas
///
/// Actúa como intermediario entre el provider (presentation) y el API service (data)
/// Sigue el patrón de inyección de dependencias como en el feature de comunicados
class ExpensasRepositoryImpl {
  final ExpensasApiService apiService;

  ExpensasRepositoryImpl({required this.apiService});

  /// Obtiene todas las expensas del residente
  ///
  /// Puede incluir lógica de caché o filtrado adicional
  Future<ExpensasResponse> obtenerMisExpensas() async {
    try {
      print('🏛️ ExpensasRepository - Solicitando expensas...');

      final response = await apiService.obtenerMisExpensas();

      print(
        '🏛️ ExpensasRepository - ${response.results.length} expensas obtenidas',
      );
      return response;
    } catch (e) {
      print('💥 ExpensasRepository - Error: $e');
      rethrow;
    }
  }
}
