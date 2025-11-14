import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/car.dart';

/// Database helper class for managing SQLite database operations.
/// Implements singleton pattern to ensure only one database instance.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  /// Factory constructor returns the singleton instance.
  factory DatabaseHelper() => _instance;

  /// Private constructor for singleton pattern.
  DatabaseHelper._internal();

  /// Gets the database instance, creating it if necessary.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database and creates tables.
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'group_project.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Creates the database tables.
  /// Called when the database is created for the first time.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cars(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        year INTEGER NOT NULL,
        make TEXT NOT NULL,
        model TEXT NOT NULL,
        price REAL NOT NULL,
        kilometers INTEGER NOT NULL
      )
    ''');
  }

  /// Inserts a new car into the database.
  ///
  /// [car] - The car object to insert
  /// Returns the ID of the newly inserted car.
  Future<int> insertCar(Car car) async {
    final db = await database;
    print('DEBUG: Inserting car: ${car.toString()}');
    final id = await db.insert('cars', car.toMap());
    print('DEBUG: Car inserted with ID: $id');
    return id;
  }

  /// Retrieves all cars from the database.
  ///
  /// Returns a list of all Car objects.
  Future<List<Car>> getAllCars() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cars');
    print('DEBUG: Found ${maps.length} cars in database');

    return List.generate(maps.length, (i) {
      return Car.fromMap(maps[i]);
    });
  }

  /// Updates an existing car in the database.
  ///
  /// [car] - The car object with updated information
  /// Returns the number of rows affected.
  Future<int> updateCar(Car car) async {
    final db = await database;
    return await db.update(
      'cars',
      car.toMap(),
      where: 'id = ?',
      whereArgs: [car.id],
    );
  }

  /// Deletes a car from the database.
  ///
  /// [id] - The ID of the car to delete
  /// Returns the number of rows affected.
  Future<int> deleteCar(int id) async {
    final db = await database;
    return await db.delete(
      'cars',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Closes the database connection.
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}