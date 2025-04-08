import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _numberController = TextEditingController();

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
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Número',
                labelStyle: const TextStyle(
                    color: textblack), // Cambia el color de la letra a negro
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: backgroundWhite, // Cambia el color de fondo a blanco
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: hunterGreen, width: 2.0),
                ), // Cambia el color del borde cuando está seleccionado
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: textblack, // Cambia el color de fondo
                foregroundColor: ashGray2, // Cambia el color de la letra
              ),
              onPressed: () {
                String enteredNumber = _numberController.text;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Fecha seleccionada: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} - Número ingresado: $enteredNumber',
                    ),
                  ),
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}
