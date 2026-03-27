class Purchase {
  int? id;
  String itemName;
  String category;
  double quantity;
  double price;
  String date;
  String? receiptImagePath;
  String source;
  int? shoppingItemId;
  
  // Additional fields for Bills Payment
  String? billType;
  String? accountNumber;
  String? billingPeriod;
  String? dueDate;
  String? paymentMethod;
  
  // Additional fields for Transportation
  String? transportType;
  String? origin;
  String? destination;
  String? notes;

  Purchase({
    this.id,
    required this.itemName,
    required this.category,
    required this.quantity,
    required this.price,
    required this.date,
    this.receiptImagePath,
    this.source = 'manual',
    this.shoppingItemId,
    // Bills Payment fields
    this.billType,
    this.accountNumber,
    this.billingPeriod,
    this.dueDate,
    this.paymentMethod,
    // Transportation fields
    this.transportType,
    this.origin,
    this.destination,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'category': category,
      'quantity': quantity,
      'price': price,
      'date': date,
      'receiptImagePath': receiptImagePath,
      'source': source,
      'shoppingItemId': shoppingItemId,
      // Bills Payment fields
      'billType': billType,
      'accountNumber': accountNumber,
      'billingPeriod': billingPeriod,
      'dueDate': dueDate,
      'paymentMethod': paymentMethod,
      // Transportation fields
      'transportType': transportType,
      'origin': origin,
      'destination': destination,
      'notes': notes,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      itemName: map['itemName'] ?? '',
      category: map['category'] ?? '',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 1.0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      date: map['date'] ?? DateTime.now().toIso8601String(),
      receiptImagePath: map['receiptImagePath'],
      source: map['source'] ?? 'manual',
      shoppingItemId: map['shoppingItemId'],
      // Bills Payment fields
      billType: map['billType'],
      accountNumber: map['accountNumber'],
      billingPeriod: map['billingPeriod'],
      dueDate: map['dueDate'],
      paymentMethod: map['paymentMethod'],
      // Transportation fields
      transportType: map['transportType'],
      origin: map['origin'],
      destination: map['destination'],
      notes: map['notes'],
    );
  }
}
