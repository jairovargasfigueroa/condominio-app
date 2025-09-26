import 'package:flutter/material.dart';
import '../../data/models/area_comun_model.dart';
import '../../data/models/create_reserva_request.dart';

class CreateReservaForm extends StatefulWidget {
  final List<AreaComun>? areas;
  final bool isLoadingAreas;
  final bool isCreating;
  final String? errorMessage;
  final Future<bool> Function(CreateReservaRequest) onCreateReserva;

  const CreateReservaForm({
    Key? key,
    required this.areas,
    required this.isLoadingAreas,
    required this.isCreating,
    this.errorMessage,
    required this.onCreateReserva,
  }) : super(key: key);

  @override
  _CreateReservaFormState createState() => _CreateReservaFormState();
}

class _CreateReservaFormState extends State<CreateReservaForm> {
  final _formKey = GlobalKey<FormState>();

  AreaComun? _selectedArea;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Estado de carga o error
            if (widget.errorMessage != null) _buildErrorCard(),

            SizedBox(height: 16),

            // Selector de Área Común
            _buildAreaSelector(),
            SizedBox(height: 20),

            // Selector de Fecha
            _buildDateSelector(),
            SizedBox(height: 20),

            // Selectores de Hora
            Row(
              children: [
                Expanded(child: _buildTimeSelector(true)),
                SizedBox(width: 16),
                Expanded(child: _buildTimeSelector(false)),
              ],
            ),
            SizedBox(height: 20),

            // Resumen
            if (_selectedArea != null) _buildResumen(),

            SizedBox(height: 40),

            // Botón Crear
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaSelector() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Área Común',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            if (widget.isLoadingAreas)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Cargando áreas...'),
                  ],
                ),
              )
            else if (widget.areas == null || widget.areas!.isEmpty)
              Text(
                'No hay áreas comunes disponibles',
                style: TextStyle(color: Colors.grey[600]),
              )
            else
              DropdownButtonFormField<AreaComun>(
                value: _selectedArea,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Seleccionar área común...',
                ),
                items:
                    widget.areas!.map((area) {
                      return DropdownMenuItem<AreaComun>(
                        value: area,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              area.nombre,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Costo: \$${area.costo}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (AreaComun? newValue) {
                  setState(() {
                    _selectedArea = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona un área común';
                  }
                  return null;
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Fecha de Reserva',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text(
                      _selectedDate != null
                          ? _formatDate(_selectedDate!)
                          : 'Seleccionar fecha...',
                      style: TextStyle(
                        color:
                            _selectedDate != null
                                ? Colors.black
                                : Colors.grey[600],
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(bool isStart) {
    final time = isStart ? _startTime : _endTime;
    final label = isStart ? 'Hora de Inicio' : 'Hora de Fin';
    final icon = isStart ? Icons.access_time : Icons.schedule;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 20),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            InkWell(
              onTap: () => _selectTime(context, isStart),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey[600], size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        time != null ? time.format(context) : 'Seleccionar...',
                        style: TextStyle(
                          color: time != null ? Colors.black : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumen() {
    final duration = _calculateDuration();
    final totalCost = _calculateTotalCost();

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.summarize, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Resumen de Reserva',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            _buildSummaryRow('Área:', _selectedArea!.nombre),
            _buildSummaryRow(
              'Fecha:',
              _selectedDate != null
                  ? _formatDate(_selectedDate!)
                  : 'No seleccionada',
            ),
            _buildSummaryRow(
              'Horario:',
              _startTime != null && _endTime != null
                  ? '${_startTime!.format(context)} - ${_endTime!.format(context)}'
                  : 'No seleccionado',
            ),
            if (duration.isNotEmpty) _buildSummaryRow('Duración:', duration),
            _buildSummaryRow('Costo por hora:', '\$${_selectedArea!.costo}'),
            if (totalCost > 0)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total a Pagar:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '\$${totalCost.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
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

  Widget _buildSubmitButton() {
    final isFormValid = _isFormValid();

    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: isFormValid && !widget.isCreating ? _submitForm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('Creando reserva...'),
                  ],
                )
                : Text(
                  'Crear Reserva',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
      ),
    );
  }

  // Métodos auxiliares
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
      // locale: Locale('es', 'ES'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          // Si la hora de fin es anterior a la de inicio, limpiarla
          if (_endTime != null && _endTime!.hour <= picked.hour) {
            _endTime = null;
          }
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String _calculateDuration() {
    if (_startTime == null || _endTime == null) return '';

    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    final durationMinutes = endMinutes - startMinutes;

    if (durationMinutes <= 0) return 'Horario inválido';

    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    if (hours == 0) {
      return '$minutes minutos';
    } else if (minutes == 0) {
      return '$hours hora${hours > 1 ? 's' : ''}';
    } else {
      return '$hours hora${hours > 1 ? 's' : ''} y $minutes minutos';
    }
  }

  double _calculateTotalCost() {
    if (_selectedArea == null || _startTime == null || _endTime == null)
      return 0;

    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    final durationHours = (endMinutes - startMinutes) / 60.0;

    if (durationHours <= 0) return 0;

    return _selectedArea!.costoNumerico * durationHours;
  }

  bool _isFormValid() {
    return _selectedArea != null &&
        _selectedDate != null &&
        _startTime != null &&
        _endTime != null &&
        _endTime!.hour > _startTime!.hour;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || !_isFormValid()) {
      return;
    }

    // El residenteId se obtiene automáticamente del token JWT en el backend
    final request = CreateReservaRequest(
      areaComunId: _selectedArea!.id,
      fechaReserva: _formatDateForApi(_selectedDate!),
      horaInicio: _formatTimeOfDay(_startTime!),
      horaFin: _formatTimeOfDay(_endTime!),
    );

    final success = await widget.onCreateReserva(request);
    if (success) {
      // Navegar de vuelta a la lista
      Navigator.of(context).pop();
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  String _formatDateForApi(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$year-$month-$day';
  }
}
