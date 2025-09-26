import '../services/residente_remote_service.dart';
import '../models/residente_model.dart';
import '../models/perfil_response_model.dart';

class ResidenteRepositoryImpl {
  final ResidenteRemoteService remoteService;

  ResidenteRepositoryImpl({required this.remoteService});

  Future<ResidenteModel> getResidente(int id) async {
    return await remoteService.getResidente(id);
  }

  /// Obtiene el perfil del usuario actualmente logueado
  Future<PerfilData> getPerfilActual() async {
    return await remoteService.getPerfilActual();
  }
}
