import 'dart:convert';
import 'package:http/http.dart' as http;

/// Cliente HTTP personalizado que automáticamente agrega el token de autorización
/// a todas las peticiones. Actúa como un interceptor para el package http.
class ApiClient {
  static const String baseUrl = 'http://192.168.0.5:8000';
  // TODO: Si Django no responde, cambiar a localhost para pruebas
  // static const String baseUrl = 'http://localhost:8000';
  // static const String baseUrl = 'http://10.0.2.2:8000'; // Para emulador
  static String? _token;

  /// Configura el token de autorización que se agregará automáticamente
  /// a todas las peticiones HTTP
  static void setToken(String? token) {
    _token = token;
    print('🔐 ApiClient: Token configurado ${token != null ? '✅' : '❌'}');
  }

  /// Limpia el token de autorización (útil para logout)
  static void clearToken() {
    _token = null;
    print('🔓 ApiClient: Token limpiado');
  }

  /// Obtiene el token actual (útil para verificar estado)
  static String? getToken() => _token;

  /// Realiza una petición GET con token automático
  static Future<http.Response> get(String endpoint) async {
    final url = '$baseUrl$endpoint';
    final headers = _buildHeaders();

    print('📡 GET: $url');
    print('🔑 Headers: ${headers.keys.join(', ')}');

    return await http.get(Uri.parse(url), headers: headers);
  }

  /// Realiza una petición POST con token automático
  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = '$baseUrl$endpoint';
    final headers = _buildHeaders();

    print('📤 POST: $url');
    print('🔑 Headers: ${headers.keys.join(', ')}');

    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// Realiza una petición PUT con token automático
  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = '$baseUrl$endpoint';
    final headers = _buildHeaders();

    print('📝 PUT: $url');
    print('🔑 Headers: ${headers.keys.join(', ')}');

    return await http.put(
      Uri.parse(url),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// Realiza una petición DELETE con token automático
  static Future<http.Response> delete(String endpoint) async {
    final url = '$baseUrl$endpoint';
    final headers = _buildHeaders();

    print('🗑️ DELETE: $url');
    print('🔑 Headers: ${headers.keys.join(', ')}');

    return await http.delete(Uri.parse(url), headers: headers);
  }

  /// Construye los headers HTTP incluyendo el token de autorización si está disponible
  static Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // 🔐 Agrega automáticamente el token si está disponible
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }
}
