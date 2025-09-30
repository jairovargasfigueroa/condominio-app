import 'package:my_flutter_app/features/guardias/accesos/data/models/create_acceso_request.dart';
import 'package:my_flutter_app/features/guardias/accesos/data/models/create_acceso_result.dart';
import 'package:my_flutter_app/features/guardias/accesos/data/models/facial_validation_result.dart';
import 'package:my_flutter_app/features/guardias/accesos/data/services/accesos_service.dart';

class AccesosRepository {
  final AccesosRemoteService _remoteService;

  AccesosRepository({AccesosRemoteService? remoteService})
    : _remoteService = remoteService ?? AccesosRemoteService();

  /// Crea un nuevo registro de acceso
  Future<CreateAccesoResult> createAcceso({
    required int usuario,
    required String tipoAcceso,
  }) async {
    final request = CreateAccesoRequest(
      usuario: usuario,
      tipoAcceso: tipoAcceso,
    );

    return await _remoteService.createAcceso(request);
  }

  /// Valida un rostro mediante reconocimiento facial
  Future<FacialValidationResult> validarRostro({
    required List<int> fotoBytes,
    required String fileName,
  }) async {
    return await _remoteService.validarRostro(
      fotoBytes: fotoBytes,
      fileName: fileName,
    );
  }
}
