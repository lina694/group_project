/// Model class representing a purchase offer.
class PurchaseOffer {
  /// Primary key (autoincremented).
  final int? id;

  /// ID of the customer making the offer (must match `customers.id`).
  final int customerId;

  /// ID of the item being purchased (car or boat).
  final int itemId;

  /// Type of the item: 'car' or 'boat'.
  final String itemType;

  /// Price offered by the customer.
  final double price;

  /// Date of the offer, stored as a string (e.g. '2025-11-28').
  final String offerDate;

  /// Status of the offer: e.g. 'accepted', 'rejected', 'pending'.
  final String status;

  /// Constructor.
  PurchaseOffer({
    this.id,
    required this.customerId,
    required this.itemId,
    required this.itemType,
    required this.price,
    required this.offerDate,
    required this.status,
  });

  /// Creates a [PurchaseOffer] from a map returned by SQLite.
  factory PurchaseOffer.fromMap(Map<String, dynamic> map) {
    return PurchaseOffer(
      id: map['id'] as int?,
      customerId: map['customer_id'] as int,
      itemId: map['item_id'] as int,
      itemType: map['item_type'] as String,
      price: (map['price'] as num).toDouble(),
      offerDate: map['offer_date'] as String,
      status: map['status'] as String,
    );
  }

  /// Converts this [PurchaseOffer] to a map for insertion into SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'item_id': itemId,
      'item_type': itemType,
      'price': price,
      'offer_date': offerDate,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'PurchaseOffer{id: $id, customerId: $customerId, itemId: $itemId, '
        'itemType: $itemType, price: $price, offerDate: $offerDate, status: $status}';
  }
}
