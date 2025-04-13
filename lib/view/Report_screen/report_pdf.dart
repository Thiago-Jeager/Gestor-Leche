import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:flutter_milk_app/model/milk_model.dart';

Future<void> generarPDF(List<MilkModel> data, String filtro, int selectedYear,
    int selectedMonth, String userName, BuildContext context) async {
  final pdf = pw.Document();

  // Obtener el mes y el año seleccionados
  String mesSeleccionado = '';
  if (filtro.contains("Primera Quincena") ||
      filtro.contains("Segunda Quincena") ||
      filtro.contains("Mensual")) {
    mesSeleccionado =
        DateFormat.MMMM('es_ES').format(DateTime(0, selectedMonth));
  }

  // Crear el contenido del PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Reporte: $filtro',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
                pw.Row(
                  children: [
                    pw.Text(
                      'Generado el: ',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              children: [
                pw.Text(
                  'Usuario: ',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  userName,
                  style: const pw.TextStyle(fontSize: 14),
                ),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              children: [
                pw.Text(
                  filtro.contains("Anual") ? 'Año: ' : 'Mes: ',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  filtro.contains("Anual")
                      ? '$selectedYear'
                      : '$mesSeleccionado $selectedYear',
                  style: const pw.TextStyle(fontSize: 14),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.symmetric(
                inside: const pw.BorderSide(width: 0.5),
              ),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Fecha',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Litros',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Precio',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Total',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                ...data.map((milkModel) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(milkModel.fecha),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(milkModel.litros.toStringAsFixed(2)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(milkModel.precio.toStringAsFixed(2)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(milkModel.total.toStringAsFixed(2)),
                      ),
                    ],
                  );
                }),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text(
                          'Total:',
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text(
                          'Litros: ',
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          '${data.fold<double>(0.0, (sum, item) => sum + item.litros).toStringAsFixed(2)} lts',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text(
                          'Precio: ',
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          '\$${data.fold<double>(0.0, (sum, item) => sum + item.total).toStringAsFixed(2)}',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  // Guardar el PDF en el directorio de documentos
  try {
    final directory = Directory('/storage/emulated/0/Documents');
    // Crear la carpeta "milk_controller" dentro de "Documents"
    final milkControllerDir = Directory('${directory.path}/milk_controller');
    if (!await milkControllerDir.exists()) {
      await milkControllerDir.create(recursive: true);
    }

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file =
        File('${milkControllerDir.path}/reporte_$filtro _ $timestamp.pdf');
    await file.writeAsBytes(await pdf.save());
    //print(file);
    // Abrir el archivo PDF
    await OpenFile.open(file.path);

    // Mostrar un mensaje de éxito
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF guardado en: ${file.path}')),
    );
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al guardar el PDF: $e')),
    );
    //print(e);
  }
}
