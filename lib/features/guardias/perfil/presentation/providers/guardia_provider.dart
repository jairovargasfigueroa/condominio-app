import 'package:flutter/material.dart';
import 'package:my_flutter_app/features/guardias/perfil/data/models/guardia_perfil_response_model.dart';
import 'package:my_flutter_app/features/guardias/perfil/data/repositories/guardia_repository_implement.dart';

class GuardiaProvider extends ChangeNotifier {
  final GuardiaRepositoryImpl guardiaRepository;

  GuardiaProvider({required this.guardiaRepository});

  GuardiaPerfilData? _perfilGuardia;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  GuardiaPerfilData? get perfilGuardia => _perfilGuardia;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Verifica si hay un perfil de guardia cargado
  bool get tienePerfilGuardia => _perfilGuardia != null;

  /// Obtiene el perfil del guardia logueado
  Future<void> fetchPerfilGuardia() async {
    _setLoading(true);
    _clearError();

    try {
      _perfilGuardia = await guardiaRepository.getPerfilActual();
      print('🏠 Provider - Perfil guardia cargado:');
      print('  - ID: ${_perfilGuardia?.id}');
      print(
        '  - Nombre: ${_perfilGuardia?.usuario.firstName} ${_perfilGuardia?.usuario.lastName}',
      );
      print('  - Email: ${_perfilGuardia?.usuario.email}');
      print('  - Teléfono: ${_perfilGuardia?.telefono}');
      print('  - Turno: ${_perfilGuardia?.turno}');
      print('  - Activo: ${_perfilGuardia?.activo}');
    } catch (error) {
      _errorMessage = error.toString();
      print('❌ Provider - Error al cargar perfil de guardia: $error');
    } finally {
      _setLoading(false);
    }
  }

  /// Limpia el estado del provider
  void clearPerfil() {
    _perfilGuardia = null;
    _clearError();
    notifyListeners();
    print('🧹 Provider - Estado del guardia limpiado');
  }

  /// Recarga el perfil del guardia
  Future<void> reloadPerfil() async {
    print('🔄 Provider - Recargando perfil de guardia...');
    await fetchPerfilGuardia();
  }

  // Métodos de utilidad para getters específicos
  String get nombreCompleto {
    if (_perfilGuardia?.usuario != null) {
      return '${_perfilGuardia!.usuario.firstName} ${_perfilGuardia!.usuario.lastName}';
    }
    return 'Nombre no disponible';
  }

  String get email {
    return _perfilGuardia?.usuario.email ?? 'Email no disponible';
  }

  String get telefono {
    // Si no hay teléfono en el perfil del guardia, usar el del usuario
    final perfilTelefono = _perfilGuardia?.telefono;
    if (perfilTelefono != null && perfilTelefono.isNotEmpty) {
      return perfilTelefono;
    }
    return _perfilGuardia?.usuario.telefono ?? 'Teléfono no disponible';
  }

  String get turno {
    final perfilTurno = _perfilGuardia?.turno;
    return (perfilTurno != null && perfilTurno.isNotEmpty)
        ? perfilTurno
        : 'Turno no asignado';
  }

  bool get activo {
    return _perfilGuardia?.activo ??
        true; // Por defecto activo si no se especifica
  }

  // Métodos privados de manejo de estado
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
