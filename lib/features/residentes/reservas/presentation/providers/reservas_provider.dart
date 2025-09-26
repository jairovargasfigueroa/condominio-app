import 'package:flutter/material.dart';

import '../../data/models/reserva_model.dart';
import '../../data/models/reservas_response_model.dart';
import '../../data/models/area_comun_model.dart';
import '../../data/models/create_reserva_request.dart';
import '../../data/repositories/reservas_repository.dart';
import '../../data/services/areas_comunes_service.dart';

class ReservasProvider extends ChangeNotifier {
  final ReservasRepositoryImpl reservasRepository;
  final AreasComunesService areasComunesService;

  ReservasProvider({
    required this.reservasRepository,
    required this.areasComunesService,
  });

  List<ReservaModel>? _reservas;
  ReservasData? _reservasData; // Nuevo: datos de respuesta completa
  bool _isLoading = false;
  String? _errorMessage;

  // Nuevas propiedades para crear reserva
  List<AreaComun>? _areas;
  bool _isLoadingAreas = false;
  bool _isCreating = false;

  // Getters existentes
  List<ReservaModel>? get reservas => _reservas;
  ReservasData? get reservasData => _reservasData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Nuevos getters
  List<AreaComun>? get areas => _areas;
  bool get isLoadingAreas => _isLoadingAreas;
  bool get isCreating => _isCreating;

  /// Carga automáticamente las reservas del usuario logueado
  /// Se llama cuando se inicializa la pantalla de reservas
  Future<void> loadMisReservas({int page = 1, int pageSize = 10}) async {
    _setLoading(true);
    _clearError();

    try {
      _reservasData = await reservasRepository.getMisReservas(
        page: page,
        pageSize: pageSize,
      );

      // Convertir ReservaDetalle a ReservaModel para compatibilidad
      // El modelo ya maneja casos edge y parsing seguro
      _reservas =
          _reservasData!.results
              .map((reservaDetalle) => _convertToReservaModel(reservaDetalle))
              .toList();

      print(
        '✅ ReservasProvider: Reservas cargadas - ${_reservas?.length} reservas',
      );
    } catch (e) {
      _setError('Error al cargar reservas: $e');
      print('❌ ReservasProvider Error: $e');
      _reservas = [];
      _reservasData = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Convierte ReservaDetalle a ReservaModel para compatibilidad
  ReservaModel _convertToReservaModel(ReservaDetalle detalle) {
    return ReservaModel(
      id: detalle.id,
      residente: ResidenteDetalle(
        id: detalle.residente.id,
        usuario: UsuarioDetalle(
          id: detalle.residente.usuario.id,
          username: detalle.residente.usuario.username,
          email: detalle.residente.usuario.email,
          firstName: detalle.residente.usuario.firstName,
          lastName: detalle.residente.usuario.lastName,
          telefono: '',
          fechaNacimiento: '',
          dateJoined: '',
          rol: '',
        ),
        zona: detalle.residente.zona,
      ),
      areaComun: AreaComunDetalle(
        id: detalle.areaComun.id,
        nombre: detalle.areaComun.nombre,
        tipo: detalle.areaComun.tipo,
        costo: detalle.areaComun.costo,
      ),
      fechaReserva: detalle.fechaReserva,
      horaInicio: detalle.horaInicio,
      horaFin: detalle.horaFin,
      montoPagado: detalle.montoPagado,
      estado: detalle.estado,
      metodoPago: detalle.metodoPago,
    );
  }

  /// Carga las áreas comunes disponibles para el formulario de nueva reserva
  Future<void> loadAreasDisponibles() async {
    _setLoadingAreas(true);
    _clearError();

    try {
      _areas = await areasComunesService.getAreasDisponibles();
      print(
        '✅ ReservasProvider: Áreas comunes cargadas - ${_areas?.length} áreas',
      );
    } catch (e) {
      _setError('Error al cargar áreas comunes: $e');
      print('❌ ReservasProvider Error al cargar áreas: $e');
      _areas = [];
    } finally {
      _setLoadingAreas(false);
    }
  }

  /// Crea una nueva reserva
  Future<bool> createReserva(
    CreateReservaRequest request,
    BuildContext context,
  ) async {
    _setCreating(true);
    _clearError();

    try {
      await reservasRepository.createReserva(request);
      print('✅ ReservasProvider: Reserva creada exitosamente');

      // Recargar lista de reservas después de crear una nueva
      await loadMisReservas();

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Reserva creada exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );

      return true;
    } catch (e) {
      _setError('Error al crear reserva: $e');
      print('❌ ReservasProvider Error al crear reserva: $e');

      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear reserva: $e'),
          backgroundColor: Colors.red,
        ),
      );

      return false;
    } finally {
      _setCreating(false);
    }
  }

  // Métodos privados existentes
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

  // Métodos privados para áreas comunes y creación
  void _setLoadingAreas(bool loading) {
    _isLoadingAreas = loading;
    notifyListeners();
  }

  void _setCreating(bool creating) {
    _isCreating = creating;
    notifyListeners();
  }
}
