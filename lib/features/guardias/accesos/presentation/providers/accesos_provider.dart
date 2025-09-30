import 'package:flutter/material.dart';
import '../../data/models/acceso_response_model.dart';
import '../../data/models/facial_validation_result.dart';
import '../../data/repositories/accesos_repository.dart';

class AccesosProvider extends ChangeNotifier {
  final AccesosRepository _accesosRepository;

  AccesosProvider({AccesosRepository? accesosRepository})
    : _accesosRepository = accesosRepository ?? AccesosRepository();

  bool _isCreating = false;
  String? _errorMessage;
  String? _successMessage;
  AccesoData? _lastAcceso;

  // Estado del reconocimiento facial
  bool _isValidatingFace = false;
  FacialValidationResult? _lastFacialValidation;

  // Getters
  bool get isCreating => _isCreating;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  AccesoData? get lastAcceso => _lastAcceso;

  // Getters para reconocimiento facial
  bool get isValidatingFace => _isValidatingFace;
  FacialValidationResult? get lastFacialValidation => _lastFacialValidation;

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

  /// Valida un rostro mediante reconocimiento facial
  Future<FacialValidationResult?> validarRostro({
    required List<int> fotoBytes,
    required String fileName,
  }) async {
    _setValidatingFace(true);
    _clearError();
    _clearSuccess();
    _clearLastFacialValidation();

    try {
      final result = await _accesosRepository.validarRostro(
        fotoBytes: fotoBytes,
        fileName: fileName,
      );

      _lastFacialValidation = result;

      if (result.success && result.data != null) {
        _setSuccess(
          'Rostro validado exitosamente: ${result.data!.user.fullName}',
        );
        print(
          '✅ Rostro validado: ${result.data!.user.fullName} (${result.data!.confidence}% confianza)',
        );
        return result;
      } else {
        _setError(result.message);
        print(
          '❌ No se encontró coincidencia para el rostro: ${result.message}',
        );
        return result;
      }
    } catch (e) {
      _setError('Error de conexión: ${e.toString()}');
      print('❌ Error de conexión en validación facial: $e');
      return null;
    } finally {
      _setValidatingFace(false);
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

  /// Limpia la última validación facial
  void clearLastFacialValidation() {
    _clearLastFacialValidation();
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

  void _setValidatingFace(bool value) {
    _isValidatingFace = value;
    notifyListeners();
  }

  void _clearLastFacialValidation() {
    _lastFacialValidation = null;
    notifyListeners();
  }
}
