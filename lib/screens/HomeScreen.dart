import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

import '../models/purchase.dart';
import '../providers/PurchaseProducts.dart';
import '../providers/ScanProvider.dart';
import '../providers/Shoppingcard.dart';
import '../providers/ThemeProvider.dart';
import '../providers/UserProvider.dart';
import '../theme/AppThemes.dart';
import 'AccountScreen.dart';
import 'AddPurchase.dart';
import 'AIAssistantScreen.dart';
import 'AnalyticsScreen.dart';
import 'BarcodeScanScreen.dart';
import 'History.dart';
import 'PriiceMonitoring.dart';
import 'ScanHistory.dart';
import 'Shoppinglist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _dailyBudget = 350.0;
  int _selectedIndex = 0;
  late VideoPlayerController _videoController;
  bool _hasMutedAfterStart = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/video/hello.mp4')
      ..initialize().then((_) {
        _videoController.setLooping(false);
        _videoController.setVolume(1.0);
        _videoController.play();

        _videoController.addListener(() {
          if (!_videoController.value.isInitialized) return;
          final value = _videoController.value;

          if (!_hasMutedAfterStart &&
              (value.position >= const Duration(seconds: 6) ||
                  value.position >= value.duration)) {
            _hasMutedAfterStart = true;
            _videoController.setVolume(0);
          }

          if (value.position >= value.duration && !value.isPlaying) {
            _videoController.seekTo(Duration.zero);
            _videoController.play();
          }
        });

        if (mounted) setState(() {});
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PurchaseProvider>().loadPurchases();
      context.read<ShoppingListProvider>().loadItems();
      context.read<ScanProvider>().loadScans(
        date: DateTime.now().toIso8601String(),
      );
      context.read<UserProvider>().loadUserName();
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _onNavItemTapped(int index) async {
    if (index == 0) return;
    Widget destination;
    switch (index) {
      case 1:
        destination = const PurchaseHistoryScreen();
        break;
      case 2:
        destination = const AnalyticsScreen();
        break;
      case 3:
        destination = const AccountScreen();
        break;
      default:
        destination = const SizedBox.shrink();
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
    // Reset selected tab to Home when returning
    setState(() => _selectedIndex = 0);
  }

  bool _isYesterday(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  bool _isToday(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final mode = themeProvider.mode;

    final bgCol = AppThemes.bg(mode);
    final cardCol = AppThemes.cardColor(mode);
    final accentCol = AppThemes.accent(mode);
    final textPri = AppThemes.textPrimary(mode);
    final textSec = AppThemes.textSecondary(mode);
    final borderCol = AppThemes.border(mode);
    final accentSub = AppThemes.accentSubtle(mode);

    return Scaffold(
      backgroundColor: bgCol,
      body: SafeArea(
        child: Consumer<PurchaseProvider>(
          builder: (context, provider, child) {
            final todayPurchases = provider.purchases
                .where((p) => _isToday(p.date))
                .toList();
            final todaySpent = todayPurchases.fold<double>(
              0,
              (sum, p) => sum + (p.price * p.quantity),
            );
            final yesterdaySpent = provider.purchases
                .where((p) => _isYesterday(p.date))
                .fold<double>(0, (sum, p) => sum + (p.price * p.quantity));
            final remaining = (_dailyBudget - todaySpent).clamp(
              -999999.0,
              _dailyBudget,
            );
            final progress = (_dailyBudget > 0)
                ? (todaySpent / _dailyBudget).clamp(0.0, 1.0)
                : 0.0;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/Baobuddylogo.png',
                        width: 35,
                        height: 35,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'BaoBuddy',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          color: textPri,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => themeProvider.cycle(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: cardCol,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderCol),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                AppThemes.themeIcon(mode),
                                size: 14,
                                color: textSec,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppThemes.themeLabel(mode),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: textSec,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<UserProvider>(
                          builder: (context, userProvider, _) {
                            return _buildGreetingCard(
                              userProvider.userName,
                              cardCol,
                              accentCol,
                              textPri,
                              textSec,
                              borderCol,
                              yesterdaySpent,
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildBudgetCard(
                                todaySpent,
                                remaining,
                                progress,
                                cardCol,
                                accentCol,
                                textPri,
                                textSec,
                                borderCol,
                                accentSub,
                              ),
                            ),
                            const SizedBox(width: 10),
                            _buildWeeklyCard(
                              cardCol,
                              accentCol,
                              textPri,
                              textSec,
                              borderCol,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'QUICK ACTIONS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: textSec,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildActionGrid(
                          cardCol,
                          accentCol,
                          textPri,
                          borderCol,
                          accentSub,
                        ),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TODAY'S SPENDING",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                                color: textSec,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PurchaseHistoryScreen(),
                                ),
                              ),
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: accentCol,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (todayPurchases.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'No purchases yet',
                                style: TextStyle(fontSize: 13, color: textSec),
                              ),
                            ),
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              color: cardCol,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: borderCol),
                            ),
                            child: Column(
                              children: todayPurchases.take(3).map((p) {
                                final isLast = p == todayPurchases.take(3).last;
                                return Column(
                                  children: [
                                    _buildSpendingTile(
                                      p,
                                      accentCol,
                                      textPri,
                                      textSec,
                                      accentSub,
                                    ),
                                    if (!isLast)
                                      Divider(
                                        height: 1,
                                        indent: 56,
                                        color: borderCol,
                                      ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(height: 90),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddPurchaseScreen()),
        ),
        backgroundColor:
            context.watch<ThemeProvider>().mode == AppThemeMode.cyberpunk
            ? AppThemes.accent(context.watch<ThemeProvider>().mode)
            : AppThemes.accent(context.watch<ThemeProvider>().mode),
        foregroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.add, size: 22),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          final mode = context.watch<ThemeProvider>().mode;
          final cardCol = AppThemes.cardColor(mode);
          final borderCol = AppThemes.border(mode);
          final accentCol = AppThemes.accent(mode);
          final textSec = AppThemes.textSecondary(mode);
          return Container(
            decoration: BoxDecoration(
              color: cardCol,
              border: Border(top: BorderSide(color: borderCol)),
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) async {
                setState(() => _selectedIndex = index);
                await _onNavItemTapped(index);
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: accentCol,
              unselectedItemColor: textSec,
              selectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 11),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined),
                  activeIcon: Icon(Icons.history),
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart),
                  label: 'Reports',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Account',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _editBudget() {
    final controller = TextEditingController(
      text: _dailyBudget.toStringAsFixed(2),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Set Daily Budget'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            prefixText: '₱ ',
            border: OutlineInputBorder(),
            labelText: 'Amount',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                setState(() => _dailyBudget = value);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(
    double spent,
    double remaining,
    double progress,
    Color cardCol,
    Color accentCol,
    Color textPri,
    Color textSec,
    Color borderCol,
    Color accentSub,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardCol,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderCol),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentSub,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.wallet, color: accentCol, size: 22),
              ),
              const SizedBox(width: 10.1),
              Text(
                'Daily Budget',
                style: TextStyle(fontWeight: FontWeight.w600, color: textPri),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _editBudget,
                child: Icon(Icons.edit, size: 18, color: accentCol),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '₱${_dailyBudget.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textPri,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Used', style: TextStyle(color: textSec, fontSize: 11)),
              Flexible(
                child: Text(
                  '₱${spent.toStringAsFixed(2)}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: accentSub,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress < 0.9 ? accentCol : Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'Left: ₱${remaining.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: remaining < 0 ? Colors.red : accentCol,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyCard(
    Color cardCol,
    Color accentCol,
    Color textPri,
    Color textSec,
    Color borderCol,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const PurchaseHistoryScreen(initialFilter: 'This Week'),
        ),
      ),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardCol,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderCol),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Week',
              style: TextStyle(fontWeight: FontWeight.w600, color: textPri),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final barWidth = (constraints.maxWidth - 12) / 4;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      final heightFactor = (0.4 + index * 0.15).clamp(0.0, 1.0);
                      return Container(
                        width: barWidth,
                        height: 60 * heightFactor,
                        decoration: BoxDecoration(
                          color: accentCol.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_forward_ios, size: 14, color: textSec),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGrid(
    Color cardCol,
    Color accentCol,
    Color textPri,
    Color borderCol,
    Color accentSub,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.shopping_cart,
                label: 'Shopping List',
                isPrimary: false,
                cardCol: cardCol,
                accentCol: accentCol,
                textPri: textPri,
                borderCol: borderCol,
                accentSub: accentSub,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ShoppingListScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.qr_code_scanner,
                label: 'Scan Item',
                isPrimary: false,
                cardCol: cardCol,
                accentCol: accentCol,
                textPri: textPri,
                borderCol: borderCol,
                accentSub: accentSub,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BarcodeScanScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.show_chart,
                label: 'Price Monitor',
                isPrimary: false,
                cardCol: cardCol,
                accentCol: accentCol,
                textPri: textPri,
                borderCol: borderCol,
                accentSub: accentSub,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PriceMonitoringScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.receipt_long,
                label: 'Expenses',
                isPrimary: false,
                cardCol: cardCol,
                accentCol: accentCol,
                textPri: textPri,
                borderCol: borderCol,
                accentSub: accentSub,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PurchaseHistoryScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.history,
                label: 'Scans',
                isPrimary: false,
                cardCol: cardCol,
                accentCol: accentCol,
                textPri: textPri,
                borderCol: borderCol,
                accentSub: accentSub,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScanHistoryScreen()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildAssistantCard(
          accentCol: accentCol,
          accentSub: accentSub,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AIAssistantScreen(dailyBudget: _dailyBudget),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required Color cardCol,
    required Color accentCol,
    required Color textPri,
    required Color borderCol,
    required Color accentSub,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isPrimary ? accentCol : cardCol,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isPrimary ? Colors.transparent : borderCol),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isPrimary
                    ? Colors.white.withValues(alpha: 0.2)
                    : accentSub,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isPrimary ? Colors.white : accentCol,
                size: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.3,
                color: isPrimary ? Colors.white : textPri,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssistantCard({
    required Color accentCol,
    required Color accentSub,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: accentCol,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Image.asset(
              'assets/images/Baobuddylogo.png',
              width: 35,
              height: 36,
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Baobuddy Assistant',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Ask me anything about your spending',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingTile(
    Purchase purchase,
    Color accentCol,
    Color textPri,
    Color textSec,
    Color accentSub,
  ) {
    return ListTile(
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
          : CircleAvatar(
              backgroundColor: accentSub,
              child: Icon(Icons.attach_money, color: accentCol),
            ),
      title: Text(
        purchase.itemName,
        style: TextStyle(fontWeight: FontWeight.w600, color: textPri),
      ),
      subtitle: Text(
        '${purchase.quantity} ${purchase.category.toLowerCase()}',
        style: TextStyle(color: textSec),
      ),
      trailing: Text(
        '₱${(purchase.price * purchase.quantity).toStringAsFixed(2)}',
        style: TextStyle(fontWeight: FontWeight.bold, color: accentCol),
      ),
    );
  }

  Widget _buildGreetingCard(
    String userName,
    Color cardCol,
    Color accentCol,
    Color textPri,
    Color textSec,
    Color borderCol,
    double yesterdaySpent,
  ) {
    final greeting = _getGreeting();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardCol,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderCol),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textSec,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hello, $userName!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: accentCol,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready to track your spending today?',
                  style: TextStyle(fontSize: 13, color: textSec),
                ),
                const SizedBox(height: 6),
                _YesterdayText(
                  yesterdaySpent: yesterdaySpent,
                  accentCol: accentCol,
                  textSec: textSec,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 88,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: accentCol.withValues(alpha: 0.1),
            ),
            child: _videoController.value.isInitialized
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 18) return 'Good afternoon,';
    return 'Good evening,';
  }
}

class _YesterdayText extends StatefulWidget {
  final double yesterdaySpent;
  final Color accentCol;
  final Color textSec;
  const _YesterdayText({
    required this.yesterdaySpent,
    required this.accentCol,
    required this.textSec,
  });
  @override
  State<_YesterdayText> createState() => _YesterdayTextState();
}

class _YesterdayTextState extends State<_YesterdayText> {
  final List<String> _queue = [];
  String _displayed = '';
  int _phraseIndex = 0;
  bool _typing = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _buildQueue();
    _runNext();
  }

  @override
  void didUpdateWidget(_YesterdayText old) {
    super.didUpdateWidget(old);
    if (old.yesterdaySpent != widget.yesterdaySpent) {
      _timer?.cancel();
      _buildQueue();
      _phraseIndex = 0;
      _displayed = '';
      _typing = true;
      _runNext();
    }
  }

  void _buildQueue() {
    final amt = widget.yesterdaySpent > 0
        ? '₱${widget.yesterdaySpent.toStringAsFixed(2)}'
        : 'No expenses';
    _queue
      ..clear()
      ..addAll([
        'Yesterday: $amt',
        'You spent $amt',
        "Yesterday's total: $amt",
      ]);
  }

  void _runNext() {
    final phrase = _queue[_phraseIndex % _queue.length];
    _type(phrase);
  }

  void _type(String phrase) {
    int i = _displayed.length;
    _typing = true;
    _timer = Timer.periodic(const Duration(milliseconds: 55), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (i < phrase.length) {
        setState(() => _displayed = phrase.substring(0, ++i));
      } else {
        t.cancel();
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) _erase(phrase);
        });
      }
    });
  }

  void _erase(String phrase) {
    _typing = false;
    int i = phrase.length;
    _timer = Timer.periodic(const Duration(milliseconds: 35), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (i > 0) {
        setState(() => _displayed = phrase.substring(0, --i));
      } else {
        t.cancel();
        _phraseIndex++;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) _runNext();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phrase = _queue.isNotEmpty
        ? _queue[_phraseIndex % _queue.length]
        : '';
    final splitIdx = phrase.lastIndexOf(' ');
    final prefix = splitIdx > 0 && _displayed.length > splitIdx
        ? _displayed.substring(0, splitIdx + 1)
        : _displayed;
    final suffix = splitIdx > 0 && _displayed.length > splitIdx
        ? _displayed.substring(splitIdx + 1)
        : '';

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 12, color: widget.textSec),
        children: [
          TextSpan(text: prefix),
          if (suffix.isNotEmpty)
            TextSpan(
              text: suffix,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: widget.accentCol,
              ),
            ),
          TextSpan(
            text: '|',
            style: TextStyle(
              color: _typing ? widget.accentCol : widget.textSec,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
