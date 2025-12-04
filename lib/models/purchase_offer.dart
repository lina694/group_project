/// Represents an offer to purchase an item.
class PurchaseOffer {
  /// Unique ID for the offer.
  int? id;

  /// The name of the buyer.
  String buyerName;

  /// The amount offered.
  double amount;

  /// The date of the offer.
  String date;

  /// The status (Pending, Accepted, Rejected).
  String status;

  /// Creates a [PurchaseOffer] instance.
  PurchaseOffer({
    this.id,
    required this.buyerName,
    required this.amount,
    required this.date,
    required this.status,
  });

  /// Converts an [PurchaseOffer] into a Map for the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyerName': buyerName,
      'amount': amount,
      'date': date,
      'status': status,
    };
  }

  /// Creates a [PurchaseOffer] from a Map.
  factory PurchaseOffer.fromMap(Map<String, dynamic> map) {
    return PurchaseOffer(
      id: map['id'],
      buyerName: map['buyerName'],
      amount: map['amount'],
      date: map['date'],
      status: map['status'],
    );
  }
}