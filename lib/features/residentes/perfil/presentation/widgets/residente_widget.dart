// residente_widget.dart
import 'package:flutter/material.dart';
import '../../data/models/residente_model.dart';
import '../../data/models/perfil_response_model.dart';

class ResidenteWidget extends StatelessWidget {
  final ResidenteModel? residente;
  final PerfilData? perfil; // ✨ Nuevo: datos del perfil automático
  final bool isLoading;
  final String? errorMessage; // ✨ Nuevo: manejo de errores
  final Function(int) onGetResidente;

  const ResidenteWidget({
    Key? key,
    required this.residente,
    this.perfil, // ✨ Opcional porque puede no estar cargado aún
    required this.isLoading,
    this.errorMessage, // ✨ Opcional
    required this.onGetResidente,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✨ Si hay error, mostrarlo
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => onGetResidente(1), // Botón de retry
              child: Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    // ✨ Si está cargando, mostrar indicador
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando perfil...'),
          ],
        ),
      );
    }

    // ✨ Si tenemos datos del perfil, mostrarlos automáticamente
    if (perfil != null) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue, size: 32),
                    SizedBox(width: 12),
                    Text(
                      'Mi Perfil',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Divider(height: 32),

                // Información del residente
                _buildInfoSection('Información Personal', [
                  _buildInfoRow('ID Residente', '#${perfil!.id}'),
                  _buildInfoRow('Zona', perfil!.zona),
                ]),

                SizedBox(height: 20),

                // Información del usuario
                _buildInfoSection('Datos del Usuario', [
                  _buildInfoRow('Username', perfil!.usuario.username),
                  _buildInfoRow('Email', perfil!.usuario.email),
                  _buildInfoRow('Nombre', perfil!.usuario.firstName),
                  _buildInfoRow('Apellido', perfil!.usuario.lastName),
                  _buildInfoRow('Teléfono', perfil!.usuario.telefono),
                  _buildInfoRow(
                    'Fecha Nacimiento',
                    perfil!.usuario.fechaNacimiento,
                  ),
                ]),
              ],
            ),
          ),
        ),
      );
    }

    // ✨ Si tenemos datos del residente (método anterior), mostrarlos
    if (residente != null) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perfil del Residente',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('ID: ${residente!.id}'),
                Text('Zona: ${residente!.zona}'),
                SizedBox(height: 16),
                Text(
                  'Información del Usuario:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Username: ${residente!.usuario.username}'),
                Text('Email: ${residente!.usuario.email}'),
                Text('Nombre: ${residente!.usuario.firstName}'),
                Text('Apellido: ${residente!.usuario.lastName}'),
                Text(
                  'Teléfono: ${residente!.usuario.telefono ?? 'No especificado'}',
                ),
                Text(
                  'Fecha Nacimiento: ${residente!.usuario.fechaNacimiento ?? 'No especificado'}',
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ✨ Estado por defecto: esperando datos
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_circle, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Preparando tu perfil...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ✨ Widget helper para secciones de información
  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  // ✨ Widget helper para filas de información
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[800])),
          ),
        ],
      ),
    );
  }
}
