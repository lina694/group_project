/// Model class representing a car for sale.
/// Contains all information about a car listing including year, make, model, price, and mileage.
class Car {
  /// Unique identifier for the car (database primary key)
  int? id;

  /// Year of manufacture
  final int year;

  /// Car manufacturer (e.g., Toyota, Tesla, Volkswagen)
  final String make;

  /// Car model (e.g., Corolla, Model 3, Jetta)
  final String model;

  /// Sale price in dollars
  final double price;

  /// Total kilometers/kilometres driven
  final int kilometers;

  /// Creates a new car instance.
  ///
  /// [year] - Year of manufacture
  /// [make] - Car manufacturer
  /// [model] - Car model
  /// [price] - Sale price
  /// [kilometers] - Kilometers driven
  /// [id] - Optional database ID
  Car({
    this.id,
    required this.year,
    required this.make,
    required this.model,
    required this.price,
    required this.kilometers,
  });

  /// Converts a Car object to a Map for database storage.
  ///
  /// Returns a Map with column names as keys.
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

  /// Creates a Car object from a database Map.
  ///
  /// [map] - Map containing car data from database
  /// Returns a new Car instance.
  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] as int?,
      year: map['year'] as int,
      make: map['make'] as String,
      model: map['model'] as String,
      price: map['price'] as double,
      kilometers: map['kilometers'] as int,
    );
  }

  /// Returns a formatted string representation of the car.
  /// Format: "YYYY Make Model"
  @override
  String toString() {
    return '$year $make $model';
  }

  /// Creates a copy of this car with optional field updates.
  ///
  /// Useful for updating car information while keeping other fields unchanged.
  Car copyWith({
    int? id,
    int? year,
    String? make,
    String? model,
    double? price,
    int? kilometers,
  }) {
    return Car(
      id: id ?? this.id,
      year: year ?? this.year,
      make: make ?? this.make,
      model: model ?? this.model,
      price: price ?? this.price,
      kilometers: kilometers ?? this.kilometers,
    );
  }
}