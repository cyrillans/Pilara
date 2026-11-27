
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../routers/app_router.dart';

// ============================================================
// GLOBAL STORES
// ============================================================

class MockProgressStore extends ChangeNotifier {
  int get completedTutorials => 3;
  int get totalPoints => 1250;
  int get currentLevel => 3;
  int get streakDays => 5;
}

final mockProgressStore = MockProgressStore();

class AppSettingsStore extends ChangeNotifier {
  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  void setNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }
}

final appSettingsStore = AppSettingsStore();

class ProfileStore extends ChangeNotifier {
  String _name = 'Cyrilla';
  String _bio = 'Eco Enthusiast 🌱';
  String _email = 'cyrilla@email.com';
  String? _imagePath;
  String? _savedLocation;

  String get name => _name;
  String get bio => _bio;
  String get email => _email;
  String? get imagePath => _imagePath;
  String? get savedLocation => _savedLocation;

  void updateProfile({
    String? name,
    String? bio,
    String? imagePath,
  }) {
    if (name != null) _name = name;
    if (bio != null) _bio = bio;
    if (imagePath != null) _imagePath = imagePath;

    notifyListeners();
  }

  void updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setSavedLocation(String? location) {
    _savedLocation = location;
    notifyListeners();
  }
}

final profileStore = ProfileStore();

