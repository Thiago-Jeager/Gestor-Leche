import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';
import 'package:flutter_milk_app/const/const.dart';
import 'package:flutter_milk_app/controller/milk_controller.dart';
import 'package:flutter_milk_app/model/milk_model.dart';
import 'package:flutter_milk_app/widget/report_button.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final MilkController _controller = MilkController();
  List<MilkModel> _data =
      []; // Lista para almacenar los datos de la base de datos
  bool _isLoading = true; // Indicador de carga

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  String selectedQuincena = "Primera Quincena";

  @override
  void initState() {
    super.initState();
    _loadData(); // Cargar los datos al iniciar la vista
  }

  Future<void> _loadData() async {
    final registros = await _controller.obtenerRegistros();
    setState(() {
      _data = registros.map((registro) {
        // Asegúrate de que la fecha tenga el formato correcto
        final partesFecha = registro['fecha'].split('-');
        final fechaFormateada =
            '${partesFecha[0]}-${partesFecha[1].padLeft(2, '0')}-${partesFecha[2].padLeft(2, '0')}';
        return MilkModel.fromMap({
          ...registro,
          'fecha':
              fechaFormateada, // Reemplaza la fecha con el formato correcto
        });
      }).toList();
      _isLoading = false; // Finaliza la carga
    });
  }

  List<MilkModel> _filterData() {
    if (selectedQuincena == "Anual") {
      // Filtrar por año completo
      return _data.where((milkModel) {
        final DateTime rowDate = DateTime.parse(milkModel.fecha);
        return rowDate.year == selectedYear;
      }).toList();
    } else if (selectedQuincena == "Mensual") {
      // Filtrar por mes completo
      return _data.where((milkModel) {
        final DateTime rowDate = DateTime.parse(milkModel.fecha);
        return rowDate.year == selectedYear && rowDate.month == selectedMonth;
      }).toList();
    } else {
      // Filtrar por quincena
      final int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
      final int quincenaStart = selectedQuincena == "Primera Quincena" ? 1 : 16;
      final int quincenaEnd =
          selectedQuincena == "Primera Quincena" ? 15 : daysInMonth;

      return _data.where((milkModel) {
        final DateTime rowDate = DateTime.parse(milkModel.fecha);
        return rowDate.year == selectedYear &&
            rowDate.month == selectedMonth &&
            rowDate.day >= quincenaStart &&
            rowDate.day <= quincenaEnd;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,
      appBar: AppBar(
        backgroundColor: backgroundWhite,
        title: const Text('Reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Text(
                DateFormat.yMMMMd('es_ES').format(DateTime.now()),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ReportButton(
                      label: "Mes",
                      onTap: () => _selectMonth(context),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      months[selectedMonth - 1],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ReportButton(
                      label: "Año",
                      onTap: () => _selectYear(context),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      selectedYear.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      "Inicio Quincena",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      selectedQuincena == "Primera Quincena"
                          ? "1-${selectedMonth.toString().padLeft(2, '0')}-${selectedYear}"
                          : "16-${selectedMonth.toString().padLeft(2, '0')}-${selectedYear}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Fin Quincena",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      selectedQuincena == "Primera Quincena"
                          ? "15-${selectedMonth.toString().padLeft(2, '0')}-${selectedYear}"
                          : "${DateTime(selectedYear, selectedMonth + 1, 0).day}-${selectedMonth.toString().padLeft(2, '0')}-${selectedYear}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedQuincena,
              items: const [
                DropdownMenuItem(
                  value: "Primera Quincena",
                  child: Text("Primera Quincena"),
                ),
                DropdownMenuItem(
                  value: "Segunda Quincena",
                  child: Text("Segunda Quincena"),
                ),
                DropdownMenuItem(
                  value: "Mensual",
                  child: Text("Mensual"),
                ),
                DropdownMenuItem(
                  value: "Anual",
                  child: Text("Anual"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedQuincena = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Fecha')),
                            DataColumn(label: Text('Litros')),
                            DataColumn(label: Text('Precio')),
                            DataColumn(label: Text('Total')),
                          ],
                          rows: [
                            ..._filterData().map(
                              (milkModel) => DataRow(
                                cells: [
                                  DataCell(Text(milkModel.fecha)),
                                  DataCell(Text(milkModel.litros.toString())),
                                  DataCell(Text(milkModel.precio.toString())),
                                  DataCell(Text(milkModel.total.toString())),
                                ],
                              ),
                            ),
                            // Fila de totales
                            DataRow(
                              cells: [
                                const DataCell(Text(
                                  'Total',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataCell(Text(
                                  _filterData()
                                      .fold<double>(
                                          0.0, (sum, item) => sum + item.litros)
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                                const DataCell(
                                    Text('')), // Celda vacía para "Precio"
                                DataCell(Text(
                                  _filterData()
                                      .fold<double>(
                                          0.0, (sum, item) => sum + item.total)
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _selectMonth(BuildContext context) async {
    final int? pickedMonth = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: backgroundWhite,
          title: const Center(child: Text("Seleccionar Mes")),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: months.asMap().entries.map((entry) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 20,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cambridgeBlue,
                        ),
                        onPressed: () {
                          Navigator.pop(context, entry.key + 1);
                        },
                        child: Text(
                          entry.value,
                          style: const TextStyle(color: textblack),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
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
          backgroundColor: backgroundWhite,
          title: const Center(child: Text("Seleccionar Año")),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: List.generate(DateTime.now().year - 2020 + 1,
                      (index) => 2020 + index).map((year) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 20,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cambridgeBlue,
                        ),
                        onPressed: () {
                          Navigator.pop(context, year);
                        },
                        child: Text(
                          year.toString(),
                          style: const TextStyle(color: textblack),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
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
}
