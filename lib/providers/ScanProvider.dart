import 'package:flutter/material.dart';
import '../database/Databaseinvent.dart';
import '../models/Scanned.dart';

class ScanProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<ScannedProduct> _scans = [];

  List<ScannedProduct> get scans => _scans;

  Future<void> loadScans({String? date}) async {
    final data = await _dbHelper.getScannedProducts(date: date);
    _scans = data.map((map) => ScannedProduct.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addScan(ScannedProduct product) async {
    await _dbHelper.insertScannedProduct(product.toMap());
    await loadScans();
  }

  Future<void> deleteScan(int id) async {
    await _dbHelper.deleteScannedProduct(id);
    await loadScans();
  }
}
