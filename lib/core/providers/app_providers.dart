import 'package:provider/provider.dart';
import 'package:my_flutter_app/features/users/presentation/providers/user_provider.dart';
import 'package:my_flutter_app/features/residentes/perfil/presentation/providers/residente_provider.dart';
import 'package:my_flutter_app/features/residentes/reservas/presentation/providers/reservas_provider.dart';
import 'package:my_flutter_app/features/guardias/perfil/presentation/providers/guardia_provider.dart';
import 'package:my_flutter_app/features/guardias/accesos/presentation/providers/accesos_provider.dart';
import 'package:my_flutter_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:my_flutter_app/features/users/data/repositories/user_repository_implement.dart';
import 'package:my_flutter_app/features/residentes/perfil/data/repositories/residente_repository_implement.dart';
import 'package:my_flutter_app/features/residentes/reservas/data/repositories/reservas_repository.dart';
import 'package:my_flutter_app/features/guardias/perfil/data/repositories/guardia_repository_implement.dart';
import 'package:my_flutter_app/features/guardias/accesos/data/repositories/accesos_repository.dart';
import 'package:my_flutter_app/features/guardias/accesos/data/services/accesos_service.dart';
import 'package:my_flutter_app/features/users/data/data_sources/user_remote_data_source.dart';
import 'package:my_flutter_app/features/residentes/perfil/data/services/residente_remote_service.dart';
import 'package:my_flutter_app/features/residentes/reservas/data/services/reservas_service.dart';
import 'package:my_flutter_app/features/residentes/reservas/data/services/areas_comunes_service.dart';
import 'package:my_flutter_app/features/guardias/perfil/data/services/guardia_remote_service.dart';
import 'package:provider/single_child_widget.dart';

/// Configuración centralizada de todos los providers de la aplicación
class AppProviders {
  /// Crea la lista de providers para MultiProvider
  static List<SingleChildWidget> get providers => [
    // 🔐 Provider de Autenticación (DEBE IR PRIMERO)
    ChangeNotifierProvider(create: (_) => AuthProvider()),

    // Providers de Users
    ChangeNotifierProvider(
      create:
          (_) => UserProvider(
            userRepository: UserRepositoryImpl(
              remoteDataSource: UserRemoteDataSource(),
            ),
          ),
    ),

    // Providers de Residentes
    ChangeNotifierProvider(
      create:
          (_) => ResidenteProvider(
            residenteRepository: ResidenteRepositoryImpl(
              remoteService: ResidenteRemoteService(),
            ),
          ),
    ),

    // Provider de Reservas para residentes
    ChangeNotifierProvider(
      create:
          (_) => ReservasProvider(
            reservasRepository: ReservasRepositoryImpl(
              remoteService: ReservasRemoteService(),
            ),
            areasComunesService: AreasComunesService(),
          ),
    ),

    // Providers de Guardias
    ChangeNotifierProvider(
      create:
          (_) => GuardiaProvider(
            guardiaRepository: GuardiaRepositoryImpl(
              remoteService: GuardiaRemoteService(),
            ),
          ),
    ),

    // Provider de Accesos para guardias
    ChangeNotifierProvider(
      create:
          (_) => AccesosProvider(
            accesosRepository: AccesosRepository(
              remoteService: AccesosRemoteService(),
            ),
          ),
    ),

    // Aquí puedes agregar más providers cuando los tengas:
    // ChangeNotifierProvider(create: (_) => NotificationProvider()),
  ];
}
