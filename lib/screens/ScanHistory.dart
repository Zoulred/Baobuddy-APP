import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/Scanned.dart';
import '../providers/ScanProvider.dart';
import '../providers/ThemeProvider.dart';
import '../theme/AppThemes.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  DateTime _selectedDate = DateTime.now();

  String get _formattedDate => DateFormat.yMMMMd().format(_selectedDate);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanProvider>().loadScans(
        date: _selectedDate.toIso8601String(),
      );
    });
  }

  Future<void> _pickDate() async {
    final provider = context.read<ScanProvider>();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() => _selectedDate = picked);
    provider.loadScans(date: picked.toIso8601String());
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

    return Scaffold(
      backgroundColor: bgCol,
      appBar: AppBar(
        title: const Text('Scanned Products'),
        backgroundColor: bgCol,
        elevation: 0,
        iconTheme: IconThemeData(color: textPri),
        titleTextStyle: TextStyle(
          color: textPri,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: cardCol,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: shadows,
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: accentCol),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textPri,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, size: 22, color: textSec),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<ScanProvider>(
                builder: (context, provider, _) {
                  final scans = provider.scans;
                  if (scans.isEmpty) {
                    return Center(
                      child: Text(
                        'No scan data for this date yet.',
                        style: TextStyle(color: textSec, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: scans.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final scan = scans[index];
                      return _buildScanTile(
                        scan,
                        cardCol,
                        accentCol,
                        textPri,
                        textSec,
                        shadows,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanTile(
    ScannedProduct scan,
    Color cardCol,
    Color accentCol,
    Color textPri,
    Color textSec,
    List<BoxShadow> shadows,
  ) {
    final time = DateFormat.jm().format(DateTime.parse(scan.scannedAt));

    return Dismissible(
      key: ValueKey(scan.id ?? scan.barcode),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => context.read<ScanProvider>().deleteScan(scan.id!),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardCol,
          borderRadius: BorderRadius.circular(16),
          boxShadow: shadows,
        ),
        child: Row(
          children: [
            if (scan.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  scan.imageUrl,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.image_not_supported, size: 42, color: textSec),
                ),
              )
            else
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accentCol.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.qr_code, size: 30, color: accentCol),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scan.name.isNotEmpty ? scan.name : 'Unknown product',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textPri,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scan.brand.isNotEmpty ? scan.brand : scan.barcode,
                    style: TextStyle(fontSize: 12, color: textSec),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (scan.categories.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      scan.categories,
                      style: TextStyle(fontSize: 11, color: textSec),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (scan.ingredients.isNotEmpty) ...[
                        Icon(Icons.receipt_long, size: 12, color: accentCol),
                        const SizedBox(width: 4),
                      ],
                      if (scan.nutritionFacts.isNotEmpty) ...[
                        Icon(Icons.restaurant_menu, size: 12, color: accentCol),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        'Details available',
                        style: TextStyle(fontSize: 10, color: accentCol),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(time, style: TextStyle(color: textSec, fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accentCol.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'SCANNED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: accentCol,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
