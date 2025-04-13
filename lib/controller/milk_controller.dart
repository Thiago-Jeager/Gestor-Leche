import 'package:intl/intl.dart';

import '../model/db_helper.dart';

class MilkController {
  final DBHelper _dbHelper = DBHelper();

  Future<void> agregarRegistroSiValido({
    required String fecha,
    required String litrosTexto,
    required String precioTexto,
    required int userId,
  }) async {
    if (litrosTexto.isNotEmpty && precioTexto.isNotEmpty) {
      double litros = double.tryParse(litrosTexto) ?? 0.0;
      double precio = double.tryParse(precioTexto) ?? 0.0;
      fecha = DateFormat('yyyy-MM-dd').format(
        DateTime(
          int.parse(fecha.split('-')[0]), // Año
          int.parse(fecha.split('-')[1]), // Mes
          int.parse(fecha.split('-')[2]), // Día
        ),
      ); // Formatear la fecha correctamente
      if (litros > 0 && precio > 0) {
        await _dbHelper.insertarRegistro(fecha, litros, precio, userId);
      }
    }
  }

  Future<void> borrarRegistro(int id) async {
    await _dbHelper.borrarRegistro(id);
  }

  Future<void> actualizarRegistro(
      int id, String fecha, double litros, double precio) async {
    fecha = DateFormat('yyyy-MM-dd').format(
      DateTime(
        int.parse(fecha.split('-')[0]), // Año
        int.parse(fecha.split('-')[1]), // Mes
        int.parse(fecha.split('-')[2]), // Día
      ),
    );
    await _dbHelper.actualizarRegistro(id, fecha, litros, precio);
  }

  Future<List<Map<String, dynamic>>> obtenerRegistros() async {
    return await _dbHelper.obtenerRegistros();
  }

  Future<List<Map<String, dynamic>>> obtenerRegistrosPorUsuario(
      int userId) async {
    return await _dbHelper.obtenerRegistrosPorUsuario(userId);
  }
}
