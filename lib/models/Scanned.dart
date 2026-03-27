class ScannedProduct {
  int? id;
  String barcode;
  String name;
  String brand;
  String categories;
  String imageUrl;
  String scannedAt;
  String ingredients;
  String nutritionFacts;

  ScannedProduct({
    this.id,
    required this.barcode,
    required this.name,
    required this.brand,
    required this.categories,
    required this.imageUrl,
    required this.scannedAt,
    this.ingredients = '',
    this.nutritionFacts = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'brand': brand,
      'categories': categories,
      'imageUrl': imageUrl,
      'scannedAt': scannedAt,
      'ingredients': ingredients,
      'nutritionFacts': nutritionFacts,
    };
  }

  factory ScannedProduct.fromMap(Map<String, dynamic> map) {
    return ScannedProduct(
      id: map['id'] as int?,
      barcode: map['barcode'] ?? '',
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      categories: map['categories'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      scannedAt: map['scannedAt'] ?? '',
      ingredients: map['ingredients'] ?? '',
      nutritionFacts: map['nutritionFacts'] ?? '',
    );
  }
}
