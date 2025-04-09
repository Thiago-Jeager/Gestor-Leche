import '../model/db_helper.dart';

class MilkController {
  final DBHelper _dbHelper = DBHelper();

  Future<void> agregarRegistroSiValido({
    required String fecha,
    required String litrosTexto,
    required String precioTexto,
  }) async {
    if (litrosTexto.isNotEmpty && precioTexto.isNotEmpty) {
      double litros = double.tryParse(litrosTexto) ?? 0.0;
      double precio = double.tryParse(precioTexto) ?? 0.0;

      if (litros > 0 && precio > 0) {
        await _dbHelper.insertarRegistro(fecha, litros, precio);
      }
    }
  }

  Future<List<Map<String, dynamic>>> obtenerRegistros() async {
    return await _dbHelper.obtenerRegistros();
  }

  Future<List<Map<String, dynamic>>> obtenerRegistrosPorFecha(
      String fecha) async {
    return await _dbHelper.obtenerRegistrosPorFecha(fecha);
  }
}
