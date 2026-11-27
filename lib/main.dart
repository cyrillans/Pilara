import 'package:flutter/material.dart';
import 'routers/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilara',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF1E8E5A),
        scaffoldBackgroundColor: const Color(0xFFF7F9F8),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E8E5A)),
      ),
    );
  }
}