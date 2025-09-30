// comunicados_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/comunicados_provider.dart';
import '../widgets/comunicados_widget.dart';

class ComunicadosScreen extends StatefulWidget {
  @override
  _ComunicadosScreenState createState() => _ComunicadosScreenState();
}

class _ComunicadosScreenState extends State<ComunicadosScreen> {
  @override
  void initState() {
    super.initState();
    print('📢 ComunicadosScreen - initState() ejecutándose');
    // ✨ Carga automática de comunicados al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('📢 ComunicadosScreen - Cargando comunicados...');
      final comunicadosProvider = Provider.of<ComunicadosProvider>(
        context,
        listen: false,
      );
      comunicadosProvider.cargarComunicados();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comunicados'),
        backgroundColor: Colors.blue,
        actions: [
          // Botón de refrescar
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final provider = Provider.of<ComunicadosProvider>(
                context,
                listen: false,
              );
              provider.refrescarComunicados();
            },
          ),
        ],
      ),
      body: Consumer<ComunicadosProvider>(
        builder: (context, comunicadosProvider, child) {
          return ComunicadosWidget(
            comunicados: comunicadosProvider.comunicados,
            isLoading: comunicadosProvider.isLoading,
            errorMessage: comunicadosProvider.errorMessage,
            onRefresh: () => comunicadosProvider.refrescarComunicados(),
          );
        },
      ),
    );
  }
}
