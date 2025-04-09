import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  static Database? _db;

  DBHelper._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'registro_leche.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE leche (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT NOT NULL,
        litros REAL NOT NULL,
        precio REAL NOT NULL,
        total REAL NOT NULL
      )
    ''');
  }

  // Método para insertar registro
  Future<int> insertarRegistro(
      String fecha, double litros, double precio) async {
    final dbClient = await db;
    return await dbClient.insert(
      'leche',
      {
        'fecha': fecha,
        'litros': double.parse(litros.toStringAsFixed(2)),
        'precio': double.parse(precio.toStringAsFixed(2)),
        'total': double.parse((litros * precio).toStringAsFixed(2)),
      },
    );
  }

  // Método para obtener todos los registros
  Future<List<Map<String, dynamic>>> obtenerRegistros() async {
    final dbClient = await db;
    return await dbClient.query('leche', orderBy: 'fecha ASC');
  }

  // Método para actualizar un registro
  Future<int> actualizarRegistro(
      int id, String fecha, double litros, double precio) async {
    final dbClient = await db;
    return await dbClient.update(
      'leche',
      {
        'fecha': fecha,
        'litros': double.parse(litros.toStringAsFixed(2)),
        'precio': double.parse(precio.toStringAsFixed(2)),
        'total': double.parse((litros * precio).toStringAsFixed(2)),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para borrar un registro
  Future<int> borrarRegistro(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'leche',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para obtener registros por fecha
  Future<List<Map<String, dynamic>>> obtenerRegistrosPorFecha(
      String fecha) async {
    final dbClient = await db;
    return await dbClient.query(
      'leche',
      where: 'fecha = ?',
      whereArgs: [fecha],
      orderBy: 'id DESC',
    );
  }
}
