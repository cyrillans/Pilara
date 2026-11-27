import 'package:flutter/material.dart';

import 'routers/app_router.dart';
import 'services/app_theme_controller.dart';
import 'services/pilala_firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PilalaFirebase.initialize();
  await AppThemeController.instance.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppThemeController.instance,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pilara',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E8E5A),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F9F8),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E8E5A),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF101813),
        ),
        themeMode: AppThemeController.instance.themeMode,
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
