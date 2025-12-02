import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer.dart';

/// A singleton class to manage the application's customer database using Sqflite.
class CustomerDatabase {
  /// The static singleton instance of the [CustomerDatabase].
  static final CustomerDatabase instance = CustomerDatabase._init();

  /// The private instance of the Sqflite [Database].
  static Database? _database;

  /// Private constructor for the singleton pattern.
  CustomerDatabase._init();

  /// Public getter for the database.
  ///
  /// Lazily initializes the database if it hasn't been opened yet.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('customers.db');
    return _database!;
  }

  /// Initializes the database by opening it at the given [filePath].
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Creates the database tables.
  ///
  /// This method is called by Sqflite only when the database is first created.
  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE customers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  firstName TEXT NOT NULL,
  lastName TEXT NOT NULL,
  address TEXT NOT NULL,
  dob TEXT NOT NULL,
  licenseNumber TEXT NOT NULL
)
''');
  }

  /// Inserts a new [Customer] into the database.
  ///
  /// Returns the customer with the new [id] assigned by the database.
  Future<Customer> create(Customer customer) async {
    final db = await instance.database;
    final id = await db.insert('customers', customer.toMap());
    // Attach the auto-generated ID to the customer object and return it.
    return customer..id = id;
  }

  /// Reads a single [Customer] from the database by its [id].
  Future<Customer> readCustomer(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'customers',
      columns: ['id', 'firstName', 'lastName', 'address', 'dob', 'licenseNumber'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  /// Reads all [Customer] records from the database.
  Future<List<Customer>> readAllCustomers() async {
    final db = await instance.database;
    final result = await db.query('customers');
    return result.map((json) => Customer.fromMap(json)).toList();
  }

  /// Updates an existing [Customer] in the database.
  Future<int> update(Customer customer) async {
    final db = await instance.database;
    return db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  /// Deletes a [Customer] from the database by its [id].
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Closes the database connection.
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}