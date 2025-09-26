import 'dart:convert';

import 'package:my_flutter_app/core/api/api_client.dart';
import '../models/area_comun_model.dart';

class AreasComunesService {
  /// Obtiene todas las áreas comunes disponibles para reservar
  /// API: GET /api/areas-comunes/
  Future<List<AreaComun>> getAreasDisponibles() async {
    const endpoint = '/api/areas-comunes/';
    final response = await ApiClient.get(endpoint);

    print('📡 GET Áreas Comunes Status Code: ${response.statusCode}');
    print('📦 GET Áreas Comunes Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ Áreas comunes obtenidas exitosamente');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Manejar diferentes estructuras de respuesta
      List<dynamic> areasData;
      if (jsonResponse.containsKey('data')) {
        areasData = jsonResponse['data'] ?? [];
      } else if (jsonResponse.containsKey('results')) {
        areasData = jsonResponse['results'] ?? [];
      } else {
        // Si la respuesta es directamente una lista
        areasData = jsonResponse is List ? jsonResponse as List<dynamic> : [];
      }

      return areasData
          .map((item) {
            try {
              return AreaComun.fromJson(item as Map<String, dynamic>);
            } catch (e) {
              print('❌ Error parseando área común individual: $e');
              return null;
            }
          })
          .where((area) => area != null)
          .cast<AreaComun>()
          .toList();
    } else {
      print('❌ Error al obtener áreas comunes: ${response.statusCode}');
      throw Exception('Error al cargar áreas comunes disponibles');
    }
  }

  /// Obtiene horarios disponibles para un área específica en una fecha
  /// API: GET /api/areas-comunes/{id}/horarios-disponibles/?fecha=2025-09-30
  Future<List<String>> getHorariosDisponibles(
    int areaComunId,
    String fecha,
  ) async {
    final endpoint =
        '/api/areas-comunes/$areaComunId/horarios-disponibles/?fecha=$fecha';
    final response = await ApiClient.get(endpoint);

    print('📡 GET Horarios Disponibles Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> horariosData = jsonResponse['horarios'] ?? [];

      return horariosData.cast<String>();
    } else {
      // Si el endpoint no existe, devolver horarios por defecto
      print(
        '⚠️ Endpoint de horarios no disponible, usando horarios por defecto',
      );
      return _getHorariosDefault();
    }
  }

  /// Horarios por defecto si el API no los proporciona
  List<String> _getHorariosDefault() {
    return [
      '08:00:00',
      '09:00:00',
      '10:00:00',
      '11:00:00',
      '12:00:00',
      '13:00:00',
      '14:00:00',
      '15:00:00',
      '16:00:00',
      '17:00:00',
      '18:00:00',
      '19:00:00',
      '20:00:00',
      '21:00:00',
      '22:00:00',
    ];
  }
}
