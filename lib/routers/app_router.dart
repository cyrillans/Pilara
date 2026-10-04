import 'package:flutter/material.dart';

import '../data/dummy_articles.dart';

import '../screens/splash_screen.dart';
import '../screens/signin_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/camera_screen.dart';
import '../screens/pilah_screen.dart';
import '../screens/riwayat_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/articles_screen.dart';
import '../screens/article_detail_screen.dart';

class AppRouter {
  // ============================================================
  // ROUTE
  // ============================================================
  static const String splash = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String camera = '/camera';
  static const String pilah = '/pilah';
  static const String riwayat = '/riwayat';
  static const String profile = '/profile';
  static const String detail = '/detail';

  // ============================================================
  // ARTIKEL
  // ============================================================
  static const String articles = '/articles';
  static const String articleDetail = '/article-detail';

  // ============================================================
  // GENERATE ROUTE
  // ============================================================
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      // ========================================================
      // SPLASH
      // ========================================================

      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      // ========================================================
      // SIGN IN
      // ========================================================

      case signin:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        );

      // ========================================================
      // SIGN UP
      // ========================================================

      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );

      // ========================================================
      // HOME
      // ========================================================

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      // ========================================================
      // CAMERA
      // ========================================================

      case camera:
        return MaterialPageRoute(
          builder: (_) => const CameraScreen(),
        );

      // ========================================================
      // PILAH
      // ========================================================

      case pilah:
        return MaterialPageRoute(
          builder: (_) => const PilahScreen(),
        );

      // ========================================================
      // RIWAYAT
      // ========================================================

      case riwayat:
        return MaterialPageRoute(
          builder: (_) => const RiwayatScreen(),
        );

      // ========================================================
      // PROFILE
      // ========================================================

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );

      // ========================================================
      // DETAIL SAMPAH
      // ========================================================

      case detail:
        return MaterialPageRoute(
          builder: (_) => const DetailScreen(),
        );

      // ========================================================
      // SEMUA ARTIKEL
      // ========================================================

      case articles:
        return MaterialPageRoute(
          builder: (_) => const ArticlesScreen(),
        );

      // ========================================================
      // DETAIL ARTIKEL
      // ========================================================

      case articleDetail:
        final article = settings.arguments as Article;

        return MaterialPageRoute(
          builder: (_) => ArticleDetailScreen(
            article: article,
          ),
        );

      // ========================================================
      // DEFAULT
      // ========================================================

      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}