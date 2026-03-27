import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'baobuddy.db');
    final db = await openDatabase(
      path,
      version: 6,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    await _ensureColumns(db);
    return db;
  }

  Future<void> _ensureColumns(Database db) async {
    final siCols = (await db.rawQuery(
      'PRAGMA table_info(shopping_items)',
    )).map((r) => r['name'] as String).toSet();
    if (!siCols.contains('price')) {
      try {
        await db.execute('ALTER TABLE shopping_items ADD COLUMN price REAL');
      } catch (_) {}
    }
    if (!siCols.contains('unit')) {
      try {
        await db.execute('ALTER TABLE shopping_items ADD COLUMN unit TEXT');
      } catch (_) {}
    }

    final pCols = (await db.rawQuery(
      'PRAGMA table_info(purchases)',
    )).map((r) => r['name'] as String).toSet();
    if (!pCols.contains('source')) {
      try {
        await db.execute(
          "ALTER TABLE purchases ADD COLUMN source TEXT DEFAULT 'manual'",
        );
      } catch (_) {}
    }
    if (!pCols.contains('shoppingItemId')) {
      try {
        await db.execute(
          'ALTER TABLE purchases ADD COLUMN shoppingItemId INTEGER',
        );
      } catch (_) {}
    }
    final newPurchaseCols = {
      'billType': 'TEXT',
      'accountNumber': 'TEXT',
      'billingPeriod': 'TEXT',
      'dueDate': 'TEXT',
      'paymentMethod': 'TEXT',
      'transportType': 'TEXT',
      'origin': 'TEXT',
      'destination': 'TEXT',
      'notes': 'TEXT',
    };
    for (final entry in newPurchaseCols.entries) {
      if (!pCols.contains(entry.key)) {
        try {
          await db.execute('ALTER TABLE purchases ADD COLUMN ${entry.key} ${entry.value}');
        } catch (_) {}
      }
    }

    final spCols = (await db.rawQuery(
      'PRAGMA table_info(scanned_products)',
    )).map((r) => r['name'] as String).toSet();
    if (spCols.isNotEmpty) {
      // If table exists but missing new columns, add them
      if (!spCols.contains('ingredients') ||
          !spCols.contains('nutritionFacts')) {
        try {
          // Backup existing data
          final existingData = await db.query('scanned_products');

          // Drop and recreate table
          await db.execute('DROP TABLE scanned_products');
          await db.execute('''
            CREATE TABLE scanned_products (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              barcode TEXT,
              name TEXT,
              brand TEXT,
              categories TEXT,
              imageUrl TEXT,
              scannedAt TEXT,
              ingredients TEXT DEFAULT '',
              nutritionFacts TEXT DEFAULT ''
            )
          ''');

          // Restore data
          for (final row in existingData) {
            await db.insert('scanned_products', {
              ...row,
              'ingredients': row['ingredients'] ?? '',
              'nutritionFacts': row['nutritionFacts'] ?? '',
            });
          }
        } catch (e) {
          // If recreation fails, try ALTER TABLE
          if (!spCols.contains('ingredients')) {
            try {
              await db.execute(
                'ALTER TABLE scanned_products ADD COLUMN ingredients TEXT DEFAULT ""',
              );
            } catch (_) {}
          }
          if (!spCols.contains('nutritionFacts')) {
            try {
              await db.execute(
                'ALTER TABLE scanned_products ADD COLUMN nutritionFacts TEXT DEFAULT ""',
              );
            } catch (_) {}
          }
        }
      }
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE shopping_items ADD COLUMN price REAL');
      } catch (_) {}
      try {
        await db.execute('ALTER TABLE shopping_items ADD COLUMN unit TEXT');
      } catch (_) {}
    }
    if (oldVersion < 3) {
      try {
        await db.execute(
          "ALTER TABLE purchases ADD COLUMN source TEXT DEFAULT 'manual'",
        );
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE purchases ADD COLUMN shoppingItemId INTEGER',
        );
      } catch (_) {}
    }
    if (oldVersion < 4) {
      try {
        await db.execute('''
          CREATE TABLE scanned_products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            barcode TEXT,
            name TEXT,
            brand TEXT,
            categories TEXT,
            imageUrl TEXT,
            scannedAt TEXT
          )
        ''');
      } catch (_) {}
    }
    if (oldVersion < 6) {
      const cols = {
        'billType': 'TEXT', 'accountNumber': 'TEXT', 'billingPeriod': 'TEXT',
        'dueDate': 'TEXT', 'paymentMethod': 'TEXT', 'transportType': 'TEXT',
        'origin': 'TEXT', 'destination': 'TEXT', 'notes': 'TEXT',
      };
      for (final e in cols.entries) {
        try { await db.execute('ALTER TABLE purchases ADD COLUMN ${e.key} ${e.value}'); } catch (_) {}
      }
    }
    if (oldVersion < 5) {
      try {
        await db.execute(
          'ALTER TABLE scanned_products ADD COLUMN ingredients TEXT DEFAULT ""',
        );
        await db.execute(
          'ALTER TABLE scanned_products ADD COLUMN nutritionFacts TEXT DEFAULT ""',
        );
      } catch (_) {}
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE shopping_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        category TEXT,
        quantity INTEGER,
        isChecked INTEGER DEFAULT 0,
        price REAL,
        unit TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE purchases (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itemName TEXT,
        category TEXT,
        quantity REAL,
        price REAL,
        date TEXT,
        receiptImagePath TEXT,
        source TEXT DEFAULT 'manual',
        shoppingItemId INTEGER,
        billType TEXT,
        accountNumber TEXT,
        billingPeriod TEXT,
        dueDate TEXT,
        paymentMethod TEXT,
        transportType TEXT,
        origin TEXT,
        destination TEXT,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE scanned_products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT,
        name TEXT,
        brand TEXT,
        categories TEXT,
        imageUrl TEXT,
        scannedAt TEXT,
        ingredients TEXT DEFAULT '',
        nutritionFacts TEXT DEFAULT ''
      )
    ''');
  }

  Future<int> insertShoppingItem(Map<String, dynamic> item) async {
    Database db = await database;
    return await db.insert('shopping_items', item);
  }

  Future<List<Map<String, dynamic>>> getShoppingItems() async {
    Database db = await database;
    return await db.query('shopping_items');
  }

  Future<int> updateShoppingItem(int id, Map<String, dynamic> item) async {
    Database db = await database;
    return await db.update(
      'shopping_items',
      item,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteShoppingItem(int id) async {
    Database db = await database;
    return await db.delete('shopping_items', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletePurchase(int id) async {
    Database db = await database;
    return await db.delete('purchases', where: 'id = ?', whereArgs: [id]);
  }

  Future<int?> getPurchaseIdByShoppingItemId(int shoppingItemId) async {
    Database db = await database;
    final result = await db.query(
      'purchases',
      columns: ['id'],
      where: 'shoppingItemId = ?',
      whereArgs: [shoppingItemId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return result.first['id'] as int?;
  }

  Future<int> insertPurchase(Map<String, dynamic> purchase) async {
    Database db = await database;
    return await db.insert('purchases', purchase);
  }

  Future<List<Map<String, dynamic>>> getPurchases() async {
    Database db = await database;
    return await db.query('purchases', orderBy: 'date DESC');
  }

  Future<List<Map<String, dynamic>>> getPurchasesByDateRange(
    String startDate,
    String endDate,
  ) async {
    Database db = await database;
    return await db.query(
      'purchases',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date DESC',
    );
  }

  Future<double> getTotalSpending(String period) async {
    Database db = await database;
    String dateCondition;
    switch (period) {
      case 'daily':
        dateCondition = "date = date('now')";
        break;
      case 'weekly':
        dateCondition = "date >= date('now', '-6 days')";
        break;
      case 'monthly':
        dateCondition = "date >= date('now', 'start of month')";
        break;
      default:
        return 0.0;
    }
    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(price * quantity) as total FROM purchases WHERE $dateCondition',
    );
    final val = result.first['total'];
    return val == null ? 0.0 : (val as num).toDouble();
  }

  Future<int> insertScannedProduct(Map<String, dynamic> product) async {
    Database db = await database;
    return await db.insert('scanned_products', product);
  }

  Future<List<Map<String, dynamic>>> getScannedProducts({String? date}) async {
    Database db = await database;
    if (date == null) {
      return await db.query('scanned_products', orderBy: 'scannedAt DESC');
    }
    return await db.query(
      'scanned_products',
      where: "date(scannedAt) = date(?)",
      whereArgs: [date],
      orderBy: 'scannedAt DESC',
    );
  }

  Future<int> deleteScannedProduct(int id) async {
    Database db = await database;
    return await db.delete(
      'scanned_products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
