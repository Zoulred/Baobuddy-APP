import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../providers/PurchaseProducts.dart';
import '../providers/ThemeProvider.dart';
import '../theme/AppThemes.dart';
import '../models/purchase.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key, this.initialFilter = 'All'});

  final String initialFilter;

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  late String _filter = widget.initialFilter;
  final List<String> _filters = [
    'All',
    'Today',
    'Yesterday',
    'This Week',
    'This Month',
  ];

  @override
  void initState() {
    super.initState();
    context.read<PurchaseProvider>().loadPurchases();
  }

  List<Purchase> _applyFilter(List<Purchase> purchases) {
    final now = DateTime.now();
    return purchases.where((p) {
      final date = DateTime.tryParse(p.date);
      if (date == null) return false;
      switch (_filter) {
        case 'Today':
          return date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
        case 'Yesterday':
          final yesterday = now.subtract(const Duration(days: 1));
          return date.year == yesterday.year &&
              date.month == yesterday.month &&
              date.day == yesterday.day;
        case 'This Week':
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          return date.isAfter(startOfWeek.subtract(const Duration(days: 1)));
        case 'This Month':
          return date.year == now.year && date.month == now.month;
        default:
          return true;
      }
    }).toList();
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
      body: SafeArea(
        child: Consumer<PurchaseProvider>(
          builder: (context, provider, _) {
            final filtered = _applyFilter(provider.purchases);
            final totalSpent = filtered.fold<double>(
              0,
              (sum, p) => sum + (p.price * p.quantity),
            );

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
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cardCol,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderCol == Colors.transparent
                                  ? Colors.transparent
                                  : borderCol,
                            ),
                            boxShadow: shadows,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: textPri,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Purchase History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textPri,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => _printReceipt(filtered),
                        icon: Icon(Icons.print_outlined, color: accentCol),
                        tooltip: 'Print Receipt',
                      ),
                    ],
                  ),
                ),

                // Summary card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: accentCol,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: shadows,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.attach_money,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${filtered.length} Purchases',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₱${totalSpent.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Total Spent',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _filter,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

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
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: selected ? accentCol : cardCol,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: borderCol == Colors.transparent
                                  ? Colors.transparent
                                  : borderCol,
                              width: 0.8,
                            ),
                            boxShadow: shadows,
                          ),
                          child: Text(
                            _filters[i],
                            style: TextStyle(
                              color: selected ? Colors.white : textSec,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // List
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.receipt_outlined,
                                size: 72,
                                color: textSec.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No purchases found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: textSec,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tap + on Home to add one',
                                style: TextStyle(
                                  color: textSec.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, index) => _buildTile(
                            filtered[index],
                            cardCol,
                            accentCol,
                            accentSub,
                            textPri,
                            textSec,
                            shadows,
                            borderCol,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTile(
    Purchase purchase,
    Color cardCol,
    Color accentCol,
    Color accentSub,
    Color textPri,
    Color textSec,
    List<BoxShadow> shadows,
    Color borderCol,
  ) {
    final isFromList = purchase.source == 'shopping_list';
    final totalCost = purchase.price * purchase.quantity;

    return Container(
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: purchase.receiptImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(purchase.receiptImagePath!),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: accentSub,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.attach_money, color: accentCol, size: 26),
              ),
        title: Text(
          purchase.itemName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: textPri,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: accentSub,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  purchase.category,
                  style: TextStyle(
                    color: accentCol,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isFromList)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'From List',
                    style: TextStyle(
                      color: Color(0xFF1976D2),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Text(
                'Qty: ${purchase.quantity}  •  ₱${purchase.price.toStringAsFixed(2)}/unit',
                style: TextStyle(color: textSec, fontSize: 12),
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₱${totalCost.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: textPri,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              purchase.date.split('T').first,
              style: TextStyle(
                color: textSec.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _printReceipt(List<Purchase> purchases) async {
    final fontRegular = await PdfGoogleFonts.notoSansRegular();
    final fontBold = await PdfGoogleFonts.notoSansBold();
    final logoBytes = await rootBundle.load('assets/images/Baobuddylogo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    final pdf = pw.Document();
    final total = purchases.fold<double>(0, (s, p) => s + p.price * p.quantity);
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    const black = PdfColor.fromInt(0xFF000000);
    const grey = PdfColor.fromInt(0xFF888888);
    const lightGrey = PdfColor.fromInt(0xFFDDDDDD);

    pw.TextStyle reg(double size, {PdfColor color = black}) =>
        pw.TextStyle(font: fontRegular, fontSize: size, color: color);
    pw.TextStyle bold(double size, {PdfColor color = black}) => pw.TextStyle(
      font: fontBold,
      fontSize: size,
      fontWeight: pw.FontWeight.bold,
      color: color,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        header: (pw.Context ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Center(child: pw.Image(logoImage, width: 48, height: 48)),
            pw.SizedBox(height: 4),
            pw.Text(
              'Market Budget Tracker',
              style: reg(8, color: grey),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              '$dateStr   $timeStr',
              style: reg(8, color: grey),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              _filter == 'All' ? 'All Purchases' : _filter,
              style: reg(8, color: grey),
              textAlign: pw.TextAlign.center,
            ),
            pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 6),
              height: 0.5,
              color: lightGrey,
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Text('ITEM', style: bold(7, color: grey)),
                ),
                pw.SizedBox(
                  width: 44,
                  child: pw.Text('DATE', style: bold(7, color: grey)),
                ),
                pw.SizedBox(
                  width: 24,
                  child: pw.Text(
                    'QTY',
                    style: bold(7, color: grey),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.SizedBox(
                  width: 44,
                  child: pw.Text(
                    'AMOUNT',
                    style: bold(7, color: grey),
                    textAlign: pw.TextAlign.right,
                  ),
                ),
              ],
            ),
            pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 6),
              height: 0.5,
              color: lightGrey,
            ),
          ],
        ),
        footer: (pw.Context ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 6),
              height: 0.5,
              color: lightGrey,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TOTAL', style: bold(11)),
                pw.Text('PHP ${total.toStringAsFixed(2)}', style: bold(11)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              '${purchases.length} item${purchases.length == 1 ? '' : 's'}',
              style: reg(8, color: grey),
              textAlign: pw.TextAlign.right,
            ),
            pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 6),
              height: 0.5,
              color: lightGrey,
            ),
            pw.Text(
              'Thank you!',
              style: bold(12),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              'Keep track of your market budget.',
              style: reg(7, color: grey),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
        build: (pw.Context ctx) => purchases.map((p) {
          final lineTotal = p.price * p.quantity;
          final dateLabel = p.date.split('T').first;
          return pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 4),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(p.itemName, style: bold(9)),
                      pw.Text(p.category, style: reg(7, color: grey)),
                    ],
                  ),
                ),
                pw.SizedBox(
                  width: 44,
                  child: pw.Text(dateLabel, style: reg(7, color: grey)),
                ),
                pw.SizedBox(
                  width: 24,
                  child: pw.Text(
                    p.quantity.toStringAsFixed(0),
                    style: reg(9),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.SizedBox(
                  width: 44,
                  child: pw.Text(
                    'PHP ${lineTotal.toStringAsFixed(2)}',
                    style: reg(9),
                    textAlign: pw.TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
