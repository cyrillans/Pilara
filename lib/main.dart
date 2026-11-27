
import 'package:flutter/material.dart';

import 'routers/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/pilala_firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PilalaFirebase.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pilara',

      // Tema baru Pilara 2.0
      theme: AppTheme.lightTheme,

      // Routing lama tetap dipertahankan
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
