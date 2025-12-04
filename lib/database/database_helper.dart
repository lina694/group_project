import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/car.dart';

/// Helper class to manage the SQLite database for the Cars feature.
class DatabaseHelper {
  // Singleton pattern to ensure only one instance of the database exists.
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  /// Returns the database instance, creating it if it doesn't exist.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database and creates the table.
  Future<Database> _initDatabase() async {
    // Get the default database path
    String path = join(await getDatabasesPath(), 'cars_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Creates the 'cars' table.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cars(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        year INTEGER,
        make TEXT,
        model TEXT,
        price REAL,
        kilometers INTEGER
      )
    ''');
  }

  // ---------------------------------------------------------------------------
  // CRUD Operations (Create, Read, Update, Delete)
  // ---------------------------------------------------------------------------

  /// Inserts a new [Car] into the database.
  Future<int> insertCar(Car car) async {
    final db = await database;
    return await db.insert(
      'cars',
      car.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves all cars from the database.
  Future<List<Car>> getAllCars() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cars');

    return List.generate(maps.length, (i) {
      return Car.fromMap(maps[i]);
    });
  }

  /// Updates an existing [Car] in the database.
  Future<int> updateCar(Car car) async {
    final db = await database;
    return await db.update(
      'cars',
      car.toMap(),
      where: 'id = ?',
      whereArgs: [car.id],
    );
  }

  /// Deletes a car from the database by its [id].
  Future<int> deleteCar(int id) async {
    final db = await database;
    return await db.delete(
      'cars',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}