import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/purchase_offer.dart';

/// Database helper for the Purchase Offers module.
class PurchaseDatabase {
  static final PurchaseDatabase instance = PurchaseDatabase._init();
  static Database? _database;

  PurchaseDatabase._init();

  /// Returns the database instance.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('offers.db');
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
CREATE TABLE offers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  buyerName TEXT NOT NULL,
  amount REAL NOT NULL,
  date TEXT NOT NULL,
  status TEXT NOT NULL
)
''');
  }

  /// Inserts an offer.
  Future<int> create(PurchaseOffer offer) async {
    final db = await instance.database;
    return await db.insert('offers', offer.toMap());
  }

  /// Reads all offers.
  Future<List<PurchaseOffer>> readAllOffers() async {
    final db = await instance.database;
    final result = await db.query('offers');
    return result.map((json) => PurchaseOffer.fromMap(json)).toList();
  }

  /// Updates an offer.
  Future<int> update(PurchaseOffer offer) async {
    final db = await instance.database;
    return db.update(
      'offers',
      offer.toMap(),
      where: 'id = ?',
      whereArgs: [offer.id],
    );
  }

  /// Deletes an offer.
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'offers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}