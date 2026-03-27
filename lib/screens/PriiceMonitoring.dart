import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/PurchaseProducts.dart';
import '../models/purchase.dart';

class PriceMonitoringScreen extends StatefulWidget {
  const PriceMonitoringScreen({super.key});

  @override
  State<PriceMonitoringScreen> createState() => _PriceMonitoringScreenState();
}

class _PriceMonitoringScreenState extends State<PriceMonitoringScreen> {
  String _filter = 'All';
  final List<String> _filters = ['All', 'Rising', 'Falling', 'Stable'];

  @override
  void initState() {
    super.initState();
    context.read<PurchaseProvider>().loadPurchases();
  }

  Map<String, List<Purchase>> _groupByItem(List<Purchase> purchases) {
    final grouped = <String, List<Purchase>>{};
    for (final p in purchases) {
      grouped.putIfAbsent(p.itemName, () => []).add(p);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Consumer<PurchaseProvider>(
          builder: (context, provider, _) {
            final grouped = _groupByItem(provider.purchases);

            // Apply trend filter
            final filteredEntries = grouped.entries.where((entry) {
              if (_filter == 'All') return true;
              final purchases = entry.value;
              if (purchases.length < 2) return _filter == 'Stable';
              final change =
                  purchases.last.price - purchases[purchases.length - 2].price;
              if (_filter == 'Rising') return change > 0;
              if (_filter == 'Falling') return change < 0;
              return change == 0;
            }).toList();

            // Summary stats
            int rising = 0, falling = 0, stable = 0;
            for (final entry in grouped.entries) {
              final p = entry.value;
              if (p.length < 2) {
                stable++;
              } else {
                final change = p.last.price - p[p.length - 2].price;
                if (change > 0)
                  rising++;
                else if (change < 0)
                  falling++;
                else
                  stable++;
              }
            }

            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Price Monitoring',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // Summary cards row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildStatCard(
                        'Tracked',
                        '${grouped.length}',
                        Icons.bar_chart,
                        Colors.green,
                      ),
                      const SizedBox(width: 10),
                      _buildStatCard(
                        'Rising',
                        '$rising',
                        Icons.trending_up,
                        Colors.red,
                      ),
                      const SizedBox(width: 10),
                      _buildStatCard(
                        'Falling',
                        '$falling',
                        Icons.trending_down,
                        Colors.green,
                      ),
                      const SizedBox(width: 10),
                      _buildStatCard(
                        'Stable',
                        '$stable',
                        Icons.trending_flat,
                        Colors.blue,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Filter chips
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final selected = _filter == _filters[i];
                      return GestureDetector(
                        onTap: () => setState(() => _filter = _filters[i]),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: selected ? Colors.green : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            _filters[i],
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black54,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // List
                Expanded(
                  child: filteredEntries.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bar_chart,
                                size: 72,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                grouped.isEmpty
                                    ? 'No price data yet'
                                    : 'No items match this filter',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Add purchases to track price changes',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: filteredEntries.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, index) {
                            final itemName = filteredEntries[index].key;
                            final itemPurchases = filteredEntries[index].value;
                            return _buildPriceCard(itemName, itemPurchases);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(String itemName, List<Purchase> purchases) {
    final latestPrice = purchases.last.price;
    final previousPrice = purchases.length > 1
        ? purchases[purchases.length - 2].price
        : null;
    final priceChange = previousPrice != null
        ? latestPrice - previousPrice
        : 0.0;
    final isRising = priceChange > 0;
    final isFalling = priceChange < 0;
    final trendColor = isRising
        ? Colors.red
        : (isFalling ? Colors.green : Colors.blue);
    final trendIcon = isRising
        ? Icons.trending_up
        : (isFalling ? Icons.trending_down : Icons.trending_flat);

    return GestureDetector(
      onTap: () => _showPriceHistory(itemName, purchases),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Trend icon badge
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: trendColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(trendIcon, color: trendColor, size: 22),
            ),
            const SizedBox(width: 14),
            // Item info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(76, 175, 80, 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          purchases.last.category,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${purchases.length} record${purchases.length > 1 ? 's' : ''}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Price info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₱${latestPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                if (previousPrice != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isRising
                            ? Icons.arrow_upward
                            : (isFalling ? Icons.arrow_downward : Icons.remove),
                        size: 12,
                        color: trendColor,
                      ),
                      Text(
                        '₱${priceChange.abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          color: trendColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  void _showPriceHistory(String itemName, List<Purchase> purchases) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
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
            const SizedBox(height: 16),
            Text(
              itemName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Price history — ${purchases.length} record${purchases.length > 1 ? 's' : ''}',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: purchases.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final p = purchases[purchases.length - 1 - i];
                  final isLatest = i == 0;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isLatest
                            ? const Color.fromRGBO(76, 175, 80, 0.12)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.receipt_outlined,
                        size: 18,
                        color: isLatest ? Colors.green : Colors.grey[400],
                      ),
                    ),
                    title: Text(
                      '₱${p.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isLatest ? Colors.green : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      p.date.split('T').first,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    trailing: isLatest
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(76, 175, 80, 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Latest',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
