import 'acceso_response_model.dart';

/// Resultado completo de crear un acceso
class CreateAccesoResult {
  final bool success;
  final String message;
  final AccesoData? data;

  CreateAccesoResult({required this.success, required this.message, this.data});
}
