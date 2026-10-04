import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 24),

              _buildProfileCard(),

              const SizedBox(height: 26),

              _buildSectionTitle('Akun'),

              const SizedBox(height: 10),

              _buildAccountSection(),

              const SizedBox(height: 24),

              _buildSectionTitle('Preferensi'),

              const SizedBox(height: 10),

              _buildPreferenceSection(),

              const SizedBox(height: 24),

              _buildSectionTitle('Bantuan & Informasi'),

              const SizedBox(height: 10),

              _buildHelpSection(),

              const SizedBox(height: 26),

              _buildLogoutButton(),

              const SizedBox(height: 18),

              Center(
                child: Column(
                  children: [
                    Text(
                      'Pilara',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Versi 1.0.0',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
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
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF17231D),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Kelola akun dan preferensi kamu',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7A847E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE5EAE7),
            ),
          ),
          child: const Icon(
            Icons.settings_outlined,
            color: Color(0xFF33453B),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFE5EAE7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4F5EC),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFBFE4CE),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 39,
                      color: Color(0xFF1E8E5A),
                    ),
                  ),

                  Positioned(
                    right: 0,
                    bottom: 1,
                    child: Container(
                      width: 23,
                      height: 23,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E8E5A),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        size: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 15),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cyrilla',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17231D),
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'Eco Enthusiast 🌱',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF68736D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 7),

                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 13,
                          color: Color(0xFF8A948E),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'cyrilla@email.com',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF8A948E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            height: 1,
            color: const Color(0xFFEEF1EF),
          ),

          const SizedBox(height: 17),

          Row(
            children: [
              Expanded(
                child: _profileStat(
                  icon: Icons.stars_rounded,
                  value: '1.250',
                  label: 'Poin',
                ),
              ),

              Container(
                width: 1,
                height: 38,
                color: const Color(0xFFE8ECE9),
              ),

              Expanded(
                child: _profileStat(
                  icon: Icons.workspace_premium_rounded,
                  value: 'Level 3',
                  label: 'Level',
                ),
              ),

              Container(
                width: 1,
                height: 38,
                color: const Color(0xFFE8ECE9),
              ),

              Expanded(
                child: _profileStat(
                  icon: Icons.local_fire_department_rounded,
                  value: '5 hari',
                  label: 'Streak',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE STAT
  // ============================================================

  Widget _profileStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 19,
          color: const Color(0xFF1E8E5A),
        ),

        const SizedBox(height: 6),

        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF17231D),
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Color(0xFF17231D),
      ),
    );
  }

  // ============================================================
  // ACCOUNT
  // ============================================================

  Widget _buildAccountSection() {
    return _buildMenuContainer(
      children: [
        _buildMenuItem(
          icon: Icons.person_outline_rounded,
          iconBackground: const Color(0xFFE8F5ED),
          iconColor: const Color(0xFF1E8E5A),
          title: 'Edit Profil',
          subtitle: 'Nama, foto, dan informasi akun',
          onTap: () {
            _showComingSoon('Edit Profil');
          },
        ),

        _buildDivider(),

        _buildMenuItem(
          icon: Icons.email_outlined,
          iconBackground: const Color(0xFFEAF1FB),
          iconColor: const Color(0xFF4A78B8),
          title: 'Email & Akun',
          subtitle: 'Kelola informasi login',
          onTap: () {
            _showComingSoon('Email & Akun');
          },
        ),

        _buildDivider(),

        _buildMenuItem(
          icon: Icons.location_on_outlined,
          iconBackground: const Color(0xFFFFF1E3),
          iconColor: const Color(0xFFE38A25),
          title: 'Lokasi Setor',
          subtitle: 'Atur lokasi pengelolaan sampah',
          onTap: () {
            _showComingSoon('Lokasi Setor');
          },
        ),
      ],
    );
  }

  // ============================================================
  // PREFERENSI
  // ============================================================

  Widget _buildPreferenceSection() {
    return _buildMenuContainer(
      children: [
        _buildNotificationItem(),

        _buildDivider(),

        _buildMenuItem(
          icon: Icons.dark_mode_outlined,
          iconBackground: const Color(0xFFF0ECF9),
          iconColor: const Color(0xFF7862A7),
          title: 'Tampilan',
          subtitle: 'Gunakan tema terang',
          onTap: () {
            _showComingSoon('Pengaturan Tampilan');
          },
        ),

        _buildDivider(),

        _buildMenuItem(
          icon: Icons.language_rounded,
          iconBackground: const Color(0xFFE9F2F8),
          iconColor: const Color(0xFF4B829E),
          title: 'Bahasa',
          subtitle: 'Bahasa Indonesia',
          onTap: () {
            _showComingSoon('Pengaturan Bahasa');
          },
        ),
      ],
    );
  }

  // ============================================================
  // NOTIFICATION
  // ============================================================

  Widget _buildNotificationItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 13,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4DD),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFFE3A11B),
              size: 21,
            ),
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
                    color: Color(0xFF17231D),
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'Pengingat dan update aktivitas',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF8A948E),
                  ),
                ),
              ],
            ),
          ),

          Switch.adaptive(
            value: _notificationEnabled,
            activeColor: Color(0xFF1E8E5A),
            onChanged: (value) {
              setState(() {
                _notificationEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELP
  // ============================================================

  Widget _buildHelpSection() {
    return _buildMenuContainer(
      children: [
        _buildMenuItem(
          icon: Icons.help_outline_rounded,
          iconBackground: const Color(0xFFEAF4FB),
          iconColor: const Color(0xFF4D87A9),
          title: 'Pusat Bantuan',
          subtitle: 'Pertanyaan dan panduan penggunaan',
          onTap: () {
            _showComingSoon('Pusat Bantuan');
          },
        ),

        _buildDivider(),

        _buildMenuItem(
          icon: Icons.shield_outlined,
          iconBackground: const Color(0xFFEFF3EC),
          iconColor: const Color(0xFF61795D),
          title: 'Privasi & Keamanan',
          subtitle: 'Kelola keamanan akun kamu',
          onTap: () {
            _showComingSoon('Privasi & Keamanan');
          },
        ),

        _buildDivider(),

        _buildMenuItem(
          icon: Icons.info_outline_rounded,
          iconBackground: const Color(0xFFF0F0F0),
          iconColor: const Color(0xFF6E746F),
          title: 'Tentang Pilara',
          subtitle: 'Informasi aplikasi',
          onTap: () {
            _showAboutPilara();
          },
        ),
      ],
    );
  }

  // ============================================================
  // MENU CONTAINER
  // ============================================================

  Widget _buildMenuContainer({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: const Color(0xFFE5EAE7),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(21),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 13,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF17231D),
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

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 69),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFF0F2F1),
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: _showLogoutDialog,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF2F2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFFFDDDD),
          ),
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

  // ============================================================
  // COMING SOON
  // ============================================================

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature akan segera tersedia.',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // ABOUT
  // ============================================================

  void _showAboutPilara() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Tentang Pilara',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Pilara adalah aplikasi yang membantu '
            'pengguna mengenali, memilah, dan '
            'mengelola sampah dengan lebih mudah '
            'sekaligus membangun kebiasaan ramah '
            'lingkungan.',
            style: TextStyle(
              height: 1.5,
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: Color(0xFF1E8E5A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // LOGOUT DIALOG
  // ============================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23),
          ),
          title: const Text(
            'Keluar dari akun?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Kamu harus login kembali untuk '
            'mengakses akun Pilara.',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Color(0xFF68736D),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                // Nanti diarahkan ke halaman login
                // menggunakan AppRouter.signin.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9534F),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Keluar',
              ),
            ),
          ],
        );
      },
    );
  }
}