import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Shoppingcard.dart';
import '../providers/PurchaseProducts.dart';
import '../providers/ThemeProvider.dart';
import '../theme/AppThemes.dart';
import '../models/ShoppingItem.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedCategory = '🥦 Vegetables';

  final List<String> _categories = [
    '🥦 Vegetables',
    '🍎 Fruits',
    '🍗 Meat & Seafood',
    '🥤 Drinks',
    '🍪 Snacks / Merienda',
    '🍞 Bread & Bakery',
    '🧽 Household',
    '🧴 Personal Care',
    '🥫 Canned',
  ];

  final Map<String, IconData> _categoryIcons = {
    '🥦 Vegetables': Icons.eco,
    '🍎 Fruits': Icons.apple,
    '🍗 Meat & Seafood': Icons.set_meal,
    '🥤 Drinks': Icons.local_drink,
    '🍪 Snacks / Merienda': Icons.cookie,
    '🍞 Bread & Bakery': Icons.bakery_dining,
    '🧽 Household': Icons.cleaning_services,
    '🧴 Personal Care': Icons.health_and_safety,
    '🥫 Canned': Icons.restaurant,
  };

  final Map<String, Color> _categoryColors = {
    '🥦 Vegetables': Colors.green,
    '🍎 Fruits': Colors.orange,
    '🍗 Meat & Seafood': Colors.redAccent,
    '🥤 Drinks': Colors.blue,
    '🍪 Snacks / Merienda': Colors.brown,
    '🍞 Bread & Bakery': Colors.amber,
    '🧽 Household': Colors.cyan,
    '🧴 Personal Care': Colors.pink,
    '🥫 Canned': Colors.deepOrange,
  };

  @override
  void initState() {
    super.initState();
    context.read<ShoppingListProvider>().loadItems();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _addItem() {
    final name = _nameController.text.trim();
    final qty = int.tryParse(_quantityController.text.trim());
    if (name.isEmpty || qty == null || qty <= 0) return;
    context.read<ShoppingListProvider>().addItem(
      ShoppingItem(name: name, category: _selectedCategory, quantity: qty),
    );
    _nameController.clear();
    _quantityController.clear();
    FocusScope.of(context).unfocus();
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Add Item',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  prefixIcon: const Icon(Icons.shopping_cart_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Qty',
                        prefixIcon: const Icon(Icons.numbers),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: StatefulBuilder(
                      builder: (ctx, setLocal) =>
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            items: _categories
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(
                                      c,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              setLocal(() => _selectedCategory = v!);
                              setState(() => _selectedCategory = v!);
                            },
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _addItem();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add to List',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPriceSheet(
    ShoppingItem item,
    ShoppingListProvider provider,
    Color color,
  ) {
    final purchaseProvider = context.read<PurchaseProvider>();
    if (item.isChecked) {
      provider.toggleChecked(item.id!, purchaseProvider);
      return;
    }
    final priceController = TextEditingController();
    String selectedUnit = 'kg';
    final units = ['kg', 'g', 'pcs', 'pack', 'liter', 'bundle'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: StatefulBuilder(
            builder: (ctx, setLocal) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Qty: ${item.quantity}  •  ${item.category}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter Price Details',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Price per unit',
                          prefixText: '₱ ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: selectedUnit,
                        decoration: InputDecoration(
                          labelText: 'Unit',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items: units
                            .map(
                              (u) => DropdownMenuItem(value: u, child: Text(u)),
                            )
                            .toList(),
                        onChanged: (v) => setLocal(() => selectedUnit = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final price = double.tryParse(
                        priceController.text.trim(),
                      );
                      if (price == null || price <= 0) return;
                      provider.toggleCheckedWithPrice(
                        item.id!,
                        price: price,
                        unit: selectedUnit,
                        purchaseProvider: purchaseProvider,
                      );
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text(
                      'Mark as Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteItem(int id) {
    final purchaseProvider = context.read<PurchaseProvider>();
    context.read<ShoppingListProvider>().deleteItem(id, purchaseProvider);
  }

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeProvider>().mode;
    final bgCol = AppThemes.bg(mode);
    final cardCol = AppThemes.cardColor(mode);
    final accentCol = AppThemes.accent(mode);
    final textPri = AppThemes.textPrimary(mode);
    final textSec = AppThemes.textSecondary(mode);
    final shadows = AppThemes.shadow(mode);
    final borderCol = AppThemes.border(mode);
    final accentSub = AppThemes.accentSubtle(mode);

    return Scaffold(
      backgroundColor: bgCol,
      appBar: AppBar(
        backgroundColor: cardCol,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textPri),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Shopping List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: textPri,
          ),
        ),
        actions: [
          Consumer<ShoppingListProvider>(
            builder: (_, provider, __) {
              final checked = provider.items.where((i) => i.isChecked).length;
              if (checked == 0) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () {
                  for (final item
                      in provider.items.where((i) => i.isChecked).toList()) {
                    _deleteItem(item.id!);
                  }
                },
                icon: const Icon(Icons.delete_sweep, color: Colors.red),
                label: const Text(
                  'Clear done',
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ShoppingListProvider>(
        builder: (context, provider, _) {
          if (provider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 72,
                    color: textSec.withOpacity(0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your list is empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textSec,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap + to add items',
                    style: TextStyle(color: textSec.withOpacity(0.6)),
                  ),
                ],
              ),
            );
          }

          // Group by category
          final grouped = <String, List<ShoppingItem>>{};
          for (final item in provider.items) {
            grouped.putIfAbsent(item.category, () => []).add(item);
          }

          final total = provider.items.length;
          final done = provider.items.where((i) => i.isChecked).length;

          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: cardCol,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$done of $total items done',
                          style: TextStyle(color: textSec, fontSize: 13),
                        ),
                        Text(
                          '${total > 0 ? (done / total * 100).round() : 0}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: accentCol,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: total > 0 ? done / total : 0,
                        minHeight: 8,
                        backgroundColor: accentSub,
                        valueColor: AlwaysStoppedAnimation<Color>(accentCol),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  children: grouped.entries.map((entry) {
                    final cat = entry.key;
                    final items = entry.value;
                    final color = _categoryColors[cat] ?? Colors.green;
                    final icon = _categoryIcons[cat] ?? Icons.shopping_basket;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(icon, size: 16, color: color),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cat,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: color,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${items.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...items.map(
                          (item) => _buildItemTile(
                            item,
                            provider,
                            color,
                            cardCol: cardCol,
                            borderCol: borderCol,
                            shadows: shadows,
                            textSec: textSec,
                            textPri: textPri,
                            accentCol: accentCol,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        backgroundColor: accentCol,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Item',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 4,
      ),
    );
  }

  Widget _buildItemTile(
    ShoppingItem item,
    ShoppingListProvider provider,
    Color color, {
    required Color cardCol,
    required Color borderCol,
    required List<BoxShadow> shadows,
    required Color textSec,
    required Color textPri,
    required Color accentCol,
  }) {
    return Dismissible(
      key: Key('item_${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      onDismissed: (_) => _deleteItem(item.id!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: cardCol,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderCol == Colors.transparent
                ? Colors.transparent
                : borderCol,
          ),
          boxShadow: shadows,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: GestureDetector(
            onTap: () => _showPriceSheet(item, provider, color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.isChecked ? color : Colors.transparent,
                border: Border.all(
                  color: item.isChecked ? color : textSec.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: item.isChecked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              decoration: item.isChecked ? TextDecoration.lineThrough : null,
              color: item.isChecked ? textSec : textPri,
            ),
          ),
          subtitle: item.isChecked && item.price != null
              ? Text(
                  '₱${item.price!.toStringAsFixed(2)}  •  Qty: ${item.quantity}',
                  style: TextStyle(
                    color: accentCol,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(color: textSec, fontSize: 13),
                ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: textSec.withOpacity(0.5),
              size: 20,
            ),
            onPressed: () => _deleteItem(item.id!),
          ),
        ),
      ),
    );
  }
}
