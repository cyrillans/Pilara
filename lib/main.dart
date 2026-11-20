import 'package:flutter/material.dart';

import 'routers/app_router.dart';
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
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
