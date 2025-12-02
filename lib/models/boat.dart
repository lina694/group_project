/// The Boat model represents a single boat listed for sale.
/// It contains basic attributes such as year, length, power type,
/// price, and address.
///
/// This model is stored in the local SQLite database.
class Boat {
  /// Unique identifier for the boat record in the database.
  int? id;

  /// The year the boat was built.
  String year;

  /// The physical length of the boat.
  String length;

  /// The type of power the boat uses (`sail` or `motor`).
  String powerType;

  /// The selling price of the boat.
  String price;

  /// The address where the boat is located.
  String address;

  /// Creates a new [Boat] instance.
  Boat({
    this.id,
    required this.year,
    required this.length,
    required this.powerType,
    required this.price,
    required this.address,
  });

  /// Converts a Boat object into a Map for database storage.
  Map<String, dynamic> toMap() => {
    'id': id,
    'year': year,
    'length': length,
    'powerType': powerType,
    'price': price,
    'address': address,
  };

  /// Factory constructor to create a [Boat] from a database record.
  static Boat fromMap(Map<String, dynamic> map) => Boat(
    id: map['id'],
    year: map['year'],
    length: map['length'],
    powerType: map['powerType'],
    price: map['price'],
    address: map['address'],
  );
}
