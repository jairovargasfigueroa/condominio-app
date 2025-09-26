import '../services/reservas_service.dart';
import '../models/reserva_model.dart';
import '../models/reservas_response_model.dart';
import '../models/create_reserva_request.dart';

class ReservasRepositoryImpl {
  final ReservasRemoteService remoteService;

  ReservasRepositoryImpl({required this.remoteService});

  /// Obtiene las reservas del usuario actualmente logueado
  Future<ReservasData> getMisReservas({int page = 1, int pageSize = 10}) async {
    return await remoteService.getMisReservas(page: page, pageSize: pageSize);
  }

  /// Crea una nueva reserva (mantener por compatibilidad)
  Future<ReservaModel> crearReserva({
    required int areaComun,
    required String fechaInicio,
    required String fechaFin,
    String? observaciones,
  }) async {
    return await remoteService.crearReserva(
      areaComun: areaComun,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      observaciones: observaciones,
    );
  }

  /// Cancela una reserva existente (mantener por compatibilidad)
  Future<void> cancelarReserva({required int reservaId}) async {
    return await remoteService.cancelarReserva(reservaId: reservaId);
  }

  /// Crea una nueva reserva usando el nuevo modelo
  Future<ReservaDetalle> createReserva(CreateReservaRequest request) async {
    return await remoteService.createReserva(request);
  }
}
