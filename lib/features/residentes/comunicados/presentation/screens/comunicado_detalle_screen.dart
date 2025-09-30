// comunicado_detalle_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/comunicados_provider.dart';
import '../widgets/comunicado_detalle_widget.dart';

class ComunicadoDetalleScreen extends StatefulWidget {
  final String comunicadoId;

  const ComunicadoDetalleScreen({Key? key, required this.comunicadoId})
    : super(key: key);

  @override
  _ComunicadoDetalleScreenState createState() =>
      _ComunicadoDetalleScreenState();
}

class _ComunicadoDetalleScreenState extends State<ComunicadoDetalleScreen> {
  @override
  void initState() {
    super.initState();
    print(
      '📖 ComunicadoDetalleScreen - initState() para ID: ${widget.comunicadoId}',
    );
    // ✨ Carga automática del comunicado al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('📖 ComunicadoDetalleScreen - Cargando comunicado...');
      final comunicadosProvider = Provider.of<ComunicadosProvider>(
        context,
        listen: false,
      );
      final id = int.tryParse(widget.comunicadoId);
      if (id != null) {
        // Cargar el comunicado y marcarlo como leído
        comunicadosProvider.cargarComunicado(id).then((_) {
          // Una vez cargado exitosamente, marcarlo como leído
          comunicadosProvider.marcarComoLeido(id);
        });
      }
    });
  }

  @override
  void dispose() {
    // ✨ Limpiar el comunicado seleccionado al salir
    final comunicadosProvider = Provider.of<ComunicadosProvider>(
      context,
      listen: false,
    );
    comunicadosProvider.limpiarComunicadoSeleccionado();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comunicado'), backgroundColor: Colors.blue),
      body: Consumer<ComunicadosProvider>(
        builder: (context, comunicadosProvider, child) {
          return ComunicadoDetalleWidget(
            comunicado: comunicadosProvider.comunicadoSeleccionado,
            isLoading: comunicadosProvider.isLoadingDetalle,
            errorMessage: comunicadosProvider.errorMessageDetalle,
            onRetry: () {
              final id = int.tryParse(widget.comunicadoId);
              if (id != null) {
                // Cargar el comunicado y marcarlo como leído
                comunicadosProvider.cargarComunicado(id).then((_) {
                  comunicadosProvider.marcarComoLeido(id);
                });
              }
            },
          );
        },
      ),
    );
  }
}
