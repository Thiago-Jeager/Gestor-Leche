import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';
import 'package:flutter_milk_app/controller/milk_controller.dart';
import 'package:flutter_milk_app/model/milk_model.dart';
import 'package:flutter_milk_app/widget/action_button.dart';
import 'package:flutter_milk_app/widget/calendar_header.dart';
//import 'package:flutter_milk_app/widget/button.dart';
import 'package:table_calendar/table_calendar.dart';

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Validaciones
  final GlobalKey<FormState> _formstate = GlobalKey<FormState>();
  //
  final _controller = MilkController();
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  late PageController _pageController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _litrosController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  final LinkedHashMap<DateTime, List<Event>> kEvents = LinkedHashMap(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  Future<void> _guardarRegistro() async {
    await _controller.agregarRegistroSiValido(
      fecha: _fechaController.text,
      litrosTexto: _litrosController.text,
      precioTexto: _precioController.text,
    );
    _litrosController.clear();
    _precioController.clear();
  }

  Future<void> cargarEventosDesdeBaseDeDatos() async {
    final registros = await _controller.obtenerRegistros();

    setState(() {
      kEvents.clear();
      for (var registro in registros) {
        final partesFecha = registro['fecha'].split('-');
        final fecha = DateTime(
          int.parse(partesFecha[0]),
          int.parse(partesFecha[1]),
          int.parse(partesFecha[2]),
        );

        if (kEvents[fecha] == null) {
          kEvents[fecha] = [];
        }

        kEvents[fecha]!.add(Event(
            'Litros: ${registro['litros']}, Precio: ${registro['precio']}, Total: ${registro['total']}'));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fechaController.text =
        '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
    cargarEventosDesdeBaseDeDatos();
    //_cargarRegistrosDelDia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,
      appBar: AppBar(
        backgroundColor: backgroundWhite,
        title: const Text('Seleccionar Fecha y Número'),
      ),
      body: Column(
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: _focusedDay,
            builder: (context, value, _) {
              return CalendarHeader(
                focusedDay: value,
                onTodayButtonTap: () {
                  setState(() => _focusedDay.value = DateTime.now());
                },
                onLeftArrowTap: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                onRightArrowTap: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                onAddButtonTap: () {
                  // Acción para agregar un nuevo registro
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: backgroundWhite,
                        title: const Text('Agregar Registro'),
                        content: Form(
                          key: _formstate,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo requerido';
                                  }
                                  return null;
                                },
                                controller: _litrosController,
                                decoration: const InputDecoration(
                                    labelText: 'Litros',
                                    errorStyle: TextStyle()),
                                keyboardType: TextInputType.number,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo requerido';
                                  }
                                  return null;
                                },
                                controller: _precioController,
                                decoration: const InputDecoration(
                                  labelText: 'Precio',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: hunterGreen,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: backgroundWhite),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hunterGreen,
                            ),
                            onPressed: () async {
                              if (_formstate.currentState!.validate()) {
                                final fecha =
                                    '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
                                _fechaController.text = fecha;
                                _guardarRegistro();
                                cargarEventosDesdeBaseDeDatos();
                                Navigator.of(context)
                                    .pop(); // Cierra el diálogo
                              }
                            },
                            child: const Text(
                              'Guardar',
                              style: TextStyle(color: backgroundWhite),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                addButtonVisible: (kEvents[_selectedDate] ?? []).isEmpty,
              );
            },
          ),
          TableCalendar<Event>(
            locale: 'es_ES',
            firstDay: DateTime(2000),
            lastDay: DateTime.now(),
            focusedDay: _selectedDate,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            headerVisible: false,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
            onCalendarCreated: (controller) => _pageController = controller,
            onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() => _calendarFormat = format);
              }
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
              //_cargarRegistrosDelDia();
            },
            eventLoader: (day) {
              return kEvents[day] ?? [];
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
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: ValueNotifier(kEvents[_selectedDate] ?? []),
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final event = value[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Litros: ${event.title.split(',')[0].split(':')[1].trim()}'),
                                Text(
                                    'Precio: ${event.title.split(',')[1].split(':')[1].trim()}'),
                                Text(
                                    'Total: ${event.title.split(',')[2].split(':')[1].trim()}'),
                              ],
                            ),
                            ActionButton(
                              icon: const Icon(Icons.edit),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: _litrosController,
                                              decoration: const InputDecoration(
                                                labelText: 'Litros',
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            TextField(
                                              controller: _precioController,
                                              decoration: const InputDecoration(
                                                labelText: 'Precio',
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final fecha =
                                                    '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
                                                _fechaController.text = fecha;
                                                cargarEventosDesdeBaseDeDatos();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Actualizar'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const ActionButton(icon: Icon(Icons.delete)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
