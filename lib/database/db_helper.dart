import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/boat.dart';

/// Database helper class managing CRUD operations.
class DBHelper {
  static Database? _db;

  /// Initialize database if it does not exist.
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "boats.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE boats (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            year TEXT,
            length TEXT,
            powerType TEXT,
            price TEXT,
            address TEXT
          )
        """);
      },
    );
  }

  /// Insert a boat
  static Future<int> insertBoat(Boat boat) async {
    final db = await database;
    return db.insert("boats", boat.toMap());
  }

  /// Get all boats
  static Future<List<Boat>> getBoats() async {
    final db = await database;
    final result = await db.query("boats");
    return result.map((e) => Boat.fromMap(e)).toList();
  }

  /// Update a boat
  static Future<int> updateBoat(Boat boat) async {
    final db = await database;
    return db.update("boats", boat.toMap(),
        where: "id = ?", whereArgs: [boat.id]);
  }

  /// Delete a boat
  static Future<int> deleteBoat(int id) async {
    final db = await database;
    return db.delete("boats", where: "id = ?", whereArgs: [id]);
  }
}
