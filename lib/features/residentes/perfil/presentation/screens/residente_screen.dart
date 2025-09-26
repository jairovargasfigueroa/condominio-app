// residente_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/residente_provider.dart';
import '../widgets/residente_widget.dart';

class ResidenteScreen extends StatefulWidget {
  @override
  _ResidenteScreenState createState() => _ResidenteScreenState();
}

class _ResidenteScreenState extends State<ResidenteScreen> {
  @override
  void initState() {
    super.initState();
    print('🏠 ResidenteScreen - initState() ejecutándose');
    // ✨ Carga automática del perfil al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🏠 ResidenteScreen - Cargando perfil de residente...');
      final residenteProvider = Provider.of<ResidenteProvider>(
        context,
        listen: false,
      );
      residenteProvider.loadPerfilActual();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil'), backgroundColor: Colors.blue),
      body: Consumer<ResidenteProvider>(
        builder: (context, residenteProvider, child) {
          return ResidenteWidget(
            residente: residenteProvider.residente,
            perfil: residenteProvider.perfil, // ✨ Nuevo: datos del perfil
            isLoading: residenteProvider.isLoading,
            errorMessage: residenteProvider.errorMessage, // ✨ Manejo de errores
            onGetResidente: (id) => residenteProvider.loadResidente(id),
          );
        },
      ),
    );
  }
}
