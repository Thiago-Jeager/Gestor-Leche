import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/db_helper.dart';

class HomeController extends GetxController {
  var currentNavIndex = 0.obs;
  var litrosHoy = 0.0; // Variable para los litros del día
  final DBHelper _dbHelper = DBHelper();

  @override
  void onInit() {
    super.onInit();
    cargarLitrosDelDia(); // Cargar los litros al iniciar
  }

  Future<void> cargarLitrosDelDia() async {
    final String fechaHoy = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final registros = await _dbHelper.obtenerRegistrosPorFecha(fechaHoy);

    litrosHoy = registros.fold<double>(
      0.0,
      (sum, registro) => sum + (registro['litros'] as double),
    );

    update(); // Notifica a los widgets que usan GetBuilder para actualizarse
  }
}
