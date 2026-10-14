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
  static const String splash = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String camera = '/camera';
  static const String pilah = '/pilah';
  static const String riwayat = '/riwayat';
  static const String profile = '/profile';
  static const String detail = '/detail';
  static const String articles = '/articles';
  static const String articleDetail = '/article-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case signin:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SignInScreen(),
        );

      case signup:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SignUpScreen(),
        );

      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );

      case camera:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CameraScreen(),
        );

      case pilah:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PilahScreen(),
        );

      case riwayat:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RiwayatScreen(),
        );

      case profile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );

      case detail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const DetailScreen(),
        );

      case articles:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ArticlesScreen(),
        );

      case articleDetail:
        final article = settings.arguments;

        if (article is! Article) {
          return MaterialPageRoute(
            builder: (_) => const ArticlesScreen(),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ArticleDetailScreen(
            article: article,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}