// expensas_widget.dart
import 'package:flutter/material.dart';
import '../../data/models/expensa_model.dart';

class ExpensasWidget extends StatelessWidget {
  final List<ExpensaModel> expensas;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRefresh;
  final bool tieneViviendaAsignada; // Nuevo parámetro para distinguir casos

  const ExpensasWidget({
    Key? key,
    required this.expensas,
    required this.isLoading,
    this.errorMessage,
    required this.onRefresh,
    this.tieneViviendaAsignada =
        true, // Por defecto asume que sí tiene vivienda
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
            ElevatedButton(onPressed: onRefresh, child: Text('Reintentar')),
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
            Text('Cargando expensas...', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    // ✨ Si no hay expensas
    if (expensas.isEmpty) {
      return _buildEmptyState();
    }

    // ✨ Lista de expensas con RefreshIndicator
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        // Esperar un poco para que se vea el indicador
        await Future.delayed(Duration(milliseconds: 500));
      },
      child: Column(
        children: [
          // Header con información de vivienda (tomar de la primera expensa)
          if (expensas.isNotEmpty)
            _buildViviendaHeader(expensas.first.vivienda),

          // Lista de expensas
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: expensas.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final expensa = expensas[index];
                return ExpensaCard(
                  expensa: expensa,
                  onTap: () {
                    // TODO: Navegar al detalle o mostrar opciones de pago
                    _mostrarOpcionesPago(context, expensa);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Header que muestra información de la vivienda
  Widget _buildViviendaHeader(ViviendaModel vivienda) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          Icon(Icons.home, color: Colors.blue.shade600),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vivienda ${vivienda.numero}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue.shade800,
                  ),
                ),
                Text(
                  vivienda.direccion,
                  style: TextStyle(color: Colors.blue.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra opciones de pago para una expensa
  void _mostrarOpcionesPago(BuildContext context, ExpensaModel expensa) {
    if (expensa.estado != 'pendiente') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Esta expensa ya está ${expensa.estado}'),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pagar ${expensa.descripcionCompleta}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Monto: \$${expensa.montoPagado}',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),

                // Opciones de pago
                ListTile(
                  leading: Icon(Icons.credit_card, color: Colors.blue),
                  title: Text('Tarjeta de Crédito'),
                  subtitle: Text('Pago inmediato con Stripe'),
                  onTap: () {
                    Navigator.pop(context);
                    _pagarConTarjeta(context, expensa);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.money, color: Colors.green),
                  title: Text('Efectivo'),
                  subtitle: Text('Pagar en administración'),
                  onTap: () {
                    Navigator.pop(context);
                    _pagarConEfectivo(context, expensa);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.qr_code, color: Colors.purple),
                  title: Text('Código QR'),
                  subtitle: Text('Escanear para pagar'),
                  onTap: () {
                    Navigator.pop(context);
                    _pagarConQR(context, expensa);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _pagarConTarjeta(BuildContext context, ExpensaModel expensa) {
    // TODO: Implementar pago con tarjeta
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Pago con tarjeta - Próximamente')));
  }

  void _pagarConEfectivo(BuildContext context, ExpensaModel expensa) {
    // TODO: Implementar marcado de pago en efectivo
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Pago en efectivo - Próximamente')));
  }

  void _pagarConQR(BuildContext context, ExpensaModel expensa) {
    // TODO: Implementar pago con QR
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Pago con QR - Próximamente')));
  }

  /// Widget para mostrar el estado vacío (sin vivienda o sin expensas)
  Widget _buildEmptyState() {
    if (!tieneViviendaAsignada) {
      // Caso: No tiene vivienda asignada
      return RefreshIndicator(
        onRefresh: () async => onRefresh(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.shade200, width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: Colors.orange.shade600,
                        size: 80,
                      ),
                      SizedBox(height: 24),
                      Text(
                        '🏠 Sin Vivienda Asignada',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Para ver tus expensas necesitas tener una vivienda asignada en el sistema.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange.shade700,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange.shade600,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Contacta al administrador del condominio',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Desliza hacia abajo para actualizar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Caso: Tiene vivienda pero no hay expensas
      return RefreshIndicator(
        onRefresh: () async => onRefresh(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade200, width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: Colors.blue.shade600,
                        size: 80,
                      ),
                      SizedBox(height: 24),
                      Text(
                        '📄 Sin Expensas',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No tienes expensas pendientes por el momento. ¡Todo al día! 👍',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue.shade700,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Desliza hacia abajo para actualizar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

/// Card individual de expensa
class ExpensaCard extends StatelessWidget {
  final ExpensaModel expensa;
  final VoidCallback onTap;

  const ExpensaCard({Key? key, required this.expensa, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con estado y fecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEstadoBadge(expensa.estado, expensa.estaVencida),
                  Text(
                    _formatearFechaVencimiento(expensa.fechaVencimiento),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Descripción y monto
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expensa.descripcionCompleta,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (expensa.metodoPago != null)
                          Text(
                            'Pagado con: ${expensa.metodoPago}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${expensa.montoPagado}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              expensa.estado == 'pendiente'
                                  ? Colors.red[600]
                                  : Colors.green[600],
                        ),
                      ),
                      if (expensa.estado == 'pendiente')
                        Text(
                          'PAGAR',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadoBadge(String estado, bool estaVencida) {
    Color backgroundColor;
    Color textColor;
    String texto;

    if (estado == 'pendiente') {
      if (estaVencida) {
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        texto = 'VENCIDA';
      } else {
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        texto = 'PENDIENTE';
      }
    } else if (estado == 'confirmada') {
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade700;
      texto = 'PAGADA';
    } else {
      backgroundColor = Colors.grey.shade100;
      textColor = Colors.grey.shade700;
      texto = estado.toUpperCase();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatearFechaVencimiento(DateTime fecha) {
    return 'Vence: ${fecha.day}/${fecha.month}/${fecha.year}';
  }
}
