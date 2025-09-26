import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accesos_provider.dart';
import '../widgets/create_acceso_form.dart';

class CreateAccesoScreen extends StatefulWidget {
  @override
  _CreateAccesoScreenState createState() => _CreateAccesoScreenState();
}

class _CreateAccesoScreenState extends State<CreateAccesoScreen> {
  @override
  void initState() {
    super.initState();
    print('🚪 CreateAccesoScreen - initState() ejecutándose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Acceso'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AccesosProvider>(
        builder: (context, accesosProvider, child) {
          return CreateAccesoForm(
            isCreating: accesosProvider.isCreating,
            errorMessage: accesosProvider.errorMessage,
            onCreateAcceso:
                (usuario, tipoAcceso) => accesosProvider.createAcceso(
                  usuario: usuario,
                  tipoAcceso: tipoAcceso,
                ),
          );
        },
      ),
    );
  }
}
