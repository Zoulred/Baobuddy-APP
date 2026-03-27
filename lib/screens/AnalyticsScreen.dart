import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/PurchaseProducts.dart';
import '../providers/ThemeProvider.dart';
import '../theme/AppThemes.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  String _period = 'monthly';
  late AnimationController _animController;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _setPeriod(String p) {
    setState(() => _period = p);
    _animController.forward(from: 0);
  }

  static const _palette = [
    Color(0xFF1A1A2E),
    Color(0xFF4A90D9),
    Color(0xFF6C757D),
    Color(0xFFADB5BD),
    Color(0xFF343A40),
    Color(0xFF7CB9E8),
  ];

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeProvider>().mode;
    final bg = AppThemes.bg(mode);
    final card = AppThemes.cardColor(mode);
    final accent = AppThemes.accent(mode);
    final textPri = AppThemes.textPrimary(mode);
    final textSec = AppThemes.textSecondary(mode);
    final borderCol = AppThemes.border(mode);
    final accentSub = AppThemes.accentSubtle(mode);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Reports',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
            color: textPri,
          ),
        ),
        iconTheme: IconThemeData(color: textPri),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: borderCol),
        ),
      ),
      body: Consumer<PurchaseProvider>(
        builder: (context, provider, _) {
          final today = DateTime.now();
          final todayKey =
              '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

          // week key = Monday of the current week
          final weekday = today.weekday;
          final weekStart = today.subtract(Duration(days: weekday - 1));

          // yesterday key
          final yesterday = today.subtract(const Duration(days: 1));
          final yesterdayKey =
              '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

          // month key = YYYY-MM
          final monthKey =
              '${today.year}-${today.month.toString().padLeft(2, '0')}';

          Map<String, double> _catsForKey(String dateKey) {
            final map = <String, double>{};
            for (final p in provider.purchases.where(
              (p) => p.date.startsWith(dateKey),
            )) {
              map[p.category] = (map[p.category] ?? 0) + p.price;
            }
            return map;
          }

          Map<String, double> _periodTotals() {
            final map = <String, double>{};
            for (final p in provider.purchases) {
              bool include = false;
              if (_period == 'daily') {
                include = p.date.startsWith(todayKey);
              } else if (_period == 'weekly') {
                try {
                  final d = DateTime.parse(p.date.split(' ')[0]);
                  include =
                      !d.isBefore(weekStart) &&
                      d.isBefore(weekStart.add(const Duration(days: 7)));
                } catch (_) {}
              } else {
                include = p.date.startsWith(monthKey);
              }
              if (include) {
                map[p.category] = (map[p.category] ?? 0) + p.price;
              }
            }
            return map;
          }

          final totals = _periodTotals();
          final totalSpend = totals.values.fold(0.0, (a, b) => a + b);
          final percentages = <String, double>{};
          if (totalSpend > 0) {
            for (final e in totals.entries) {
              percentages[e.key] = (e.value / totalSpend) * 100;
            }
          }

          final yesterdayCats = _catsForKey(yesterdayKey);
          final yesterdayTotal = yesterdayCats.values.fold(
            0.0,
            (a, b) => a + b,
          );

          if (provider.purchases.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bar_chart_outlined, size: 44, color: textSec),
                  const SizedBox(height: 12),
                  Text(
                    'No expenses recorded yet',
                    style: TextStyle(fontSize: 14, color: textSec),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Period selector ──────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderCol),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    children: ['daily', 'weekly', 'monthly'].map((p) {
                      final sel = _period == p;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _setPeriod(p),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: sel ? accent : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              p[0].toUpperCase() + p.substring(1),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: sel ? Colors.white : textSec,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Total spending ───────────────────────────────
                _card(
                  card: card,
                  border: borderCol,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _period == 'daily'
                                ? 'TODAY\'S SPENDING'
                                : _period == 'weekly'
                                ? 'THIS WEEK\'S SPENDING'
                                : 'THIS MONTH\'S SPENDING',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: textSec,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '₱${totalSpend.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: textPri,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: accentSub,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${totals.length} categories',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Distribution (period-accurate) ───────────────
                if (totals.isNotEmpty)
                  _card(
                    card: card,
                    border: borderCol,
                    child: _distributionSection(
                      label: _period == 'daily'
                          ? 'TODAY\'S DISTRIBUTION'
                          : _period == 'weekly'
                          ? 'THIS WEEK\'S DISTRIBUTION'
                          : 'THIS MONTH\'S DISTRIBUTION',
                      totals: totals,
                      totalSpend: totalSpend,
                      percentages: percentages,
                      textPri: textPri,
                      textSec: textSec,
                    ),
                  )
                else
                  _card(
                    card: card,
                    border: borderCol,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _period == 'daily'
                              ? 'TODAY\'S DISTRIBUTION'
                              : _period == 'weekly'
                              ? 'THIS WEEK\'S DISTRIBUTION'
                              : 'THIS MONTH\'S DISTRIBUTION',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            color: textSec,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No data for this period',
                          style: TextStyle(fontSize: 13, color: textSec),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),

                // ── Yesterday Distribution (daily only) ──────────
                if (_period == 'daily')
                  _card(
                    card: card,
                    border: borderCol,
                    child: yesterdayCats.isNotEmpty
                        ? _distributionSection(
                            label: 'YESTERDAY\'S DISTRIBUTION',
                            totals: yesterdayCats,
                            totalSpend: yesterdayTotal,
                            percentages: {
                              for (final e in yesterdayCats.entries)
                                e.key: yesterdayTotal > 0
                                    ? (e.value / yesterdayTotal) * 100
                                    : 0.0,
                            },
                            textPri: textPri,
                            textSec: textSec,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'YESTERDAY\'S DISTRIBUTION',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                  color: textSec,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No expenses yesterday',
                                style: TextStyle(fontSize: 13, color: textSec),
                              ),
                            ],
                          ),
                  ),
                if (_period == 'daily') const SizedBox(height: 12),

                // ── Category breakdown ───────────────────────────
                if (totals.isNotEmpty)
                  _card(
                    card: card,
                    border: borderCol,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BREAKDOWN',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            color: textSec,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...totals.entries.map((entry) {
                          final pct = percentages[entry.key] ?? 0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: textPri,
                                      ),
                                    ),
                                    Text(
                                      '₱${entry.value.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: textPri,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                AnimatedBuilder(
                                  animation: _anim,
                                  builder: (_, __) => ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: LinearProgressIndicator(
                                      value: (pct / 100) * _anim.value,
                                      minHeight: 3,
                                      backgroundColor: accentSub,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        accent,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${pct.toStringAsFixed(1)}% of total',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: textSec,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),

                // ── Spending trend bar chart ──────────────────────
                _card(
                  card: card,
                  border: borderCol,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SPENDING TREND',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: textSec,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 180,
                        child: _barChart(
                          provider,
                          _period,
                          accent,
                          textSec,
                          borderCol,
                          accentSub,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _distributionSection({
    required String label,
    required Map<String, double> totals,
    required double totalSpend,
    required Map<String, double> percentages,
    required Color textPri,
    required Color textSec,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: textSec,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => SizedBox(
                width: 140,
                height: 140,
                child: PieChart(
                  PieChartData(
                    sections: _pieSections(totals, totalSpend, _anim.value),
                    centerSpaceRadius: 36,
                    sectionsSpace: 2,
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 700),
                  swapAnimationCurve: Curves.easeOutCubic,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: totals.keys.toList().asMap().entries.map((e) {
                  final color = _palette[e.key % _palette.length];
                  final pct = percentages[e.value] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            e.value,
                            style: TextStyle(fontSize: 12, color: textPri),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${pct.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: textSec,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _card({
    required Color card,
    required Color border,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: child,
    );
  }

  List<PieChartSectionData> _pieSections(
    Map<String, double> totals,
    double total,
    double animValue,
  ) {
    int i = 0;
    return totals.entries.map((e) {
      final pct = (e.value / total) * 100;
      final color = _palette[i++ % _palette.length];
      return PieChartSectionData(
        color: color,
        value: e.value,
        title: pct >= 8 ? '${pct.toStringAsFixed(0)}%' : '',
        radius: 50 * animValue,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _barChart(
    PurchaseProvider provider,
    String period,
    Color accent,
    Color textSec,
    Color borderCol,
    Color accentSub,
  ) {
    final data = provider.getAggregatedByDate(period);
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data for this period',
          style: TextStyle(fontSize: 13, color: textSec),
        ),
      );
    }

    final sorted = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final entries = sorted.length > 7
        ? sorted.sublist(sorted.length - 7)
        : sorted;
    final maxY = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return BarChart(
      swapAnimationDuration: const Duration(milliseconds: 600),
      swapAnimationCurve: Curves.easeOutCubic,
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY * 1.3,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => accent,
            tooltipMargin: 6,
            getTooltipItem: (group, _, rod, __) => BarTooltipItem(
              '₱${rod.toY.toStringAsFixed(0)}',
              const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, _) {
                final i = value.toInt();
                if (i < 0 || i >= entries.length) {
                  return const SizedBox.shrink();
                }
                final label = entries[i].key.split('-').skip(1).join('/');
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 9, color: textSec),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == meta.min || value == meta.max) {
                  return const SizedBox.shrink();
                }
                return Text(
                  '₱${value.toInt()}',
                  style: TextStyle(fontSize: 9, color: textSec),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: borderCol, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: entries.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.value,
                color: accent,
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(3),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
