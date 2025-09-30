import '../datasources/comunicados_api_service.dart';
import '../models/comunicado_model.dart';

/// Repository que maneja la lógica de negocio para comunicados
///
/// Actúa como intermediario entre el provider (presentation) y el API service (data)
/// Sigue el patrón de inyección de dependencias como en el feature de perfil
class ComunicadosRepositoryImpl {
  final ComunicadosApiService apiService;

  ComunicadosRepositoryImpl({required this.apiService});

  /// Obtiene todos los comunicados del residente
  ///
  /// Puede incluir lógica de caché o filtrado adicional
  Future<ComunicadosResponse> obtenerComunicados() async {
    try {
      print('🏛️ ComunicadosRepository - Solicitando comunicados...');

      final response = await apiService.obtenerComunicados();

      print(
        '🏛️ ComunicadosRepository - ${response.data.length} comunicados obtenidos',
      );
      return response;
    } catch (e) {
      print('💥 ComunicadosRepository - Error: $e');
      rethrow;
    }
  }

  /// Obtiene un comunicado específico por ID
  ///
  /// Puede incluir lógica de caché o validación adicional
  Future<ComunicadoSingleResponse> obtenerComunicado(int id) async {
    try {
      print('🏛️ ComunicadosRepository - Solicitando comunicado ID: $id');

      if (id <= 0) {
        throw Exception('ID de comunicado inválido');
      }

      final response = await apiService.obtenerComunicado(id);

      print(
        '🏛️ ComunicadosRepository - Comunicado obtenido: ${response.data.titulo}',
      );
      return response;
    } catch (e) {
      print('💥 ComunicadosRepository - Error: $e');
      rethrow;
    }
  }

  /// Marca un comunicado como leído por el usuario actual
  ///
  /// Se puede incluir lógica adicional como actualización de caché local
  Future<void> marcarComoLeido(int comunicadoId) async {
    try {
      print(
        '🏛️ ComunicadosRepository - Marcando como leído ID: $comunicadoId',
      );

      if (comunicadoId <= 0) {
        throw Exception('ID de comunicado inválido');
      }

      await apiService.marcarComoLeido(comunicadoId);

      print('🏛️ ComunicadosRepository - Comunicado marcado como leído');
    } catch (e) {
      print('💥 ComunicadosRepository - Error al marcar como leído: $e');
      rethrow;
    }
  }
}
