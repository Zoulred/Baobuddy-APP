import 'package:flutter/material.dart';
import '../theme/AppThemes.dart';
import '../providers/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'OnboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 5000), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeProvider>().mode;
    final bgCol = AppThemes.bg(mode);
    final accentCol = AppThemes.accent(mode);
    final textPri = AppThemes.textPrimary(mode);
    final isCyberpunk = mode == AppThemeMode.cyberpunk;

    return Scaffold(
      backgroundColor: bgCol,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo only — no card/border
                Image.asset(
                  'assets/images/Baobuddylogo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 28),

                // App name
                Text(
                  'Baobuddy',
                  style: TextStyle(
                    fontSize: isCyberpunk ? 30 : 32,
                    fontWeight: FontWeight.bold,
                    color: textPri,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Smart Market Budget Tracker',
                  style: TextStyle(
                    fontSize: 13,
                    color: textPri.withValues(alpha: 0.45),
                    letterSpacing: 0.4,
                  ),
                ),

                const SizedBox(height: 56),

                // Loading indicator
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(accentCol),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
