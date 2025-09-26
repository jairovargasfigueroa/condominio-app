import '../services/guardia_remote_service.dart';
import '../models/guardia_model.dart';
import '../models/guardia_perfil_response_model.dart';

class GuardiaRepositoryImpl {
  final GuardiaRemoteService remoteService;

  GuardiaRepositoryImpl({required this.remoteService});

  Future<GuardiaModel> getGuardia(int id) async {
    return await remoteService.getGuardia(id);
  }

  /// Obtiene el perfil del guardia actualmente logueado
  Future<GuardiaPerfilData> getPerfilActual() async {
    return await remoteService.getPerfilActual();
  }
}
