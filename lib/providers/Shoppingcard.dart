import 'package:flutter/material.dart';
import '../database/Databaseinvent.dart';
import '../models/ShoppingItem.dart';
import '../models/purchase.dart';
import 'PurchaseProducts.dart';

class ShoppingListProvider with ChangeNotifier {
  List<ShoppingItem> _items = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<ShoppingItem> get items => _items;

  Future<void> loadItems() async {
    final data = await _dbHelper.getShoppingItems();
    _items = data.map((item) => ShoppingItem.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> addItem(ShoppingItem item) async {
    await _dbHelper.insertShoppingItem(item.toMap());
    await loadItems();
  }

  Future<void> updateItem(ShoppingItem item) async {
    if (item.id != null) {
      await _dbHelper.updateShoppingItem(item.id!, item.toMap());
      await loadItems();
    }
  }

  Future<void> deleteItem(int id, PurchaseProvider purchaseProvider) async {
    // Remove linked purchase if item was checked
    await purchaseProvider.deletePurchaseByShoppingItemId(id);
    await _dbHelper.deleteShoppingItem(id);
    await loadItems();
  }

  /// Called when user taps checkbox on an already-checked item → uncheck & remove purchase
  Future<void> toggleChecked(int id, PurchaseProvider purchaseProvider) async {
    final item = _items.firstWhere((i) => i.id == id);
    if (item.isChecked) {
      // Uncheck: remove the linked purchase from history
      await purchaseProvider.deletePurchaseByShoppingItemId(id);
      item.isChecked = false;
      item.price = null;
      item.unit = null;
      await updateItem(item);
    }
  }

  /// Called when user confirms price → mark done & insert purchase into history
  Future<void> toggleCheckedWithPrice(
    int id, {
    required double price,
    required String unit,
    required PurchaseProvider purchaseProvider,
  }) async {
    final item = _items.firstWhere((i) => i.id == id);
    item.isChecked = true;
    item.price = price;
    item.unit = unit;
    await updateItem(item);

    // Insert into purchases so it shows in history & affects budget
    await purchaseProvider.addPurchase(
      Purchase(
        itemName: item.name,
        category: item.category,
        quantity: item.quantity.toDouble(),
        price: price,
        date: DateTime.now().toIso8601String(),
        source: 'shopping_list',
        shoppingItemId: id,
      ),
    );

    // Remove unit from item when marked done (avoid kg/unit carryover)
    item.unit = null;
    item.price = null;
    await updateItem(item);

    // Automatically remove the item from shopping list after marking as done
    await _dbHelper.deleteShoppingItem(id);
    await loadItems();
  }
}
