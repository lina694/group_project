/// Represents a boat for sale.
class Boat {
  /// Unique ID for the boat.
  int? id;

  /// The name or make of the boat.
  String name;

  /// The length of the boat in feet.
  double length;

  /// The price of the boat.
  double price;

  /// The type of power (Sail, Motor, etc.).
  String powerType;

  /// Creates a [Boat] instance.
  Boat({
    this.id,
    required this.name,
    required this.length,
    required this.price,
    required this.powerType,
  });

  /// Converts a [Boat] into a Map for the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'length': length,
      'price': price,
      'powerType': powerType,
    };
  }

  /// Creates a [Boat] from a Map.
  factory Boat.fromMap(Map<String, dynamic> map) {
    return Boat(
      id: map['id'],
      name: map['name'],
      length: map['length'],
      price: map['price'],
      powerType: map['powerType'],
    );
  }
}