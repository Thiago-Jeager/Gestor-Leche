import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  String selectedQuincena = "Primera Quincena";

  final List<String> months = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre"
  ];

  List<Map<String, dynamic>> data = [
    {"fecha": "01/03/2024", "litros": 100, "precio": 200},
    {"fecha": "02/03/2024", "litros": 100, "precio": 200},
    {"fecha": "15/03/2024", "litros": 120, "precio": 240},
    {"fecha": "20/03/2024", "litros": 130, "precio": 260},
    {"fecha": "01/04/2024", "litros": 110, "precio": 220},
    {"fecha": "15/04/2024", "litros": 130, "precio": 260},
    {"fecha": "25/04/2024", "litros": 140, "precio": 280},
  ];

  void _selectMonth(BuildContext context) async {
    final int? pickedMonth = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Seleccionar Mes"),
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: months.asMap().entries.map((entry) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, entry.key + 1);
                  },
                  child: Text(entry.value),
                );
              }).toList(),
            ),
          ],
        );
      },
    );

    if (pickedMonth != null) {
      setState(() {
        selectedMonth = pickedMonth;
      });
    }
  }

  void _selectYear(BuildContext context) async {
    final int? pickedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Seleccionar Año"),
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: List.generate(50, (index) => 2020 + index).map((year) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, year);
                  },
                  child: Text(year.toString()),
                );
              }).toList(),
            ),
          ],
        );
      },
    );

    if (pickedYear != null) {
      setState(() {
        selectedYear = pickedYear;
      });
    }
  }

  List<Map<String, dynamic>> _filterData() {
    final int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    final int quincenaEnd =
        selectedQuincena == "Primera Quincena" ? 15 : daysInMonth;
    final int quincenaStart = selectedQuincena == "Primera Quincena" ? 1 : 16;

    return data.where((row) {
      final DateTime rowDate =
          DateTime.parse(row["fecha"].split('/').reversed.join('-'));
      return rowDate.year == selectedYear &&
          rowDate.month == selectedMonth &&
          rowDate.day >= quincenaStart &&
          rowDate.day <= quincenaEnd;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    final String quincenaStart =
        selectedQuincena == "Primera Quincena" ? "1" : "16";
    final String quincenaEnd =
        selectedQuincena == "Primera Quincena" ? "15" : daysInMonth.toString();

    return Scaffold(
      backgroundColor: backgroundWhite,
      appBar: AppBar(
        backgroundColor: backgroundWhite,
        title: Text('Reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _selectMonth(context),
                  child: Text("Seleccionar Mes"),
                ),
                ElevatedButton(
                  onPressed: () => _selectYear(context),
                  child: Text("Seleccionar Año"),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Año seleccionado: $selectedYear',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Mes seleccionado: ${months[selectedMonth - 1]}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedQuincena,
              items: [
                DropdownMenuItem(
                  value: "Primera Quincena",
                  child: Text("Primera Quincena"),
                ),
                DropdownMenuItem(
                  value: "Segunda Quincena",
                  child: Text("Segunda Quincena"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedQuincena = value!;
                });
              },
            ),
            SizedBox(height: 10),
            Text(
              'Quincena seleccionada: $quincenaStart/$selectedMonth/$selectedYear - $quincenaEnd/$selectedMonth/$selectedYear',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Datos de la ${selectedQuincena.toLowerCase()} del $selectedMonth/$selectedYear',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('Litros')),
                    DataColumn(label: Text('Precio')),
                  ],
                  rows: _filterData()
                      .map(
                        (row) => DataRow(
                          cells: [
                            DataCell(Text(row["fecha"])),
                            DataCell(Text(row["litros"].toString())),
                            DataCell(Text(row["precio"].toString())),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
