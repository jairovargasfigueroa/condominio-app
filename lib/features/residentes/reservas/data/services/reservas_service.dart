import 'dart:convert';

import 'package:my_flutter_app/core/api/api_client.dart';
import 'package:my_flutter_app/features/residentes/reservas/data/models/reserva_model.dart';
import 'package:my_flutter_app/features/residentes/reservas/data/models/create_reserva_request.dart';
import 'package:my_flutter_app/features/residentes/reservas/data/models/reservas_response_model.dart'
    as response_model;

class ReservasRemoteService {
  /// Obtiene las reservas del usuario logueado usando el token del header
  /// API: GET /api/reservas/mis-reservas/
  /// No requiere parámetros - usa el token para identificar al usuario
  Future<response_model.ReservasData> getMisReservas({
    int page = 1,
    int pageSize = 10,
  }) async {
    final endpoint =
        '/api/reservas/mis-reservas/?page=$page&page_size=$pageSize';
    final response = await ApiClient.get(endpoint);

    print('📡 GET Reservas Status Code: ${response.statusCode}');
    print('📦 GET Reservas Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ Reservas obtenidas exitosamente');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final reservasResponse = response_model.ReservasResponse.fromJson(
        jsonResponse,
      );

      if (reservasResponse.success) {
        return reservasResponse.data;
      } else {
        throw Exception(reservasResponse.message);
      }
    } else {
      print('❌ Error al obtener reservas: ${response.statusCode}');
      throw Exception('Error al cargar reservas del usuario logueado');
    }
  }

  /// Método para crear una nueva reserva (mantener por compatibilidad)
  Future<ReservaModel> crearReserva({
    required int areaComun,
    required String fechaInicio,
    required String fechaFin,
    String? observaciones,
  }) async {
    final Map<String, dynamic> requestBody = {
      'area_comun': areaComun,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      if (observaciones != null) 'observaciones': observaciones,
    };

    final response = await ApiClient.post('/api/reservas/', body: requestBody);

    print('📡 POST Reserva Status Code: ${response.statusCode}');
    print('📦 POST Reserva Response Body: ${response.body}');

    if (response.statusCode == 201) {
      print('✅ Reserva creada exitosamente');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return ReservaModel.fromJson(jsonResponse);
    } else {
      print('❌ Error al crear reserva: ${response.statusCode}');
      throw Exception('Error al crear reserva');
    }
  }

  /// Método para cancelar una reserva (mantener por compatibilidad)
  Future<void> cancelarReserva({required int reservaId}) async {
    final response = await ApiClient.put(
      '/api/reservas/$reservaId/cancelar/',
      body: {},
    );

    print('📡 PATCH Cancelar Reserva Status Code: ${response.statusCode}');
    print('📦 PATCH Cancelar Reserva Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ Reserva cancelada exitosamente');
      return;
    } else {
      print('❌ Error al cancelar reserva: ${response.statusCode}');
      throw Exception('Error al cancelar reserva');
    }
  }

  /// Crea una nueva reserva
  /// API: POST /api/reservas/crear/
  /// Body: CreateReservaRequest en formato JSON
  Future<response_model.ReservaDetalle> createReserva(
    CreateReservaRequest request,
  ) async {
    const endpoint = '/api/reservas/';
    final response = await ApiClient.post(endpoint, body: request.toJson());

    print('📡 POST Create Reserva Status Code: ${response.statusCode}');
    print('📦 POST Create Reserva Request Body: ${request.toString()}');
    print('📦 POST Create Reserva Response Body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('✅ Reserva creada exitosamente');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Manejar diferentes estructuras de respuesta del API
      if (jsonResponse.containsKey('data')) {
        return response_model.ReservaDetalle.fromJson(jsonResponse['data']);
      } else {
        // Si la respuesta es directamente la reserva
        return response_model.ReservaDetalle.fromJson(jsonResponse);
      }
    } else {
      print('❌ Error al crear reserva: ${response.statusCode}');
      final Map<String, dynamic>? errorResponse;
      try {
        errorResponse = json.decode(response.body);
        final String errorMessage =
            errorResponse?['message'] ??
            errorResponse?['error'] ??
            'Error al crear reserva';
        throw Exception(errorMessage);
      } catch (e) {
        throw Exception('Error al crear reserva: ${response.statusCode}');
      }
    }
  }
}