// ============================================================
// PROFILE SCREEN
// ============================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primary = Color(0xFF1E8E5A);
  static const Color bgColor = Color(0xFFF7F9F8);
  static const Color textColor = Color(0xFF17231D);
  static const Color subTextColor = Color(0xFF7A847E);
  static const Color lineColor = Color(0xFFE5EAE7);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        profileStore,
        appSettingsStore,
        mockProgressStore,
      ]),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(context),

                  const SizedBox(height: 28),

                  _sectionTitle('Pengaturan Akun'),
                  const SizedBox(height: 12),
                  _buildAccountSection(context),

                  const SizedBox(height: 26),

                  _sectionTitle('Bantuan & Dukungan'),
                  const SizedBox(height: 12),
                  _buildSupportSection(context),

                  const SizedBox(height: 26),

                  _sectionTitle('Informasi'),
                  const SizedBox(height: 12),
                  _buildAboutSection(context),

                  const SizedBox(height: 28),

                  _buildLogoutButton(context),

                  const SizedBox(height: 22),

                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Pilara',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: subTextColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Versi 2.0.0',
                          style: TextStyle(
                            fontSize: 10,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: lineColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _profileAvatar(radius: 38),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileStore.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      profileStore.bio,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: subTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: primary,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Akun Pilara',
                          style: TextStyle(
                            fontSize: 11,
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () => _openEditProfile(context),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: primary,
                ),
                tooltip: 'Edit profil',
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1, color: lineColor),
          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _profileStat(
                  Icons.school_rounded,
                  '${mockProgressStore.completedTutorials}',
                  'Tutorial',
                ),
              ),
              Container(width: 1, height: 38, color: lineColor),
              Expanded(
                child: _profileStat(
                  Icons.stars_rounded,
                  '${mockProgressStore.totalPoints}',
                  'Total Poin',
                ),
              ),
              Container(width: 1, height: 38, color: lineColor),
              Expanded(
                child: _profileStat(
                  Icons.local_fire_department_rounded,
                  '${mockProgressStore.streakDays} hari',
                  'Streak',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileAvatar({double radius = 24}) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: const Color(0xFFE4F5EC),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFBFE4CE),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: profileStore.imagePath != null
            ? Image.file(
                File(profileStore.imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person_rounded,
                  size: radius,
                  color: primary,
                ),
              )
            : Icon(
                Icons.person_rounded,
                size: radius,
                color: primary,
              ),
      ),
    );
  }

  Widget _profileStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 19, color: primary),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: subTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
    );
  }

  // ============================================================
  // ACCOUNT SECTION
  // ============================================================

  Widget _buildAccountSection(BuildContext context) {
    return _menuContainer([
      _menuItem(
        icon: Icons.person_outline_rounded,
        iconBg: const Color(0xFFE8F5ED),
        iconColor: primary,
        title: 'Edit Profil',
        subtitle: 'Nama panggilan, bio, dan foto',
        onTap: () => _openEditProfile(context),
      ),
      _divider(),
      _menuItem(
        icon: Icons.g_mobiledata_rounded,
        iconBg: const Color(0xFFEAF1FB),
        iconColor: const Color(0xFF4A78B8),
        title: 'Akun Google',
        subtitle: profileStore.email,
        onTap: () => _showGoogleAccount(context),
      ),
      _divider(),
      _menuItem(
        icon: Icons.location_on_outlined,
        iconBg: const Color(0xFFFFF1E3),
        iconColor: const Color(0xFFE38A25),
        title: 'Lokasi Setor',
        subtitle: profileStore.savedLocation ?? 'Belum diatur',
        onTap: () => _openSavedLocation(context),
      ),
      _divider(),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 13,
        ),
        child: Row(
          children: [
            _iconBox(
              Icons.notifications_none_rounded,
              const Color(0xFFFFF4DD),
              const Color(0xFFE3A11B),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifikasi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Pengingat dan update aktivitas',
                    style: TextStyle(
                      fontSize: 10,
                      color: subTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: appSettingsStore.notificationsEnabled,
              activeColor: primary,
              onChanged: appSettingsStore.setNotifications,
            ),
          ],
        ),
      ),
    ]);
  }

  void _showGoogleAccount(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _BaseSheet(
          title: 'Akun Google',
          subtitle: 'Identitas akun yang terhubung dengan Pilara.',
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F9F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.email_outlined, color: primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      profileStore.email,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.verified_rounded,
                    color: primary,
                    size: 18,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Email berasal dari akun Google yang digunakan saat masuk. '
              'Untuk menggunakan email berbeda, masuk kembali dengan akun Google lain.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: subTextColor,
              ),
            ),
          ],
          footer: _primaryButton(
            'Mengerti',
            () => Navigator.pop(sheetContext),
          ),
        );
      },
    );
  }

  // ============================================================
  // SUPPORT SECTION
  // ============================================================

  Widget _buildSupportSection(BuildContext context) {
    return _menuContainer([
      _menuItem(
        icon: Icons.help_outline_rounded,
        iconBg: const Color(0xFFEAF4FB),
        iconColor: const Color(0xFF4D87A9),
        title: 'Pusat Bantuan',
        subtitle: 'FAQ dan kontak',
        onTap: () => _openHelpCenter(context),
      ),
      _divider(),
      _menuItem(
        icon: Icons.rate_review_outlined,
        iconBg: const Color(0xFFFDEEF4),
        iconColor: const Color(0xFFC9588A),
        title: 'Beri Masukan',
        subtitle: 'Saran, laporan masalah, dan penilaian',
        onTap: () => _openFeedback(context),
      ),
      _divider(),
      _menuItem(
        icon: Icons.share_outlined,
        iconBg: const Color(0xFFE9F2F8),
        iconColor: const Color(0xFF4B829E),
        title: 'Bagikan Pilara',
        subtitle: 'Ajak teman ikut memilah sampah',
        onTap: () => _shareApp(context),
      ),
    ]);
  }

  // ============================================================
  // ABOUT SECTION
  // ============================================================

  Widget _buildAboutSection(BuildContext context) {
    return _menuContainer([
      _menuItem(
        icon: Icons.shield_outlined,
        iconBg: const Color(0xFFEFF3EC),
        iconColor: const Color(0xFF61795D),
        title: 'Privasi & Keamanan',
        subtitle: 'Informasi data dan keamanan',
        onTap: () => _openPrivacy(context),
      ),
      _divider(),
      _menuItem(
        icon: Icons.description_outlined,
        iconBg: const Color(0xFFF0ECF9),
        iconColor: const Color(0xFF7862A7),
        title: 'Syarat & Ketentuan',
        subtitle: 'Aturan penggunaan aplikasi',
        onTap: () => _openTerms(context),
      ),
      _divider(),
      _menuItem(
        icon: Icons.info_outline_rounded,
        iconBg: const Color(0xFFF0F0F0),
        iconColor: const Color(0xFF6E746F),
        title: 'Tentang Pilara',
        subtitle: 'Informasi aplikasi',
        onTap: () => _openAbout(context),
      ),
    ]);
  }

  // ============================================================
  // REUSABLE MENU COMPONENTS
  // ============================================================

  Widget _menuContainer(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: lineColor),
      ),
      child: Column(children: children),
    );
  }

  Widget _iconBox(IconData icon, Color bg, Color color) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: color, size: 21),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 13,
        ),
        child: Row(
          children: [
            _iconBox(icon, iconBg, iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8A948E),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFABB3AE),
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(left: 69),
      child: Divider(height: 1, color: lineColor),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () => _showLogoutDialog(context),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF2F2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFFDDDD)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              size: 19,
              color: Color(0xFFD9534F),
            ),
            SizedBox(width: 8),
            Text(
              'Keluar dari Akun',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFFD9534F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23),
        ),
        title: const Text(
          'Keluar dari akun?',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'Kamu perlu masuk kembali untuk mengakses akun Pilara.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Batal',
              style: TextStyle(color: subTextColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.signin,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9534F),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OPEN SHEETS
  // ============================================================

  void _openEditProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditProfileSheet(),
    );
  }

  void _openSavedLocation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SavedLocationSheet(),
    );
  }

  void _openHelpCenter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const HelpCenterSheet(),
    );
  }

  void _openFeedback(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FeedbackSheet(),
    );
  }

  void _openPrivacy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PrivacySheet(),
    );
  }

  void _openTerms(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TermsSheet(),
    );
  }

  void _openAbout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AboutSheet(),
    );
  }

  void _shareApp(BuildContext context) {
    Clipboard.setData(
      const ClipboardData(
        text: 'Yuk pilah sampah bareng Pilara!',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Teks ajakan Pilara berhasil disalin'),
      ),
    );
  }
}

