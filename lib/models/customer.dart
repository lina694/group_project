/// Represents the data model for a Customer.
class Customer {
  /// The unique identifier for the customer.
  ///
  /// This is auto-incremented by the database and may be null
  /// if the object has not yet been saved.
  int? id;

  /// The customer's first name.
  String firstName;

  /// The customer's last name.
  String lastName;

  /// The customer's address.
  String address;

  /// The customer's date of birth (stored as a [String]).
  String dob;

  /// The customer's driver's license number.
  String licenseNumber;

  /// Creates a new [Customer] instance.
  Customer({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.dob,
    required this.licenseNumber,
  });

  /// Converts this [Customer] object into a [Map] for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'dob': dob,
      'licenseNumber': licenseNumber,
    };
  }

  /// Factory constructor to create a [Customer] from a [Map] (from database).
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      address: map['address'],
      dob: map['dob'],
      licenseNumber: map['licenseNumber'],
    );
  }

  /// Creates a copy of this [Customer] instance with optional new values.
  ///
  /// Useful for updating a customer's details without mutating the original object.
  Customer copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? address,
    String? dob,
    String? licenseNumber,
  }) {
    return Customer(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      dob: dob ?? this.dob,
      licenseNumber: licenseNumber ?? this.licenseNumber,
    );
  }
}