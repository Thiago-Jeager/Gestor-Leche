import 'package:get/get.dart';
import '../model/db_helper.dart';
import '../model/user_model.dart';

class UserController extends GetxController {
  final DBHelper _dbHelper = DBHelper();
  var usuarios = <UserModel>[].obs;
  var usuarioSeleccionado = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    final usuariosDB = await _dbHelper.obtenerUsuarios();
    usuarios.value = usuariosDB.map((e) => UserModel.fromMap(e)).toList();
    if (usuarios.isNotEmpty) {
      usuarioSeleccionado.value =
          usuarios.first; // Seleccionar el primer usuario por defecto
    }
  }

  void seleccionarUsuario(UserModel usuario) {
    usuarioSeleccionado.value = usuario;
  }
}