// ============================================================
// EDIT PROFILE SHEET
// ============================================================

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;

  final ImagePicker _picker = ImagePicker();

  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: profileStore.name);
    _bioController = TextEditingController(text: profileStore.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;

    setState(() => _isPickingImage = true);

    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (image != null && mounted) {
        profileStore.updateProfile(imagePath: image.path);
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil foto dari galeri'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  void _saveProfile() {
    final name = _nameController.text.trim();
    final bio = _bioController.text.trim();

    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama minimal 2 karakter'),
        ),
      );
      return;
    }

    profileStore.updateProfile(
      name: name,
      bio: bio,
    );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil diperbarui'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      title: 'Edit Profil',
      subtitle: 'Perbarui informasi profil kamu.',
      children: [
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE4F5EC),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: profileStore.imagePath != null
                            ? Image.file(
                                File(profileStore.imagePath!),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(
                                  Icons.person_rounded,
                                  size: 50,
                                  color: Color(0xFF1E8E5A),
                                ),
                              )
                            : const Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: Color(0xFF1E8E5A),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E8E5A),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: _isPickingImage
                            ? const Padding(
                                padding: EdgeInsets.all(7),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _isPickingImage ? null : _pickImage,
                child: const Text(
                  'Ubah Foto Profil',
                  style: TextStyle(
                    color: Color(0xFF1E8E5A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _FieldLabel('Nama Panggilan'),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          maxLength: 30,
          decoration: _inputDecoration(
            'Masukkan nama panggilan',
            Icons.person_outline,
          ).copyWith(counterText: ''),
        ),
        const SizedBox(height: 16),
        const _FieldLabel('Bio'),
        const SizedBox(height: 8),
        TextField(
          controller: _bioController,
          maxLength: 60,
          decoration: _inputDecoration(
            'Ceritakan sedikit tentang dirimu',
            Icons.eco_outlined,
          ).copyWith(counterText: ''),
        ),
      ],
      footer: _primaryButton('Simpan Perubahan', _saveProfile),
    );
  }
}

// ============================================================
// SAVED LOCATION SHEET
// ============================================================

class SavedLocationSheet extends StatefulWidget {
  const SavedLocationSheet({super.key});

  @override
  State<SavedLocationSheet> createState() => _SavedLocationSheetState();
}

