import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  GoogleAuthService._();

  static final instance = GoogleAuthService._();
  static Future<void>? _googleSignInInitialization;

  Future<String> signInAndGetFirebaseIdToken() async {
    final existingUser = FirebaseAuth.instance.currentUser;
    if (existingUser != null) {
      final existingToken = await existingUser.getIdToken(true);
      if (existingToken != null && existingToken.isNotEmpty) {
        return existingToken;
      }
    }

    await _ensureGoogleSignInInitialized();
    final googleAccount = await GoogleSignIn.instance.authenticate();
    final googleIdToken = googleAccount.authentication.idToken;
    if (googleIdToken == null || googleIdToken.isEmpty) {
      throw const GoogleAuthFlowException(
        'Google tidak mengembalikan token identitas.',
      );
    }

    final credential = GoogleAuthProvider.credential(idToken: googleIdToken);
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    final firebaseIdToken = await userCredential.user?.getIdToken(true);
    if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
      throw const GoogleAuthFlowException(
        'Firebase tidak mengembalikan token identitas.',
      );
    }
    return firebaseIdToken;
  }

  Future<void> signOut() async {
    if (Firebase.apps.isEmpty) return;
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }
    await _ensureGoogleSignInInitialized();
    await GoogleSignIn.instance.signOut();
  }

  Future<void> _ensureGoogleSignInInitialized() =>
      _googleSignInInitialization ??= GoogleSignIn.instance.initialize();
}

class GoogleAuthFlowException implements Exception {
  const GoogleAuthFlowException(this.message);

  final String message;

  @override
  String toString() => message;
}
