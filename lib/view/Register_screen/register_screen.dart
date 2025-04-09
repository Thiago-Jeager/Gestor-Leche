import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';
import 'package:flutter_milk_app/controller/milk_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _controller = MilkController();
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _litrosController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  //final TextEditingController _totalController = TextEditingController();

  Future<void> _guardarRegistro() async {
    await _controller.agregarRegistroSiValido(
      fecha: _fechaController.text,
      litrosTexto: _litrosController.text,
      precioTexto: _precioController.text,
    );
    _litrosController.clear();
    _precioController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,
      appBar: AppBar(
        backgroundColor: backgroundWhite,
        title: const Text('Seleccionar Fecha y Número'),
      ),
      body: Container(
        color: backgroundWhite,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                locale: 'es_ES', // Configura el idioma a español
                firstDay: DateTime(2000),
                lastDay: DateTime.now(),
                focusedDay: _selectedDate,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                  });
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: hunterGreen,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: ashGray,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false, // Oculta el botón de formato
                  titleCentered: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextField(
                        controller: _litrosController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Litros',
                          labelStyle: TextStyle(color: textblack),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: backgroundWhite,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: hunterGreen, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        controller: _precioController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Precio',
                          labelStyle: TextStyle(color: textblack),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: backgroundWhite,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: hunterGreen, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: textblack, // Cambia el color de fondo
                  foregroundColor: ashGray2, // Cambia el color de la letra
                ),
                onPressed: () {
                  String litros = _litrosController.text;
                  String precio = _precioController.text;
                  String fecha =
                      '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
                  _fechaController.text = fecha; // Actualiza el campo de fecha
                  if (litros.isEmpty || precio.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            backgroundColor: backgroundWhite,
                            title: Text('Error'),
                            content: Text(
                                'Por favor, completa todos los campos.',
                                style: TextStyle(color: textblack)),
                          );
                        });
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: backgroundWhite,
                        title: const Text('Confirmar Registro'),
                        content: Text(
                          'Fecha: $fecha\nLitros: $litros\nPrecio: $precio\n\n¿Deseas guardar esta información?',
                        ),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: hunterGreen,
                              foregroundColor: backgroundWhite,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // Cierra el diálogo
                            },
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hunterGreen,
                              foregroundColor: backgroundWhite,
                            ),
                            onPressed: () {
                              _guardarRegistro();
                              Navigator.of(context).pop(); // Cierra el diálogo
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Registro guardado: Fecha: $fecha - Litros: $litros - Precio: $precio',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Guardar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Guardar Registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
