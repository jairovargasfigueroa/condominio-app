import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/accesos_provider.dart';

class CreateAccesoForm extends StatefulWidget {
  final bool isCreating;
  final String? errorMessage;
  final Future<bool> Function(int usuario, String tipoAcceso) onCreateAcceso;

  const CreateAccesoForm({
    Key? key,
    required this.isCreating,
    this.errorMessage,
    required this.onCreateAcceso,
  }) : super(key: key);

  @override
  _CreateAccesoFormState createState() => _CreateAccesoFormState();
}

class _CreateAccesoFormState extends State<CreateAccesoForm> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  String _tipoAcceso = 'ENTRADA';

  // Opciones de tipo de acceso
  final List<Map<String, String>> _tiposAcceso = [
    {'value': 'ENTRADA', 'label': 'Entrada'},
    {'value': 'SALIDA', 'label': 'Salida'},
  ];

  @override
  void dispose() {
    _usuarioController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final usuario = int.parse(_usuarioController.text);

    final success = await widget.onCreateAcceso(usuario, _tipoAcceso);

    if (success && mounted) {
      // Obtener el mensaje del servidor desde el provider
      final accesosProvider = Provider.of<AccesosProvider>(
        context,
        listen: false,
      );
      final mensaje =
          accesosProvider.successMessage ?? 'Acceso registrado exitosamente';

      // Mostrar mensaje de éxito del servidor
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      // Regresar a la pantalla principal después de un pequeño delay
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo Usuario ID
            TextFormField(
              controller: _usuarioController,
              decoration: InputDecoration(
                labelText: 'ID del Usuario',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                helperText: 'Ingrese el ID del usuario',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el ID del usuario';
                }
                if (int.tryParse(value) == null) {
                  return 'Por favor ingrese un número válido';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Selector de tipo de acceso
            DropdownButtonFormField<String>(
              value: _tipoAcceso,
              decoration: InputDecoration(
                labelText: 'Tipo de Acceso',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.login),
              ),
              items:
                  _tiposAcceso.map((tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo['value']!,
                      child: Text(tipo['label']!),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _tipoAcceso = value;
                  });
                }
              },
            ),

            SizedBox(height: 24),

            // Mostrar error si existe
            if (widget.errorMessage != null)
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.errorMessage!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ),

            // Botón de envío
            ElevatedButton(
              onPressed: widget.isCreating ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child:
                  widget.isCreating
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Registrando...'),
                        ],
                      )
                      : Text('Registrar Acceso'),
            ),
          ],
        ),
      ),
    );
  }
}
