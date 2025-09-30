import 'package:flutter/material.dart';
import '../../data/models/comunicado_model.dart';
import '../../data/repositories/comunicados_repository_impl.dart';

/// Provider que maneja el estado de los comunicados
///
/// Sigue el mismo patrón que tus otros providers con ChangeNotifier
class ComunicadosProvider extends ChangeNotifier {
  final ComunicadosRepositoryImpl repository;

  ComunicadosProvider({required this.repository});
  // Estado de la lista de comunicados
  List<ComunicadoModel> _comunicados = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Estado del comunicado seleccionado (para detalle)
  ComunicadoModel? _comunicadoSeleccionado;
  bool _isLoadingDetalle = false;
  String? _errorMessageDetalle;

  // Getters para la lista de comunicados
  List<ComunicadoModel> get comunicados => _comunicados;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Getters para comunicado detalle
  ComunicadoModel? get comunicadoSeleccionado => _comunicadoSeleccionado;
  bool get isLoadingDetalle => _isLoadingDetalle;
  String? get errorMessageDetalle => _errorMessageDetalle;

  /// Carga todos los comunicados del residente
  Future<void> cargarComunicados() async {
    if (_isLoading) return;

    try {
      print('📢 ComunicadosProvider - Iniciando carga de comunicados...');
      _setLoading(true);
      _clearError();

      final response = await repository.obtenerComunicados();
      _comunicados = response.data;

      print(
        '✅ ComunicadosProvider - ${_comunicados.length} comunicados cargados',
      );
    } catch (e) {
      print('❌ ComunicadosProvider - Error al cargar comunicados: $e');
      _setError('Error al cargar comunicados: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Carga un comunicado específico para mostrar el detalle
  Future<void> cargarComunicado(int id) async {
    if (_isLoadingDetalle) return;

    try {
      print('📢 ComunicadosProvider - Cargando comunicado ID: $id');
      _setLoadingDetalle(true);
      _clearErrorDetalle();

      final response = await repository.obtenerComunicado(id);
      _comunicadoSeleccionado = response.data;

      print(
        '✅ ComunicadosProvider - Comunicado cargado: ${_comunicadoSeleccionado!.titulo}',
      );
    } catch (e) {
      print('❌ ComunicadosProvider - Error al cargar comunicado: $e');
      _setErrorDetalle('Error al cargar comunicado: ${e.toString()}');
    } finally {
      _setLoadingDetalle(false);
    }
  }

  /// Refresca la lista de comunicados (pull to refresh)
  Future<void> refrescarComunicados() async {
    print('🔄 ComunicadosProvider - Refrescando comunicados...');
    await cargarComunicados();
  }

  /// Marca un comunicado como leído
  ///
  /// Se llama automáticamente cuando se ve el detalle de un comunicado
  Future<void> marcarComoLeido(int comunicadoId) async {
    try {
      print('📖 ComunicadosProvider - Marcando como leído ID: $comunicadoId');

      await repository.marcarComoLeido(comunicadoId);

      print('✅ ComunicadosProvider - Comunicado marcado como leído');
    } catch (e) {
      print(
        '⚠️ ComunicadosProvider - Error al marcar como leído (sin mostrar en UI): $e',
      );
      // No mostramos error en la UI para esta operación automática
      // El usuario ya está viendo el comunicado, no queremos interrumpir
    }
  }

  /// Limpia el comunicado seleccionado
  void limpiarComunicadoSeleccionado() {
    _comunicadoSeleccionado = null;
    _clearErrorDetalle();
    notifyListeners();
  }

  /// Limpia todos los estados
  void limpiarTodo() {
    _comunicados.clear();
    _comunicadoSeleccionado = null;
    _isLoading = false;
    _isLoadingDetalle = false;
    _errorMessage = null;
    _errorMessageDetalle = null;
    notifyListeners();
  }

  // Métodos privados para manejo de estado
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingDetalle(bool loading) {
    _isLoadingDetalle = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setErrorDetalle(String error) {
    _errorMessageDetalle = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void _clearErrorDetalle() {
    _errorMessageDetalle = null;
  }
}
