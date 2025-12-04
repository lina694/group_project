import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/boat.dart';

/// Database helper for the Boats module.
class BoatDatabase {
  static final BoatDatabase instance = BoatDatabase._init();
  static Database? _database;

  BoatDatabase._init();

  /// Returns the database instance.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('boats.db');
    return _database!;
  }

  /// Initializes the database.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Creates the table.
  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE boats (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  length REAL NOT NULL,
  price REAL NOT NULL,
  powerType TEXT NOT NULL
)
''');
  }

  /// Inserts a boat.
  Future<int> create(Boat boat) async {
    final db = await instance.database;
    return await db.insert('boats', boat.toMap());
  }

  /// Reads all boats.
  Future<List<Boat>> readAllBoats() async {
    final db = await instance.database;
    final result = await db.query('boats');
    return result.map((json) => Boat.fromMap(json)).toList();
  }

  /// Updates a boat.
  Future<int> update(Boat boat) async {
    final db = await instance.database;
    return db.update(
      'boats',
      boat.toMap(),
      where: 'id = ?',
      whereArgs: [boat.id],
    );
  }

  /// Deletes a boat.
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'boats',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}