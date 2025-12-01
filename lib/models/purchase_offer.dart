class PurchaseOffer {
  final int? id;
  final int customerId;
  final int itemId;       // car/boat ID
  final String itemType;  // 'car' or 'boat'
  final double price;
  final String offerDate; // 'YYYY-MM-DD'
  final String status;    // 'accepted' / 'rejected' / 'pending'

  PurchaseOffer({
    this.id,
    required this.customerId,
    required this.itemId,
    required this.itemType,
    required this.price,
    required this.offerDate,
    required this.status,
  });

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

  @override
  String toString() {
    return 'Customer #$customerId – Item #$itemId '
        '(\$${price.toStringAsFixed(2)}, $status)';
  }
}
