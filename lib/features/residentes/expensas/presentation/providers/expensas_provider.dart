import 'package:flutter/material.dart';
import '../../data/models/expensa_model.dart';
import '../../data/repositories/expensas_repository_impl.dart';

/// Provider que maneja el estado de las expensas
///
/// Sigue el mismo patrón que ComunicadosProvider con ChangeNotifier
class ExpensasProvider extends ChangeNotifier {
  final ExpensasRepositoryImpl repository;

  ExpensasProvider({required this.repository});

  // Estado de la lista de expensas
  List<ExpensaModel> _expensas = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _tieneVivienda = true; // Por defecto asumimos que sí tiene
  String? _mensajeInfo;

  // Getters para la lista de expensas
  List<ExpensaModel> get expensas => _expensas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get tieneVivienda => _tieneVivienda;
  String? get mensajeInfo => _mensajeInfo;

  // Getters útiles para la UI
  List<ExpensaModel> get expensasPendientes =>
      _expensas.where((e) => e.estado == 'pendiente').toList();

  List<ExpensaModel> get expensasVencidas =>
      _expensas.where((e) => e.estaVencida).toList();

  int get cantidadPendientes => expensasPendientes.length;

  double get totalPendiente => expensasPendientes.fold(
    0,
    (sum, expensa) => sum + expensa.montoComoDouble,
  );

  /// Carga todas las expensas del residente
  Future<void> cargarExpensas() async {
    if (_isLoading) return;

    try {
      print('🏠 ExpensasProvider - Iniciando carga de expensas...');
      _setLoading(true);
      _clearError();

      final response = await repository.obtenerMisExpensas();
      _expensas = response.results;

      // Actualizar información de vivienda desde la respuesta
      if (response.info != null) {
        _tieneVivienda = response.info!.tieneVivienda;
        _mensajeInfo = response.info!.mensaje;
      }

      print('✅ ExpensasProvider - ${_expensas.length} expensas cargadas');
      print('🏠 ExpensasProvider - Tiene vivienda: $_tieneVivienda');
    } catch (e) {
      print('❌ ExpensasProvider - Error al cargar expensas: $e');
      _setError('Error al cargar expensas: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresca la lista de expensas (pull to refresh)
  Future<void> refrescarExpensas() async {
    print('🔄 ExpensasProvider - Refrescando expensas...');
    await cargarExpensas();
  }

  /// Limpia todos los estados
  void limpiarTodo() {
    _expensas.clear();
    _isLoading = false;
    _errorMessage = null;
    _tieneVivienda = true;
    _mensajeInfo = null;
    notifyListeners();
  }

  // Métodos privados para manejo de estado
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
