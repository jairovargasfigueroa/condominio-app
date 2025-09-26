import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reservas_provider.dart';
import '../widgets/create_reserva_form.dart';

class CreateReservaScreen extends StatefulWidget {
  @override
  _CreateReservaScreenState createState() => _CreateReservaScreenState();
}

class _CreateReservaScreenState extends State<CreateReservaScreen> {
  @override
  void initState() {
    super.initState();
    print('🏠 CreateReservaScreen - initState() ejecutándose');
    // ✨ Carga automática de áreas disponibles al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🏠 CreateReservaScreen - Cargando áreas comunes...');
      final reservasProvider = Provider.of<ReservasProvider>(
        context,
        listen: false,
      );
      reservasProvider.loadAreasDisponibles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Reserva'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ReservasProvider>(
        builder: (context, reservasProvider, child) {
          return CreateReservaForm(
            areas: reservasProvider.areas,
            isLoadingAreas: reservasProvider.isLoadingAreas,
            isCreating: reservasProvider.isCreating,
            errorMessage: reservasProvider.errorMessage,
            onCreateReserva:
                (request) => reservasProvider.createReserva(request, context),
          );
        },
      ),
    );
  }
}
