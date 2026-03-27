import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Scanned.dart';

class OpenFoodFactsService {
  Future<ScannedProduct?> fetchProduct(String barcode) async {
    final uri = Uri.parse(
      'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['status'] != 1) return null;

    final product = json['product'] as Map<String, dynamic>?;
    if (product == null) return null;

    final name =
        (product['product_name'] as String?)?.trim() ??
        (product['generic_name'] as String?)?.trim() ??
        'Unknown Product';
    final brand = (product['brands'] as String?)?.trim() ?? '';
    final categories = (product['categories'] as String?)?.trim() ?? '';
    final imageUrl =
        (product['image_front_small_url'] as String?)?.trim() ?? '';

    // Extract ingredients
    final ingredients = (product['ingredients_text'] as String?)?.trim() ?? '';

    // Extract nutrition facts
    final nutriments = product['nutriments'] as Map<String, dynamic>?;
    String nutritionFacts = '';
    if (nutriments != null) {
      final facts = <String>[];
      if (nutriments['energy-kcal_100g'] != null) {
        facts.add('Energy: ${nutriments['energy-kcal_100g']} kcal/100g');
      }
      if (nutriments['fat_100g'] != null) {
        facts.add('Fat: ${nutriments['fat_100g']}g/100g');
      }
      if (nutriments['saturated-fat_100g'] != null) {
        facts.add('Saturated Fat: ${nutriments['saturated-fat_100g']}g/100g');
      }
      if (nutriments['carbohydrates_100g'] != null) {
        facts.add('Carbohydrates: ${nutriments['carbohydrates_100g']}g/100g');
      }
      if (nutriments['sugars_100g'] != null) {
        facts.add('Sugars: ${nutriments['sugars_100g']}g/100g');
      }
      if (nutriments['fiber_100g'] != null) {
        facts.add('Fiber: ${nutriments['fiber_100g']}g/100g');
      }
      if (nutriments['proteins_100g'] != null) {
        facts.add('Proteins: ${nutriments['proteins_100g']}g/100g');
      }
      if (nutriments['salt_100g'] != null) {
        facts.add('Salt: ${nutriments['salt_100g']}g/100g');
      }
      nutritionFacts = facts.join('\n');
    }

    return ScannedProduct(
      barcode: barcode,
      name: name,
      brand: brand,
      categories: categories,
      imageUrl: imageUrl,
      scannedAt: DateTime.now().toIso8601String(),
      ingredients: ingredients,
      nutritionFacts: nutritionFacts,
    );
  }
}
