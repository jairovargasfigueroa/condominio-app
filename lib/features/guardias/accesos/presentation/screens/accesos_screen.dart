import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/accesos_provider.dart';
import 'create_acceso_screen.dart';
import '../../../../../core/routing/route_names.dart';

class AccesosScreen extends StatefulWidget {
  @override
  _AccesosScreenState createState() => _AccesosScreenState();
}

class _AccesosScreenState extends State<AccesosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Accesos'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateAccesoScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Información de último acceso registrado
          Consumer<AccesosProvider>(
            builder: (context, accesosProvider, child) {
              if (accesosProvider.lastAcceso != null) {
                final acceso = accesosProvider.lastAcceso!;
                return Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    border: Border.all(color: Colors.green[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 32),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Acceso Registrado Exitosamente',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text('Usuario: ${acceso.usuario.nombreCompleto}'),
                            Text('Tipo: ${acceso.tipoAcceso}'),
                            Text('Fecha: ${acceso.fecha} ${acceso.hora}'),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          accesosProvider.clearLastAcceso();
                        },
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),

          // Botones principales
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Botón para registrar acceso manual
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateAccesoScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.login),
                  label: Text('Registrar Nuevo Acceso'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    minimumSize: Size(double.infinity, 56),
                  ),
                ),

                SizedBox(height: 12),

                // Botón para reconocimiento facial
                ElevatedButton.icon(
                  onPressed: () {
                    context.go(RouteNames.guardiaReconocimientoFacial);
                  },
                  icon: Icon(Icons.face),
                  label: Text('Reconocimiento Facial'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    minimumSize: Size(double.infinity, 56),
                  ),
                ),
              ],
            ),
          ),

          // Información adicional
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'Sistema de Control de Accesos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Registra las entradas y salidas de los usuarios',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
