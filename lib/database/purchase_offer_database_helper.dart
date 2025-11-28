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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'group_project.db');

    final db = await openDatabase(
      path,
      version: 1,
      // We don't define onCreate here because another helper (Car) may already
      // have created the DB. Instead, we ensure the table exists after open.
    );

    // Make sure our table exists even if the DB was created earlier.
    await _createTableIfNotExists(db);

    return db;
  }

  /// Creates the `purchase_offers` table if it does not exist yet.
  Future<void> _createTableIfNotExists(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS purchase_offers (
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
    final id = await db.insert('purchase_offers', offer.toMap());
    return id;
  }

  /// Retrieves all purchase offers from the database.
  ///
  /// Returns a list of [PurchaseOffer].
  Future<List<PurchaseOffer>> getAllOffers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('purchase_offers', orderBy: 'id DESC');

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
      'purchase_offers',
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
      'purchase_offers',
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
