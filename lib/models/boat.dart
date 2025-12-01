/// Boat model representing a boat listing.
class Boat {
  int? id;
  String year;
  String length;
  String powerType;
  String price;
  String address;

  Boat({
    this.id,
    required this.year,
    required this.length,
    required this.powerType,
    required this.price,
    required this.address,
  });

  /// Convert a Boat to a Map for database insertion.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'length': length,
      'powerType': powerType,
      'price': price,
      'address': address,
    };
  }

  /// Create a Boat object from a Map.
  static Boat fromMap(Map<String, dynamic> map) {
    return Boat(
      id: map['id'],
      year: map['year'],
      length: map['length'],
      powerType: map['powerType'],
      price: map['price'],
      address: map['address'],
    );
  }
}
