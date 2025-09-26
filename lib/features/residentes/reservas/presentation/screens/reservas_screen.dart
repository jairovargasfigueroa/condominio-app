import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reservas_provider.dart';
import '../widgets/reservas_widget.dart';
import 'create_reserva_screen.dart';

class ReservasScreen extends StatefulWidget {
  @override
  _ReservasScreenState createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  @override
  void initState() {
    super.initState();
    print('🏠 ReservasScreen - initState() ejecutándose');
    // ✨ Carga automática de reservas al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🏠 ReservasScreen - Cargando reservas...');
      final reservasProvider = Provider.of<ReservasProvider>(
        context,
        listen: false,
      );
      reservasProvider.loadMisReservas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Reservas'), backgroundColor: Colors.blue),
      body: Consumer<ReservasProvider>(
        builder: (context, reservasProvider, child) {
          return ReservasWidget(
            reservas: reservasProvider.reservas,
            reservasData:
                reservasProvider.reservasData, // ✨ Nuevo: datos de respuesta
            isLoading: reservasProvider.isLoading,
            errorMessage: reservasProvider.errorMessage, // ✨ Manejo de errores
            onLoadReservas: () => reservasProvider.loadMisReservas(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateReservaScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Nueva Reserva',
      ),
    );
  }
}
