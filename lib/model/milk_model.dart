class MilkModel {
  final int? id;
  final String fecha;
  final double litros;
  final double precio;
  final double total;
  final int userId; // Nuevo campo para asociar con el usuario

  MilkModel({
    this.id,
    required this.fecha,
    required this.litros,
    required this.precio,
    required this.total,
    required this.userId,
  });

  // Convert a MilkModel into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'litros': litros,
      'precio': precio,
      'total': total,
      'userId': userId,
    };
  }

  // Create a MilkModel from a Map.
  factory MilkModel.fromMap(Map<String, dynamic> map) {
    return MilkModel(
      id: map['id'],
      fecha: map['fecha'],
      litros: map['litros'],
      precio: map['precio'],
      total: map['total'],
      userId: map['userId'], // Asociar con el usuario
    );
  }

  @override
  String toString() {
    return 'Litros: $litros, Precio: $precio, Total: $total, ID: $id, Fecha: $fecha';
  }
}

class Event {
  final String title;

  const Event({required this.title});

  @override
  String toString() => title;
}
