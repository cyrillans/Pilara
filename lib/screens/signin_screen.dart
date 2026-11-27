
import 'package:flutter/material.dart';
import 'home_screen.dart';

// ======================================================
// PALET WARNA PILARA
// ======================================================

const Color _kPrimaryGreen = Color(0xFF1B5E3A);
const Color _kSageBg = Color(0xFFF4F9F6);
const Color _kBorderColor = Color(0xFFE0EAE3);
const Color _kDarkText = Color(0xFF1F2A24);
const Color _kMutedText = Color(0xFF6B7A72);
const Color _kGoogleRed = Color(0xFFDB4437);

// ======================================================
// SIGN IN SCREEN
// ======================================================

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  void _continueWithGoogle(BuildContext context) {
    // PROTOTIPE:
    // Untuk sementara, tombol Google langsung menuju
    // halaman pengisian nama panggilan.
    //
    // Nantinya bagian ini diganti dengan Google Sign-In
    // menggunakan Firebase Authentication.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CompleteProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO
                Image.asset(
                  'assets/images/LogoPilara.png',
                  height: 105,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: _kSageBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.eco_rounded,
                        size: 55,
                        color: _kPrimaryGreen,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                const Text(
                  'Selamat Datang di Pilara',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: _kDarkText,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Mulai langkah kecil untuk bumi yang lebih baik.\n'
                  'Kelola sampah, pelajari kebiasaan baik,\n'
                  'dan ciptakan perubahan bersama Pilara.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: _kMutedText,
                  ),
                ),

                const SizedBox(height: 42),

                // GOOGLE SIGN IN
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () => _continueWithGoogle(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: _kBorderColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'G',
                          style: TextStyle(
                            color: _kGoogleRed,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Lanjutkan dengan Google',
                          style: TextStyle(
                            color: _kDarkText,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Dengan melanjutkan, kamu dapat mulai '
                  'berkontribusi bersama Pilara.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: _kMutedText,
                  ),
                ),

                const SizedBox(height: 55),

                const Text(
                  'PILARA • Peduli Lingkungan, Mulai dari Kita',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: _kMutedText,
                    fontWeight: FontWeight.w500,
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

// ======================================================
// COMPLETE PROFILE SCREEN
// ======================================================

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _continueToHome() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // PROTOTIPE:
    // Nantinya nama panggilan dan data akun Google
    // disimpan ke database.

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: _kDarkText,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 25),

                // ICON
                Center(
                  child: Container(
                    height: 85,
                    width: 85,
                    decoration: BoxDecoration(
                      color: _kSageBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      size: 45,
                      color: _kPrimaryGreen,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Kenalan Dulu, Yuk!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: _kDarkText,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Bagaimana kami bisa memanggilmu?\n'
                  'Masukkan nama panggilan yang kamu sukai.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: _kMutedText,
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  'Nama Panggilan',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: _kDarkText,
                  ),
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _nicknameController,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 20,
                  decoration: InputDecoration(
                    hintText: 'Contoh: Rara',
                    counterText: '',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: _kPrimaryGreen,
                    ),
                    filled: true,
                    fillColor: _kSageBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: _kBorderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: _kPrimaryGreen,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama panggilan tidak boleh kosong';
                    }

                    if (value.trim().length < 2) {
                      return 'Nama minimal 2 karakter';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _continueToHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 23,
                            width: 23,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Mulai Menggunakan Pilara',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Kamu bisa mulai menjelajahi Pilara '
                  'dan membangun kebiasaan ramah lingkungan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: _kMutedText,
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