class _SavedLocationSheetState extends State<SavedLocationSheet> {
  final List<String> locations = [
    'Bank Sampah Melati (Jakarta Selatan)',
    'Titik Pilah Komunitas (Bandung)',
    'TPS3R Sukamaju (Depok)',
  ];

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      title: 'Lokasi Setor',
      subtitle: 'Pilih lokasi setor sampah pilihanmu.',
      children: [
        if (profileStore.savedLocation != null) ...[
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6EF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF1E8E5A),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    profileStore.savedLocation!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    profileStore.setSavedLocation(null);
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
        ],
        const _FieldLabel('Pilih dari daftar'),
        const SizedBox(height: 8),
        ...locations.map(
          (location) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF1E8E5A),
            ),
            title: Text(
              location,
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              profileStore.setSavedLocation(location);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================
// HELP CENTER
// ============================================================

class HelpCenterSheet extends StatelessWidget {
  const HelpCenterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      title: 'Pusat Bantuan',
      subtitle: 'Temukan jawaban dari pertanyaan umum.',
      maxHeight: 0.85,
      children: const [
        _FaqItem(
          question: 'Bagaimana cara memilah sampah?',
          answer:
              'Buka menu Belajar, pilih tutorial yang sesuai, dan ikuti langkah-langkahnya.',
        ),
        _FaqItem(
          question: 'Apa itu Poin Pilara?',
          answer:
              'Poin didapat dari menyelesaikan tutorial dan tantangan.',
        ),
        _FaqItem(
          question: 'Kenapa lokasi saya tidak terdeteksi?',
          answer:
              'Pastikan izin lokasi di HP sudah aktif dan koneksi internet stabil.',
        ),
        Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.email_outlined, color: Colors.blue),
          title: Text('Email Bantuan'),
          subtitle: Text('support@pilara.id'),
        ),
      ],
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Text(
            answer,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF7A847E),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// FEEDBACK SHEET
// ============================================================

class FeedbackSheet extends StatefulWidget {
  const FeedbackSheet({super.key});

  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet> {
  final TextEditingController controller = TextEditingController();

  final categories = ['Saran', 'Laporkan Masalah', 'Lainnya'];

  String category = 'Saran';
  int rating = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      title: 'Beri Masukan',
      subtitle: 'Bantu kami membuat Pilara lebih baik.',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              onPressed: () => setState(() => rating = index + 1),
              icon: Icon(
                index < rating
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                size: 32,
                color: const Color(0xFFE3A11B),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        const _FieldLabel('Kategori'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: categories.map((item) {
            return ChoiceChip(
              label: Text(item),
              selected: category == item,
              selectedColor: const Color(0xFFE4F5EC),
              onSelected: (_) => setState(() => category = item),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: _inputDecoration(
            'Tulis masukanmu di sini...',
            Icons.edit_outlined,
          ),
        ),
      ],
      footer: _primaryButton(
        'Kirim Masukan',
        () {
          if (controller.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tuliskan masukan terlebih dahulu'),
              ),
            );
            return;
          }

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Terima kasih atas masukanmu!'),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// PRIVACY SHEET
// ============================================================

class PrivacySheet extends StatelessWidget {
  const PrivacySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      title: 'Privasi & Keamanan',
      subtitle: 'Cara Pilara menjaga data kamu.',
      maxHeight: 0.85,
      children: const [
        _InfoSection(
          title: 'Data yang kami kumpulkan',
          body:
              'Nama, bio, email, foto profil, lokasi setor yang kamu simpan, serta progres belajar seperti tutorial selesai dan poin.',
        ),
        _InfoSection(
          title: 'Penggunaan data',
          body:
              'Data digunakan untuk menjalankan fitur aplikasi, menampilkan titik pilah terdekat, dan menyimpan progres kamu.',
        ),
        _InfoSection(
          title: 'Izin aplikasi',
          body:
              'Lokasi digunakan untuk menampilkan titik pilah terdekat. Kamera dan galeri digunakan untuk fitur pemindaian dan foto profil.',
        ),
        _InfoSection(
          title: 'Keamanan akun',
          body:
              'Akun masuk menggunakan Google. Jangan membagikan akses akun Google kepada orang lain.',
        ),
      ],
      footer: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur penghapusan akun belum tersedia'),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          minimumSize: const Size(double.infinity, 50),
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text('Hapus Akun'),
      ),
    );
  }
}

// ============================================================
// TERMS SHEET
// ============================================================

class TermsSheet extends StatelessWidget {
  const TermsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      title: 'Syarat & Ketentuan',
      subtitle: 'Terakhir diperbarui: November 2026',
      maxHeight: 0.85,
      children: const [
        _InfoSection(
          title: '1. Penerimaan syarat',
          body:
              'Dengan menggunakan Pilara, kamu menyetujui syarat dan ketentuan penggunaan aplikasi.',
        ),
        _InfoSection(
          title: '2. Tujuan aplikasi',
          body:
              'Pilara merupakan aplikasi edukasi untuk membantu pengguna mengenali, memilah, dan mengelola sampah.',
        ),
        _InfoSection(
          title: '3. Akun pengguna',
          body:
              'Pengguna bertanggung jawab atas keamanan akun Google yang digunakan untuk masuk.',
        ),
        _InfoSection(
          title: '4. Poin dan level',
          body:
              'Poin didapat dari menyelesaikan tutorial dan tantangan. Poin tidak memiliki nilai uang.',
        ),
        _InfoSection(
          title: '5. Larangan',
          body:
              'Pengguna tidak diperkenankan menyalahgunakan aplikasi untuk tujuan yang melanggar hukum.',
        ),
        _InfoSection(
          title: '6. Perubahan syarat',
          body:
              'Syarat dan ketentuan dapat diperbarui sewaktu-waktu.',
        ),
        _InfoSection(
          title: '7. Kontak',
          body: 'support@pilara.id',
        ),
      ],
      footer: _primaryButton(
        'Saya Mengerti',
        () => Navigator.pop(context),
      ),
    );
  }
}

