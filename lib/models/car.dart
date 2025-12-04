/// Represents a car for sale.
class Car {
  int? id;
  int year;
  String make;
  String model;
  double price;
  int kilometers;

  Car({
    this.id,
    required this.year,
    required this.make,
    required this.model,
    required this.price,
    required this.kilometers,
  });

  /// Converts a [Car] object into a Map for the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'make': make,
      'model': model,
      'price': price,
      'kilometers': kilometers,
    };
  }

  /// Creates a [Car] object from a database Map.
  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      year: map['year'],
      make: map['make'],
      model: map['model'],
      price: map['price'],
      kilometers: map['kilometers'],
    );
  }

  @override
  String toString() {
    return '$year $make $model';
  }
}