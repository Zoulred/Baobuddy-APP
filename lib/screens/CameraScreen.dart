import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';
import '../theme/AppThemes.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isTaking = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_isTaking) return;
    setState(() => _isTaking = true);
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await image.saveTo(imagePath);
      if (!mounted) return;
      Navigator.pop(context, imagePath);
    } catch (e) {
      setState(() => _isTaking = false);
    }
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
      body: SafeArea(
        child: Column(
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
                        boxShadow: shadows,
                      ),
                      child: Icon(Icons.arrow_back_ios_new, size: 18, color: textPri),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Take Photo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPri),
                  ),
                ],
              ),
            ),

            // Camera preview card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardCol,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: shadows,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller);
                      }
                      return Center(
                        child: CircularProgressIndicator(color: accentCol),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Hint text
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                'Point the camera at the product label',
                style: TextStyle(fontSize: 13, color: textSec),
              ),
            ),

            // Capture button
            Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: GestureDetector(
                onTap: _takePicture,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: accentCol,
                    shape: BoxShape.circle,
                    boxShadow: shadows,
                  ),
                  child: _isTaking
                      ? const Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                      : Icon(Icons.camera_alt, color: mode == AppThemeMode.cyberpunk ? Colors.black : Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