// ============================================================
// ABOUT SHEET
// ============================================================

class AboutSheet extends StatelessWidget {
  const AboutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      title: 'Tentang Pilara',
      maxHeight: 0.85,
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F5EC),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  size: 42,
                  color: Color(0xFF1E8E5A),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Pilara',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Versi 2.0.0',
                style: TextStyle(
                  color: Color(0xFF1E8E5A),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const _InfoSection(
          title: 'Apa itu Pilara?',
          body:
              'Pilara membantu kamu mengenali, memilah, dan mengelola sampah dengan mudah sekaligus membangun kebiasaan ramah lingkungan.',
        ),
        const _InfoSection(
          title: 'Fitur utama',
          body:
              '• Pindai sampah lewat kamera\n'
              '• Panduan memilah sampah\n'
              '• Tutorial belajar dengan poin dan level\n'
              '• Riwayat pilah\n'
              '• Artikel seputar lingkungan\n'
              '• Lokasi setor terdekat',
        ),
        const _InfoSection(
          title: 'Tim pengembang',
          body: 'Dibuat dengan penuh semangat oleh Tim Pilara.',
        ),
        const Center(
          child: Text(
            '© 2026 Pilara. Seluruh hak dilindungi.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF7A847E),
            ),
          ),
        ),
      ],
      footer: _primaryButton(
        'Tutup',
        () => Navigator.pop(context),
      ),
    );
  }
}

// ============================================================
// REUSABLE SHEET COMPONENTS
// ============================================================

class _BaseSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? footer;
  final double maxHeight;

  const _BaseSheet({
    required this.title,
    required this.children,
    this.subtitle,
    this.footer,
    this.maxHeight = 0.88,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * maxHeight,
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetHandle(),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF17231D),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 5),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF7A847E),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
          if (footer != null) ...[
            const SizedBox(height: 15),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF17231D),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String body;

  const _InfoSection({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF17231D),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              fontSize: 12,
              height: 1.55,
              color: Color(0xFF5E6963),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// COMMON INPUT & BUTTON
// ============================================================

InputDecoration _inputDecoration(String hint, IconData icon) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(
      icon,
      color: const Color(0xFF1E8E5A),
    ),
    filled: true,
    fillColor: const Color(0xFFF4F9F6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFF1E8E5A),
        width: 1.3,
      ),
    ),
  );
}

Widget _primaryButton(String text, VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E8E5A),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
