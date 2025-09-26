import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/features/guardias/perfil/presentation/providers/guardia_provider.dart';
import 'package:my_flutter_app/features/guardias/perfil/presentation/widgets/guardia_widget.dart';

class GuardiaScreen extends StatefulWidget {
  const GuardiaScreen({Key? key}) : super(key: key);

  @override
  State<GuardiaScreen> createState() => _GuardiaScreenState();
}

class _GuardiaScreenState extends State<GuardiaScreen> {
  @override
  void initState() {
    super.initState();
    print('🛡️ GuardiaScreen - initState() ejecutándose');
    // Cargar perfil del guardia al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🛡️ GuardiaScreen - Cargando perfil de guardia...');
      context.read<GuardiaProvider>().fetchPerfilGuardia();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Guardia'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Consumer<GuardiaProvider>(
        builder: (context, guardiaProvider, child) {
          if (guardiaProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando perfil del guardia...'),
                ],
              ),
            );
          }

          if (guardiaProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar datos',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    guardiaProvider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      guardiaProvider.reloadPerfil();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (!guardiaProvider.tienePerfilGuardia) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No se encontró perfil de guardia'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await guardiaProvider.reloadPerfil();
            },
            child: const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.0),
              child: GuardiaWidget(),
            ),
          );
        },
      ),
    );
  }
}
