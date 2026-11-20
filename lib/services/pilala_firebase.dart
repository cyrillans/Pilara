import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PilalaFirebase {
  PilalaFirebase._();

  static Future<void>? _initialization;
  static String? _initializationError;

  static String? get initializationError => _initializationError;

  static Future<void> initialize() =>
      _initialization ??= _initialize();

  static Future<void> _initialize() async {
    final isAndroid = !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android;
    final isApple = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS);

    if (!isAndroid && !isApple) {
      _initializationError =
          'Pilala AI saat ini tersedia di Android, iOS, dan macOS.';
      return;
    }

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      await FirebaseAppCheck.instance.activate(
        providerAndroid: kDebugMode
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider(),
        providerApple: kDebugMode
            ? const AppleDebugProvider()
            : const AppleAppAttestWithDeviceCheckFallbackProvider(),
      );
    } on FirebaseException catch (error) {
      _initializationError =
          'Firebase belum siap: ${error.message ?? error.code}. '
          'Jalankan flutterfire configure dan pastikan Firebase AI Logic '
          'diaktifkan di Firebase Console.';
    } on PlatformException catch (error) {
      _initializationError =
          'Firebase belum siap: ${error.message ?? error.code}. '
          'Periksa konfigurasi Firebase untuk platform ini.';
    }
  }

  static void requireReady() {
    if (_initializationError case final error?) {
      throw PilalaConfigurationException(error);
    }
    if (Firebase.apps.isEmpty) {
      throw const PilalaConfigurationException(
        'Firebase belum diinisialisasi.',
      );
    }
  }
}

class PilalaConfigurationException implements Exception {
  const PilalaConfigurationException(this.message);

  final String message;

  @override
  String toString() => message;
}
