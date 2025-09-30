// expensas_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expensas_provider.dart';
import '../widgets/expensas_widget.dart';

class ExpensasScreen extends StatefulWidget {
  @override
  _ExpensasScreenState createState() => _ExpensasScreenState();
}

class _ExpensasScreenState extends State<ExpensasScreen> {
  @override
  void initState() {
    super.initState();
    print('🏠 ExpensasScreen - initState() ejecutándose');
    // ✨ Carga automática de expensas al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🏠 ExpensasScreen - Cargando expensas...');
      final expensasProvider = Provider.of<ExpensasProvider>(
        context,
        listen: false,
      );
      expensasProvider.cargarExpensas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expensas'),
        backgroundColor: Colors.blue,
        actions: [
          // Botón de refrescar
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final provider = Provider.of<ExpensasProvider>(
                context,
                listen: false,
              );
              provider.refrescarExpensas();
            },
          ),
        ],
      ),
      body: Consumer<ExpensasProvider>(
        builder: (context, expensasProvider, child) {
          return ExpensasWidget(
            expensas: expensasProvider.expensas,
            isLoading: expensasProvider.isLoading,
            errorMessage: expensasProvider.errorMessage,
            onRefresh: () => expensasProvider.refrescarExpensas(),
            tieneViviendaAsignada: expensasProvider.tieneVivienda,
          );
        },
      ),
    );
  }
}
