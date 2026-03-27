import 'package:flutter/material.dart';
import '../database/Databaseinvent.dart';
import '../models/purchase.dart';

class PurchaseProvider with ChangeNotifier {
  List<Purchase> _purchases = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Purchase> get purchases => _purchases;

  Future<void> loadPurchases() async {
    final data = await _dbHelper.getPurchases();
    _purchases = data.map((purchase) => Purchase.fromMap(purchase)).toList();
    notifyListeners();
  }

  Future<void> addPurchase(Purchase purchase) async {
    await _dbHelper.insertPurchase(purchase.toMap());
    await loadPurchases();
  }

  Future<void> deletePurchase(int id) async {
    await _dbHelper.deletePurchase(id);
    await loadPurchases();
  }

  Future<void> deletePurchaseByShoppingItemId(int shoppingItemId) async {
    final id = await _dbHelper.getPurchaseIdByShoppingItemId(shoppingItemId);
    if (id != null) await deletePurchase(id);
  }

  Future<double> getTotalSpending(String period) async {
    return await _dbHelper.getTotalSpending(period);
  }

  Map<String, List<Purchase>> getExpensesByCategory() {
    final Map<String, List<Purchase>> groupedExpenses = {};

    for (var purchase in _purchases) {
      if (!groupedExpenses.containsKey(purchase.category)) {
        groupedExpenses[purchase.category] = [];
      }
      groupedExpenses[purchase.category]!.add(purchase);
    }

    return groupedExpenses;
  }

  Map<String, double> calculateCategoryPercentages() {
    final Map<String, double> percentages = {};
    final groupedByCategory = getExpensesByCategory();

    double totalSpending = 0;
    for (var purchases in groupedByCategory.values) {
      for (var purchase in purchases) {
        totalSpending += purchase.price;
      }
    }

    if (totalSpending == 0) return {};

    for (var category in groupedByCategory.keys) {
      double categoryTotal = 0;
      for (var purchase in groupedByCategory[category]!) {
        categoryTotal += purchase.price;
      }
      percentages[category] = (categoryTotal / totalSpending) * 100;
    }

    return percentages;
  }

  Map<String, double> getTotalByCategory() {
    final Map<String, double> totals = {};
    final groupedByCategory = getExpensesByCategory();

    for (var category in groupedByCategory.keys) {
      double total = 0;
      for (var purchase in groupedByCategory[category]!) {
        total += purchase.price;
      }
      totals[category] = total;
    }

    return totals;
  }

  List<Purchase> filterByDateRange(DateTime startDate, DateTime endDate) {
    return _purchases.where((purchase) {
      try {
        final purchaseDate = DateTime.parse(purchase.date);
        return purchaseDate.isAfter(
              startDate.subtract(const Duration(days: 1)),
            ) &&
            purchaseDate.isBefore(endDate.add(const Duration(days: 1)));
      } catch (e) {
        return false;
      }
    }).toList();
  }

  Map<String, double> getAggregatedByDate(String period) {
    final Map<String, double> aggregated = {};

    for (var purchase in _purchases) {
      try {
        final purchaseDate = DateTime.parse(purchase.date);
        String key;

        if (period == 'daily') {
          key = purchaseDate.toString().split(' ')[0];
        } else if (period == 'weekly') {
          final dayOfWeek = purchaseDate.weekday;
          final startOfWeek = purchaseDate.subtract(
            Duration(days: dayOfWeek - 1),
          );
          key = startOfWeek.toString().split(' ')[0];
        } else if (period == 'monthly') {
          key =
              '${purchaseDate.year}-${purchaseDate.month.toString().padLeft(2, '0')}';
        } else {
          key = purchaseDate.toString().split(' ')[0];
        }

        aggregated[key] = (aggregated[key] ?? 0) + purchase.price;
      } catch (e) {
        continue;
      }
    }

    return aggregated;
  }

  Map<String, double> getAggregatedByDateRange(
    String period,
    DateTime startDate,
    DateTime endDate,
  ) {
    final filteredPurchases = filterByDateRange(startDate, endDate);
    final Map<String, double> aggregated = {};

    for (var purchase in filteredPurchases) {
      try {
        final purchaseDate = DateTime.parse(purchase.date);
        String key;

        if (period == 'daily') {
          key = purchaseDate.toString().split(' ')[0];
        } else if (period == 'weekly') {
          final dayOfWeek = purchaseDate.weekday;
          final startOfWeek = purchaseDate.subtract(
            Duration(days: dayOfWeek - 1),
          );
          key = startOfWeek.toString().split(' ')[0];
        } else if (period == 'monthly') {
          key =
              '${purchaseDate.year}-${purchaseDate.month.toString().padLeft(2, '0')}';
        } else {
          key = purchaseDate.toString().split(' ')[0];
        }

        aggregated[key] = (aggregated[key] ?? 0) + purchase.price;
      } catch (e) {
        continue;
      }
    }

    return aggregated;
  }
}
