import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import '../providers/accesos_provider.dart';

class FacialRecognitionScreen extends StatefulWidget {
  const FacialRecognitionScreen({super.key});

  @override
  State<FacialRecognitionScreen> createState() =>
      _FacialRecognitionScreenState();
}

class _FacialRecognitionScreenState extends State<FacialRecognitionScreen> {
  File? _capturedImage;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AccesosProvider>(
      builder: (context, accesosProvider, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('Reconocimiento Facial'),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: _buildBody(accesosProvider),
        );
      },
    );
  }

  Widget _buildBody(AccesosProvider provider) {
    if (_capturedImage != null) {
      return _buildImagePreview(provider);
    }

    return _buildCameraOptions(provider);
  }

  Widget _buildCameraOptions(AccesosProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 100, color: Colors.white70),
            const SizedBox(height: 30),
            Text(
              'Captura tu rostro para verificación',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Toma una foto con la cámara frontal',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Botón para tomar foto
            ElevatedButton.icon(
              onPressed:
                  (_isProcessing || provider.isValidatingFace)
                      ? null
                      : () => _takePhoto(),
              icon: Icon(Icons.camera_alt),
              label: Text('Tomar Foto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                minimumSize: Size(double.infinity, 60),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // Información adicional
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(Icons.info_outline, color: Colors.white70, size: 24),
                  SizedBox(height: 8),
                  Text(
                    'Asegúrate de que tu rostro esté bien iluminado y centrado',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Mostrar estado de validación
            if (provider.isValidatingFace) ...[
              const SizedBox(height: 30),
              CircularProgressIndicator(color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                'Validando rostro...',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(AccesosProvider provider) {
    return Column(
      children: [
        // Vista previa de la imagen
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(_capturedImage!, fit: BoxFit.cover),
            ),
          ),
        ),

        // Controles
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Estado de procesamiento
                if (_isProcessing || provider.isValidatingFace) ...[
                  CircularProgressIndicator(color: Colors.blue),
                  Text(
                    'Validando rostro con el servidor...',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  // Botones de acción
                  Row(
                    children: [
                      // Botón usar foto
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _usePhoto(),
                          icon: Icon(Icons.check),
                          label: Text('Validar Rostro'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 16),

                      // Botón tomar otra foto
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _selectAnotherImage(),
                          icon: Icon(Icons.camera_alt),
                          label: Text('Tomar Otra'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.front, // Cámara frontal para selfie
      );

      if (photo != null) {
        setState(() {
          _capturedImage = File(photo.path);
        });

        print('📸 Foto tomada con cámara frontal: ${photo.path}');
      } else {
        print('📷 El usuario canceló la captura de foto');
      }
    } catch (e) {
      _showError('Error al acceder a la cámara: $e');
      print('❌ Error de cámara: $e');
    }
  }

  Future<void> _usePhoto() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await _processImage(_capturedImage!);
    } catch (e) {
      _showError('Error al procesar la imagen: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _processImage(File imageFile) async {
    final accesosProvider = Provider.of<AccesosProvider>(
      context,
      listen: false,
    );

    try {
      // Obtener los bytes de la imagen
      final imageBytes = await imageFile.readAsBytes();
      final fileName = imageFile.path.split('/').last;

      print('=== ENVIANDO IMAGEN PARA VALIDACIÓN ===');
      print('📄 Archivo: $fileName');
      print('📏 Tamaño: ${imageBytes.length} bytes');
      print('🌐 Enviando a: http://localhost:8000/api/accesos/validar-rostro/');
      print('=====================================');

      // Realizar la validación facial
      final result = await accesosProvider.validarRostro(
        fotoBytes: imageBytes,
        fileName: fileName,
      );

      if (result != null && result.success && result.data != null) {
        // ✅ Rostro validado exitosamente
        final userData = result.data!.user;
        final confidence = result.data!.confidence;

        print('✅ ROSTRO VALIDADO EXITOSAMENTE:');
        print('👤 Usuario: ${userData.fullName} (@${userData.username})');
        print('🎯 Confianza: ${confidence.toStringAsFixed(1)}%');
        print('🆔 Face ID: ${result.data!.faceId}');
        print('📸 Foto Perfil: ${userData.fotoPerfilUrl ?? 'No disponible'}');

        _showSuccessDialog(
          'Rostro Validado',
          'Usuario: ${userData.fullName}\nConfianza: ${confidence.toStringAsFixed(1)}%',
          userData.fotoPerfilUrl,
        );
      } else {
        // ❌ No se encontró coincidencia
        print('❌ NO SE ENCONTRÓ COINCIDENCIA');
        print('📝 Mensaje: ${result?.message ?? 'Error desconocido'}');

        _showErrorDialog(
          'Rostro No Reconocido',
          result?.message ??
              'No se encontró coincidencia para el rostro enviado',
        );
      }
    } catch (e) {
      print('❌ ERROR AL PROCESAR IMAGEN: $e');
      _showErrorDialog('Error', 'Error al procesar la imagen: $e');
    }
  }

  void _selectAnotherImage() {
    setState(() {
      _capturedImage = null;
      _isProcessing = false;
    });
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _selectAnotherImage(); // Permitir tomar otra foto
              },
              child: const Text('Intentar de Nuevo'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pop(); // Regresar a accesos
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String title, String message, String? fotoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (fotoUrl != null && fotoUrl.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    fotoUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 100);
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _selectAnotherImage(); // Permitir validar otro rostro
              },
              child: const Text('Validar Otro'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                context.pop(); // Regresar a pantalla de accesos
              },
              child: const Text('Finalizar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pop(); // Regresar a accesos sin registrar
              },
              child: const Text('Solo Finalizar'),
            ),
          ],
        );
      },
    );
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
