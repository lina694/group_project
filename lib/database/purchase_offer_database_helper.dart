
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/purchase_offer.dart';


/// Database helper for managing purchase offer records.
///
/// This class uses the **same SQLite file** as the rest of the group:
/// `group_project.db`.
///
/// It:
///  * Ensures the `purchase_offers` table exists
///  * Provides CRUD operations for [PurchaseOffer]
///  * Uses a singleton pattern so only one instance is used.
class PurchaseOfferDatabaseHelper {
  /// Singleton instance.
  static final PurchaseOfferDatabaseHelper _instance =
  PurchaseOfferDatabaseHelper._internal();

  /// Private constructor.
  PurchaseOfferDatabaseHelper._internal();

  /// Factory constructor to access the singleton.
  factory PurchaseOfferDatabaseHelper() => _instance;

  static Database? _database;

  /// Gets the database instance, creating it if needed.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database.
  ///
  /// Uses the same path and name as the Car helper: `group_project.db`.
  /// Also ensures that the `purchase_offers` table exists.
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'group_project.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Creates the `purchase_offers` table if it does not exist yet.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS purchase_offer (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        item_id INTEGER NOT NULL,
        item_type TEXT NOT NULL,      -- 'car' or 'boat'
        price REAL NOT NULL,
        offer_date TEXT NOT NULL,     -- e.g. '2025-11-28'
        status TEXT NOT NULL          -- 'accepted', 'rejected', 'pending'
      )
    ''');
  }

  // ---------------------------------------------------------------------------
  // CRUD OPERATIONS
  // ---------------------------------------------------------------------------

  /// Inserts a new [PurchaseOffer] into the database.
  ///
  /// Returns the ID of the newly inserted row.
  Future<int> insertOffer(PurchaseOffer offer) async {
    final db = await database;
    final id = await db.insert('purchase_offer', offer.toMap());
    return id;
  }

  /// Retrieves all purchase offers from the database.
  ///
  /// Returns a list of [PurchaseOffer].
  Future<List<PurchaseOffer>> getAllOffers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('purchase_offer', orderBy: 'id DESC');

    return maps.map((map) => PurchaseOffer.fromMap(map)).toList();
  }

  /// Updates an existing [PurchaseOffer] in the database.
  ///
  /// Returns the number of affected rows.
  Future<int> updateOffer(PurchaseOffer offer) async {
    if (offer.id == null) {
      throw ArgumentError('Cannot update a purchase offer without an ID.');
    }

    final db = await database;
    return db.update(
      'purchase_offer',
      offer.toMap(),
      where: 'id = ?',
      whereArgs: [offer.id],
    );
  }

  /// Deletes a purchase offer by its [id].
  ///
  /// Returns the number of affected rows.
  Future<int> deleteOffer(int id) async {
    final db = await database;
    return db.delete(
      'purchase_offer',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Closes the database connection.
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
