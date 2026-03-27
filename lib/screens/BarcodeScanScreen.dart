import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../models/Scanned.dart';
import '../providers/ScanProvider.dart';
import '../services/APIopenFood.dart';
import '../providers/ThemeProvider.dart';
import '../theme/AppThemes.dart';

class BarcodeScanScreen extends StatefulWidget {
  const BarcodeScanScreen({super.key});

  @override
  State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  bool _isProcessing = false;
  final _scannerController = MobileScannerController();
  late VideoPlayerController _loadingVideoController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    _loadingVideoController = VideoPlayerController.asset(
      'assets/video/vid1.mp4',
    );

    // IMPORTANT: For smooth performance, pre-encode your loading clip with HandBrake/FFmpeg:
    // ffmpeg -i input.mp4 -c:v libx264 -preset slow -crf 28 -vf scale=640:-2 -c:a aac -b:a 96k -movflags +faststart output.mp4
    // Then place output.mp4 in assets and update path in pubspec.
    _loadingVideoController
        .initialize()
        .then((_) {
          _loadingVideoController.setLooping(true);
          _loadingVideoController.setVolume(0);
          if (mounted) setState(() => _videoReady = true);
        })
        .catchError((error) {
          debugPrint('Loading video failed: $error');
          if (mounted) setState(() => _videoReady = false);
        });
  }

  Future<void> _handleBarcode(String code) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    if (_videoReady && _loadingVideoController.value.isInitialized) {
      _loadingVideoController.play();
    }

    final scanProvider = context.read<ScanProvider>();

    try {
      final service = OpenFoodFactsService();
      final product = await service.fetchProduct(code);
      ScannedProduct scanned;

      if (product != null) {
        scanned = product;
      } else {
        scanned = ScannedProduct(
          barcode: code,
          name: 'Unknown Product',
          brand: '',
          categories: '',
          imageUrl: '',
          scannedAt: DateTime.now().toIso8601String(),
        );
      }

      await scanProvider.addScan(scanned);

      if (!mounted) return;
      if (_videoReady && _loadingVideoController.value.isInitialized) {
        _loadingVideoController.pause();
        _loadingVideoController.seekTo(Duration.zero);
      }
      setState(() => _isProcessing = false);
      _showScanResult(scanned);
    } catch (e) {
      if (_videoReady && _loadingVideoController.value.isInitialized) {
        _loadingVideoController.pause();
      }
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch product details: $e')),
        );
      }
    }
  }

  void _showScanResult(ScannedProduct scanned) {
    final mode = context.read<ThemeProvider>().mode;
    final bgCol = AppThemes.bg(mode);
    final cardCol = AppThemes.cardColor(mode);
    final accentCol = AppThemes.accent(mode);
    final textPri = AppThemes.textPrimary(mode);
    final textSec = AppThemes.textSecondary(mode);
    final shadows = AppThemes.shadow(mode);
    final accentSub = AppThemes.accentSubtle(mode);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: cardCol,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: shadows,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              20 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: textSec.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Success indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: accentCol.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: accentCol.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: accentCol, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Product Found!',
                        style: TextStyle(
                          color: accentCol,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Product image with enhanced styling
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: accentCol.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: scanned.imageUrl.isNotEmpty
                        ? Image.network(
                            scanned.imageUrl,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: accentSub,
                              child: Icon(
                                Icons.image_not_supported,
                                color: accentCol,
                                size: 50,
                              ),
                            ),
                          )
                        : Container(
                            color: accentSub,
                            child: Icon(
                              Icons.qr_code,
                              color: accentCol,
                              size: 60,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Product header with name and brand
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgCol,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: accentCol.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Text(
                        scanned.name.isNotEmpty
                            ? scanned.name
                            : 'Unknown Product',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textPri,
                          height: 1.2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      const SizedBox(height: 6),

                      // Brand with icon
                      if (scanned.brand.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.business, size: 16, color: accentCol),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                scanned.brand,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textSec,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Categories with enhanced styling
                      if (scanned.categories.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: accentCol.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: accentCol.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.category, size: 14, color: accentCol),
                              const SizedBox(width: 6),
                              Text(
                                scanned.categories,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: accentCol,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Barcode info with enhanced styling
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bgCol,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: accentCol.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentCol.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.qr_code_scanner,
                          size: 20,
                          color: accentCol,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Barcode',
                              style: TextStyle(
                                fontSize: 11,
                                color: textSec,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              scanned.barcode,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textPri,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Copy barcode to clipboard
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Barcode copied: ${scanned.barcode}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(Icons.copy, size: 18, color: textSec),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Ingredients section with enhanced styling
                if (scanned.ingredients.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgCol,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: accentCol.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF4CAF50,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.receipt_long,
                                size: 18,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Ingredients',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPri,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardCol,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: textSec.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            scanned.ingredients,
                            style: TextStyle(
                              fontSize: 13,
                              color: textSec,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Nutrition Facts section with enhanced styling
                if (scanned.nutritionFacts.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgCol,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: accentCol.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFF9800,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.restaurant_menu,
                                size: 18,
                                color: Color(0xFFFF9800),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Nutrition Facts (per 100g)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPri,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardCol,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: textSec.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            scanned.nutritionFacts,
                            style: TextStyle(
                              fontSize: 13,
                              color: textSec,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentSub,
                          foregroundColor: accentCol,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Scan Again',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentCol,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _loadingVideoController.dispose();
    super.dispose();
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

    final List<Widget> stackChildren = [
      Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan Barcode',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textPri,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isProcessing ? 'Processing…' : 'Point at a barcode',
                        style: TextStyle(fontSize: 12, color: textSec),
                      ),
                    ],
                  ),
                ),
                if (_isProcessing)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(accentCol),
                      strokeWidth: 2,
                    ),
                  ),
              ],
            ),
          ),

          // Scanner area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: cardCol,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: accentCol.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: shadows,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: MobileScanner(
                      controller: _scannerController,
                      fit: BoxFit.cover,
                      onDetect: (capture) {
                        if (_isProcessing) return;
                        final barcodes = capture.barcodes;
                        if (barcodes.isNotEmpty) {
                          final value = barcodes.first.rawValue;
                          if (value != null && value.isNotEmpty) {
                            _handleBarcode(value);
                          }
                        }
                      },
                    ),
                  ),
                  // Scanner guides (corner marks)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: accentCol, width: 3),
                          left: BorderSide(color: accentCol, width: 3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: accentCol, width: 3),
                          right: BorderSide(color: accentCol, width: 3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: accentCol, width: 3),
                          left: BorderSide(color: accentCol, width: 3),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: accentCol, width: 3),
                          right: BorderSide(color: accentCol, width: 3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hint text
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              '📱 Hold still for best results',
              style: TextStyle(
                fontSize: 13,
                color: textSec,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      if (_isProcessing)
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_videoReady && _loadingVideoController.value.isInitialized)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: AspectRatio(
                        aspectRatio:
                            _loadingVideoController.value.aspectRatio > 0
                            ? _loadingVideoController.value.aspectRatio
                            : 1,
                        child: VideoPlayer(_loadingVideoController),
                      ),
                    ),
                  )
                else
                  const CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  'Fetching product...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
    ];

    return Scaffold(
      backgroundColor: bgCol,
      body: SafeArea(child: Stack(children: stackChildren)),
    );
  }
}
