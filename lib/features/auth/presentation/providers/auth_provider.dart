import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/api/api_client.dart';
import 'package:my_flutter_app/features/auth/data/models/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_flutter_app/core/services/notification_service.dart';

/// Provider de autenticación que maneja el estado de login/logout
/// y configura automáticamente el token en ApiClient
class AuthProvider extends ChangeNotifier {
  String? _token;
  UserData? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get token => _token;
  UserData? get user => _user;
  bool get isLoggedIn => _token != null && _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get userRole => _user?.role; // ✨ NUEVO: obtener rol del usuario

  /// Login con tu API real
  Future<void> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // � Petición real a tu API de login
      final response = await ApiClient.post(
        '/api/usuarios/authenticate/',
        body: {'username': username, 'password': password},
      );

      print('📡 Login Response Status: ${response.statusCode}');
      print('📦 Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // 📦 Procesar respuesta real del login
        final responseData = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(responseData);

        if (loginResponse.success) {
          // ✅ Login exitoso - configurar token y usuario
          await _setToken(loginResponse.data.accessToken);
          _setUser(loginResponse.data.user);

          // 🔔 Generar NUEVO FCM token para este usuario específico
          await NotificationService.forceTokenRefreshAndSend();

          print(
            '✅ Login exitoso para usuario: ${loginResponse.data.user.username}',
          );
          print(
            '🔑 Token configurado: ${loginResponse.data.accessToken.substring(0, 30)}...',
          );
        } else {
          throw Exception(loginResponse.message);
        }
      } else {
        // 🔍 Intentar leer mensaje de error del backend
        try {
          final errorData = jsonDecode(response.body);
          final errorMessage = errorData['message'] ?? 'Error de autenticación';
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception('Credenciales inválidas (${response.statusCode})');
        }
      }
    } catch (e) {
      _setError(e.toString());
      print('❌ Error en login: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Configura el token manualmente (útil si ya tienes un token guardado)
  Future<void> setToken(String token) async {
    await _setToken(token);
  }

  /// Realiza logout limpiando el token
  Future<void> logout() async {
    _setLoading(true);

    try {
      // 🔄 Aquí podrías hacer petición de logout al servidor si es necesario
      await _clearToken();
      print('✅ Logout exitoso');
    } catch (e) {
      _setError('Error en logout: $e');
      print('❌ Error en logout: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Verifica si el token actual es válido
  Future<bool> validateToken() async {
    if (_token == null) return false;

    try {
      // 🔄 Aquí harías una petición para verificar el token
      final response = await ApiClient.get('/api/auth/verify');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error validando token: $e');
      return false;
    }
  }

  /// Inicializar desde almacenamiento al arrancar la app
  Future<void> initializeFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? savedToken = prefs.getString('access_token');

      if (savedToken != null) {
        print('🔄 Recuperando token JWT guardado...');
        _token = savedToken;
        ApiClient.setToken(savedToken);

        // Opcional: Validar si el token sigue siendo válido
        bool isValid = await validateToken();
        if (isValid) {
          print('✅ Token JWT válido, sesión restaurada');
          // TODO: Podrías obtener datos del usuario aquí si es necesario
          notifyListeners();
        } else {
          print('❌ Token JWT expirado, limpiando...');
          await _clearToken();
        }
      } else {
        print('ℹ️ No hay token JWT guardado');
      }
    } catch (e) {
      print('❌ Error inicializando desde almacenamiento: $e');
    }
  }

  // Métodos privados
  Future<void> _setToken(String token) async {
    _token = token;

    // ⭐ Guardar token permanentemente en SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);
      print('💾 Token JWT guardado permanentemente');
    } catch (e) {
      print('❌ Error guardando token JWT: $e');
    }

    ApiClient.setToken(token); // ← 🎯 AQUÍ SE CONFIGURA EL INTERCEPTOR
    notifyListeners();
  }

  void _setUser(UserData user) {
    _user = user;
    notifyListeners();
  }

  Future<void> _clearToken() async {
    _token = null;
    _user = null;

    // ⭐ Limpiar token de SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      print('🗑️ Token JWT eliminado de SharedPreferences');
    } catch (e) {
      print('❌ Error eliminando token JWT: $e');
    }

    ApiClient.clearToken(); // ← 🎯 AQUÍ SE LIMPIA EL INTERCEPTOR
    notifyListeners();
  }

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
