import 'package:flutter/material.dart';

import '../../data/models/residente_model.dart';
import '../../data/models/perfil_response_model.dart';
import '../../data/repositories/residente_repository_implement.dart';

class ResidenteProvider extends ChangeNotifier {
  final ResidenteRepositoryImpl residenteRepository;

  ResidenteProvider({required this.residenteRepository});

  ResidenteModel? _residente;
  PerfilData? _perfil; // Nuevo: datos del perfil actual
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  ResidenteModel? get residente => _residente;
  PerfilData? get perfil => _perfil;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Carga automáticamente el perfil del usuario logueado
  /// Se llama cuando se inicializa la pantalla de perfil
  Future<void> loadPerfilActual() async {
    _setLoading(true);
    _clearError();

    try {
      _perfil = await residenteRepository.getPerfilActual();
      print(
        '✅ ResidenteProvider: Perfil cargado - ${_perfil?.usuario.username}',
      );
      print('🏠 Zona: ${_perfil?.zona}');
    } catch (e) {
      _setError('Error al cargar perfil: $e');
      print('❌ ResidenteProvider Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Método original para cargar residente por ID (mantener por compatibilidad)
  Future<void> loadResidente(int id) async {
    _setLoading(true);
    _clearError();

    try {
      _residente = await residenteRepository.getResidente(id);
      print(
        '✅ ResidenteProvider: Residente cargado - ${_residente?.usuario.username}',
      );
    } catch (e) {
      _setError('Error al cargar residente: $e');
      print('❌ ResidenteProvider Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Métodos privados
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
    notifyListeners();
  }
}
