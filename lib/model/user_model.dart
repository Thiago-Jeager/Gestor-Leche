class UserModel {
  final int? id;
  final String nombre;
  final String apellido;

  UserModel({this.id, required this.nombre, required this.apellido});

  // Convertir un UserModel a un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
    };
  }

  // Crear un UserModel desde un Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      nombre: map['nombre'],
      apellido: map['apellido'],
    );
  }
}
