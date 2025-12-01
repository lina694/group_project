import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/boat.dart';

/// A helper class responsible for managing all database operations.
///
/// This class handles:
/// - Database initialization
/// - Creating the `boats` table
/// - Inserting boats
/// - Querying boats
/// - Updating boats
/// - Deleting boats
///
/// All operations use SQLite via the `sqflite` package.
class DBHelper {
  /// Singleton database instance.
  static Database? _db;

  /// Returns the database instance, creating it if necessary.
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  /// Initializes the SQLite database and creates the boats table.
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

  /// Inserts a new [boat] into the boats table.
  ///
  /// Returns the generated ID of the inserted row.
  static Future<int> insertBoat(Boat boat) async {
    final db = await database;
    return db.insert("boats", boat.toMap());
  }

  /// Retrieves all boats stored in the database.
  ///
  /// Returns a list of [Boat] objects.
  static Future<List<Boat>> getBoats() async {
    final db = await database;
    final result = await db.query("boats");
    return result.map((e) => Boat.fromMap(e)).toList();
  }

  /// Updates an existing [boat] record in the database.
  ///
  /// Returns the number of affected rows.
  static Future<int> updateBoat(Boat boat) async {
    final db = await database;
    return db.update(
      "boats",
      boat.toMap(),
      where: "id = ?",
      whereArgs: [boat.id],
    );
  }

  /// Deletes a boat record from the database by its [id].
  ///
  /// Returns the number of affected rows.
  static Future<int> deleteBoat(int id) async {
    final db = await database;
    return db.delete(
      "boats",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
