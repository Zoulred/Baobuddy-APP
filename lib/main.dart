import 'dart:io' as io show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'providers/Shoppingcard.dart';
import 'providers/PurchaseProducts.dart';
import 'providers/ScanProvider.dart';
import 'providers/ThemeProvider.dart';
import 'providers/UserProvider.dart';
import 'theme/AppThemes.dart';

import 'screens/SplashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      (io.Platform.isWindows || io.Platform.isLinux || io.Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Baobuddy',
              theme: AppThemes.light,
              darkTheme: AppThemes.cyberpunk,
              themeMode: themeProvider.isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              builder: (context, child) => ResponsiveBreakpoints.builder(
                child: child!,
                breakpoints: [
                  const Breakpoint(start: 0, end: 450, name: MOBILE),
                  const Breakpoint(start: 451, end: 800, name: TABLET),
                  const Breakpoint(
                    start: 801,
                    end: double.infinity,
                    name: DESKTOP,
                  ),
                ],
              ),
              home: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
