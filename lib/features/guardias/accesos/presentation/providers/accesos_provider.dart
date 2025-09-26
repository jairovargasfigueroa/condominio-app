import 'package:flutter/material.dart';
import '../../data/models/acceso_response_model.dart';
import '../../data/repositories/accesos_repository.dart';

class AccesosProvider extends ChangeNotifier {
  final AccesosRepository _accesosRepository;

  AccesosProvider({AccesosRepository? accesosRepository})
    : _accesosRepository = accesosRepository ?? AccesosRepository();

  bool _isCreating = false;
  String? _errorMessage;
  String? _successMessage;
  AccesoData? _lastAcceso;

  // Getters
  bool get isCreating => _isCreating;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  AccesoData? get lastAcceso => _lastAcceso;

  /// Crea un nuevo registro de acceso
  Future<bool> createAcceso({
    required int usuario,
    required String tipoAcceso,
  }) async {
    _setCreating(true);
    _clearError();
    _clearSuccess();

    try {
      final result = await _accesosRepository.createAcceso(
        usuario: usuario,
        tipoAcceso: tipoAcceso,
      );

      if (result.success) {
        _lastAcceso = result.data;
        _setSuccess(result.message);
        print('✅ Acceso registrado exitosamente: ${_lastAcceso?.id}');
        return true;
      } else {
        _setError(result.message);
        print('❌ Error al registrar acceso: ${result.message}');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: ${e.toString()}');
      print('❌ Error de conexión: $e');
      return false;
    } finally {
      _setCreating(false);
    }
  }

  /// Limpia el error
  void clearError() {
    _clearError();
  }

  /// Limpia el último acceso registrado
  void clearLastAcceso() {
    _lastAcceso = null;
    notifyListeners();
  }

  // Métodos privados para manejar el estado
  void _setCreating(bool value) {
    _isCreating = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }
}
