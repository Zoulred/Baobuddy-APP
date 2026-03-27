class ShoppingItem {
  int? id;
  String name;
  String category;
  int quantity;
  bool isChecked;
  double? price;
  String? unit;

  ShoppingItem({
    this.id,
    required this.name,
    required this.category,
    required this.quantity,
    this.isChecked = false,
    this.price,
    this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'isChecked': isChecked ? 1 : 0,
      'price': price,
      'unit': unit,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'],
      name: map['name'] ?? '',
      category: map['category'] ?? 'Other Grocery',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      isChecked: map['isChecked'] == 1,
      price: (map['price'] as num?)?.toDouble(),
      unit: map['unit'],
    );
  }
}
