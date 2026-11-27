import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/dummy_home.dart';
import '../data/dummy_articles.dart';
import '../routers/app_router.dart';
import 'camera_screen.dart';
import 'profile_screen.dart';
import 'pilah_screen.dart';
import 'articles_screen.dart';

// ==================================================================
// PALET WARNA (Terintegrasi dengan AppColors)
// ==================================================================

const Color _kDarkText = Color(0xFF1F2A24);
const Color _kMutedText = Color(0xFF6B7A72);
const Color _kBorderColor = Color(0xFFEBF2EC);

// ==================================================================
// STATE BAHASA
// ==================================================================

final ValueNotifier<int> appLanguage = ValueNotifier<int>(0);

class AppStrings {
  final int lang;
  AppStrings(this.lang);

  String t(String key) {
    const id = {
      'greeting_morning': 'Selamat Pagi',
      'greeting_noon': 'Selamat Siang',
      'greeting_evening': 'Selamat Sore',
      'greeting_night': 'Selamat Malam',
      'nav_home': 'Beranda',
      'nav_find': 'Cari Titik',
      'nav_learn': 'Belajar',
      'nav_profile': 'Profil',
      'weekly_challenge': 'Tantangan Mingguan',
      'sustainability_tips': 'Tips Ramah Lingkungan',
      'show_all': 'Lihat semua',
      'waste_category': 'Kategori Sampah',
      'recent_activity': 'Aktivitas Terbaru',
      'recycled': 'Daur Ulang',
      'co2_saved': 'CO₂ Dihemat',
      'points': 'Poin',
      'challenge_title': 'Tantangan Kopi Tanpa Sampah',
      'challenge_points': '+200 Poin',
      'challenge_joined': '12rb ikut',
      'challenge_deadline': '5 hari lagi',
      'article_food': 'Dari Kebun ke Meja: Belanja Minim Sampah',
      'article_eco': 'Tips Rumah Ramah Lingkungan',
      'category_food': 'Makanan',
      'category_eco': 'Gaya Hidup',
      'duration_12': '12 mnt',
      'duration_5': '5 mnt',
      'notif_title': 'Notifikasi',
      'notif_empty': 'Belum ada notifikasi',
      'notif_desc': 'Notifikasi aktivitas Pilara akan muncul di sini.',
      'chat_title': 'Pilara Bot',
      'chat_hint': 'Tanya seputar sampah...',
      'chat_welcome': 'Halo! Saya Pilara Bot. Ada yang bisa saya bantu?',
      'community_title': 'Komunitas',
      'community_desc': 'Aksi bersih-bersih pantai di Bali. Ayo ikut!',
      'community_detail': 'Lihat detail',
      'join': 'Ikut Tantangan',
      'joined': 'Diikuti',
      'level_badge': 'Level',
      'how_to_earn': 'Cara Poin',
      'redeem': 'Reward',
      'history': 'Riwayat',
      'impact_calc': 'Kalkulator',
      'challenge': 'Challenge',
      'agenda': 'Agenda',
      'guide': 'Panduan',
      'activity_dropoff': 'Setoran Drop-off',
      'activity_dropoff_desc': 'Plastik 1,2 kg di Bank Sampah',
      'activity_challenge': 'Progres Challenge',
      'activity_challenge_desc': '2/5 tantangan selesai',
      'activity_learn': 'Belajar',
      'activity_learn_desc': 'Membaca tips pilah B3',
      'progress_level': '100 poin lagi menuju Level 1',
      'scan_first': 'Scan Sampah',
      'waste_organic': 'Organik',
      'waste_inorganic': 'Anorganik',
      'waste_b3': 'B3',
      'waste_other': 'Residu',
      'waste_organic_sub': 'Sisa makanan, daun',
      'waste_inorganic_sub': 'Plastik, kaleng, kertas',
      'waste_b3_sub': 'Baterai, lampu, obat',
      'waste_other_sub': 'Popok, tisu bekas',
      'banner_title': 'Bingung memilah?',
      'banner_desc': 'Scan sampahmu, Pilara kasih tahu kategorinya.',
      'banner_btn': 'Scan',
      'time_today': 'Hari ini',
      'time_yesterday': 'Kemarin',
      'time_2d': '2 hari lalu',
      'ev1_title': 'Aksi Bersih Pantai Kuta',
      'ev1_loc': 'Pantai Kuta, Bali',
      'ev2_title': 'Workshop Kompos untuk Pemula',
      'ev2_loc': 'Online • Zoom',
      'month_nov': 'Nov',
      'month_dec': 'Des',
      'going': 'ikut',
      'join_short': 'Ikut',
      'activity_empty_title': 'Belum ada aktivitas',
      'activity_empty_desc': 'Scan sampah pertamamu untuk mulai mengumpulkan poin.',
      'ev3_title': 'Setor Bareng Bank Sampah',
      'ev3_loc': 'Bank Sampah Melati',
    };
    const en = {
      'greeting_morning': 'Good Morning',
      'greeting_noon': 'Good Afternoon',
      'greeting_evening': 'Good Evening',
      'greeting_night': 'Good Night',
      'nav_home': 'Home',
      'nav_find': 'Find Point',
      'nav_learn': 'Learn',
      'nav_profile': 'Profile',
      'weekly_challenge': 'Weekly Challenge',
      'sustainability_tips': 'Sustainability Tips',
      'show_all': 'Show all',
      'waste_category': 'Waste Category',
      'recent_activity': 'Recent Activity',
      'recycled': 'Recycled',
      'co2_saved': 'CO₂ Saved',
      'points': 'Points',
      'challenge_title': 'Zero-Waste Coffee Challenge',
      'challenge_points': '+200 Points',
      'challenge_joined': '12k joined',
      'challenge_deadline': '5 days left',
      'article_food': 'From Farm to Fork: Zero-Waste Shopping',
      'article_eco': 'Eco-Friendly Home Hacks',
      'category_food': 'Food',
      'category_eco': 'Eco-living',
      'duration_12': '12 min',
      'duration_5': '5 min',
      'notif_title': 'Notifications',
      'notif_empty': 'No notifications yet',
      'notif_desc': 'Pilara activity notifications will appear here.',
      'chat_title': 'Pilara Bot',
      'chat_hint': 'Ask about waste...',
      'chat_welcome': 'Hi! I am Pilara Bot. How can I help you?',
      'community_title': 'Community',
      'community_desc': 'Beach clean-up in Bali. Join us!',
      'community_detail': 'View detail',
      'join': 'Join Challenge',
      'joined': 'Joined',
      'level_badge': 'Level',
      'how_to_earn': 'How to Earn',
      'redeem': 'Reward',
      'history': 'History',
      'impact_calc': 'Calculator',
      'challenge': 'Challenge',
      'agenda': 'Agenda',
      'guide': 'Guide',
      'activity_dropoff': 'Drop-off Deposit',
      'activity_dropoff_desc': '1.2 kg plastic at Waste Bank',
      'activity_challenge': 'Challenge Progress',
      'activity_challenge_desc': '2/5 challenge done',
      'activity_learn': 'Learn',
      'activity_learn_desc': 'Read hazardous waste tips',
      'progress_level': '100 points to Level 1',
      'scan_first': 'Scan Waste',
      'waste_organic': 'Organic',
      'waste_inorganic': 'Inorganic',
      'waste_b3': 'Hazardous',
      'waste_other': 'Residual',
      'waste_organic_sub': 'Food scraps, leaves',
      'waste_inorganic_sub': 'Plastic, cans, paper',
      'waste_b3_sub': 'Batteries, lamps, meds',
      'waste_other_sub': 'Diapers, used tissues',
      'banner_title': 'Confused about sorting?',
      'banner_desc': 'Scan your waste, Pilara will tell you the category.',
      'banner_btn': 'Scan',
      'time_today': 'Today',
      'time_yesterday': 'Yesterday',
      'time_2d': '2 days ago',
      'ev1_title': 'Kuta Beach Clean-up',
      'ev1_loc': 'Kuta Beach, Bali',
      'ev2_title': 'Composting Workshop for Beginners',
      'ev2_loc': 'Online • Zoom',
      'month_nov': 'Nov',
      'month_dec': 'Dec',
      'going': 'going',
      'join_short': 'Join',
      'activity_empty_title': 'No activity yet',
      'activity_empty_desc': 'Scan your first waste to start earning points.',
      'ev3_title': 'Group Drop-off at Waste Bank',
      'ev3_loc': 'Melati Waste Bank',
    };
    return (lang == 0 ? id : en)[key] ?? key;
  }
}

// ==================================================================
// DATA PLACEHOLDER
// ==================================================================

const int _pointsPerLevel = 100;
const int _currentPoints = 0;

// Foto cup kopi untuk Tantangan Mingguan
const String _imgCoffee =
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=800&auto=format&fit=crop';
const String _imgFood =
    'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=400&auto=format&fit=crop';
const String _imgEcoLiving =
    'https://images.unsplash.com/photo-1584473457409-ae5c91d7d8b1?q=80&w=400&auto=format&fit=crop';

// ==================================================================
// HOME SCREEN
// ==================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void _goTo(int index) => setState(() => currentIndex = index);

  late final List<Widget> pages = [
    HomeContent(onNavigateTab: _goTo),
    const CameraScreen(),
    const PilahScreen(),
    const ArticlesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Gunakan background dari AppColors
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: appLanguage,
        builder: (context, lang, _) {
          return _BottomBar(
            currentIndex: currentIndex,
            onTap: _goTo,
            lang: lang,
          );
        },
      ),
    );
  }
}

// ==================================================================
// BOTTOM BAR
// ==================================================================

class _BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int lang;

  const _BottomBar({
    required this.currentIndex,
    required this.onTap,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(lang);

    return SafeArea(
      top: false,
      child: SizedBox(
        height: 100,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 16,
              right: 16,
              bottom: 10,
              height: 66,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 20,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _NavItem(
                      label: s.t('nav_home'),
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home_rounded,
                      selected: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                    _NavItem(
                      label: s.t('nav_find'),
                      icon: Icons.location_on_outlined,
                      selectedIcon: Icons.location_on_rounded,
                      selected: currentIndex == 2,
                      onTap: () => onTap(2),
                    ),
                    const SizedBox(width: 72),
                    _NavItem(
                      label: s.t('nav_learn'),
                      icon: Icons.menu_book_outlined,
                      selectedIcon: Icons.menu_book_rounded,
                      selected: currentIndex == 3,
                      onTap: () => onTap(3),
                    ),
                    _NavItem(
                      label: s.t('nav_profile'),
                      icon: Icons.person_outline_rounded,
                      selectedIcon: Icons.person_rounded,
                      selected: currentIndex == 4,
                      onTap: () => onTap(4),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 36,
              left: 0,
              right: 0,
              child: Center(
                child: Tooltip(
                  message: lang == 0 ? 'Pilah Sampah' : 'Sort Waste',
                  child: GestureDetector(
                    onTap: () => onTap(1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        currentIndex == 1
                            ? Icons.recycling_rounded
                            : Icons.center_focus_strong_rounded,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primaryGreen : _kMutedText;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? selectedIcon : icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// WARNA AKSEN TAMBAHAN (untuk ikon & kartu berwarna)
// ==================================================================

const Color _kAmberBg = Color(0xFFFFF3DC);
const Color _kAmberFg = Color(0xFFF2A100);
const Color _kBlueBg = Color(0xFFE8F1FE);
const Color _kBlueFg = Color(0xFF3B82F6);
const Color _kRoseBg = Color(0xFFFDE8EC);
const Color _kRoseFg = Color(0xFFE5486A);
const Color _kGreyBg = Color(0xFFEEF1EF);

// ==================================================================
// TOMBOL REUSABLE
// Dibuat dari Material + InkWell supaya tidak terpengaruh
// ElevatedButtonTheme global (penyebab teks tombol terpotong).
// ==================================================================

class _AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final Color? borderColor;
  final bool expand;
  final double height;
  final double fontSize;
  final double radius;

  const _AppButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.background = AppColors.primaryGreen,
    this.foreground = AppColors.white,
    this.borderColor,
    this.expand = false,
    this.height = 46,
    this.fontSize = 14,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: borderColor == null
            ? BorderSide.none
            : BorderSide(color: borderColor!, width: 1.2),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          width: expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: fontSize + 4, color: foreground),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// HOME CONTENT
// ==================================================================

class HomeContent extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeContent({super.key, this.onNavigateTab});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  static const double _hPad = 20;
  static const double _gap = 22; // jarak antar section

  String _greeting(AppStrings s) {
    final hour = DateTime.now().hour;
    if (hour < 11) return s.t('greeting_morning');
    if (hour < 15) return s.t('greeting_noon');
    if (hour < 18) return s.t('greeting_evening');
    return s.t('greeting_night');
  }

  Widget _px(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: _hPad),
        child: child,
      );

  Widget _section(
    AppStrings s,
    String title,
    Widget child, {
    bool padChild = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _px(_SectionHeader(title, actionLabel: s.t('show_all'))),
        const SizedBox(height: 10),
        padChild ? _px(child) : child,
      ],
    );
  }

  void _goScan() => widget.onNavigateTab?.call(1);

  // User baru = belum punya poin/aktivitas -> tampilkan empty state & statistik 0
  bool get _hasActivity => _currentPoints > 0;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final clamped = mq.textScaler.clamp(
      minScaleFactor: 0.9,
      maxScaleFactor: 1.15,
    );

    return ValueListenableBuilder<int>(
      valueListenable: appLanguage,
      builder: (context, lang, _) {
        final s = AppStrings(lang);

        return MediaQuery(
          data: mq.copyWith(textScaler: clamped),
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _px(_buildHeader(s)),
                  const SizedBox(height: 16),
                  _px(_buildHeroCard(s)),
                  const SizedBox(height: 14),
                  _px(_ShortcutGrid(lang: lang)),
                  const SizedBox(height: _gap),

                  // Tantangan Mingguan
                  _section(
                    s,
                    s.t('weekly_challenge'),
                    _ChallengeCard(s: s),
                  ),
                  const SizedBox(height: _gap),

                  // Komunitas
                  _section(
                    s,
                    s.t('community_title'),
                    _buildCommunity(s),
                    padChild: false,
                  ),
                  const SizedBox(height: _gap),

                  // Aktivitas Terbaru
                  _section(
                    s,
                    s.t('recent_activity'),
                    _buildActivity(s),
                  ),
                  const SizedBox(height: _gap),

                  // Tips Ramah Lingkungan
                  _section(
                    s,
                    s.t('sustainability_tips'),
                    _buildTips(s),
                    padChild: false,
                  ),
                  const SizedBox(height: _gap),

                  // Kategori Sampah
                  _section(
                    s,
                    s.t('waste_category'),
                    _WasteCategoryGrid(lang: lang),
                  ),
                  const SizedBox(height: _gap),

                  // Banner CTA Bawah
                  _px(_BottomBanner(lang: lang, onTap: _goScan)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------------

  Widget _headerIconButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: _kBorderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(width: 42, height: 42, child: child),
      ),
    );
  }

  Widget _buildHeader(AppStrings s) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.mint,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=150&auto=format&fit=crop',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.person_rounded,
              color: AppColors.primaryGreen,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Halo, Charlotte!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: _kMutedText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _greeting(s),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  color: _kDarkText,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Tooltip(
          message: 'Tanya Pilara',
          child: _headerIconButton(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => _ChatbotSheet(lang: appLanguage.value),
              );
            },
            child: const Icon(
              Icons.smart_toy_outlined,
              color: AppColors.primaryGreen,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _headerIconButton(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => _NotificationSheet(s: s),
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primaryGreen,
                size: 22,
              ),
              Positioned(
                top: 10,
                right: 11,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------
  // HERO CARD (poin + progress + statistik + tombol scan)
  // ----------------------------------------------------------------

  Widget _decorCircle(double size, double alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: alpha),
      ),
    );
  }

  Widget _buildHeroCard(AppStrings s) {
    final progress =
        (_currentPoints / _pointsPerLevel).clamp(0.0, 1.0).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(right: -30, top: -42, child: _decorCircle(110, 0.06)),
          Positioned(right: 50, bottom: -56, child: _decorCircle(84, 0.04)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris 1: poin + pill level
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.t('points'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white.withValues(alpha: 0.85),
                            ),
                          ),
                          Text(
                            '$_currentPoints',
                            style: const TextStyle(
                              fontSize: 32,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.military_tech_rounded,
                            size: 16,
                            color: AppColors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${s.t('level_badge')} 0',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Baris 2: progress bar + teks
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.white.withValues(alpha: 0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  s.t('progress_level'),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 10),
                // Baris 3: statistik inline
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    _InlineStat(
                      icon: Icons.recycling_rounded,
                      value: _hasActivity ? '3.5 kg' : '0 kg',
                      label: s.t('recycled'),
                    ),
                    _InlineStat(
                      icon: Icons.eco_rounded,
                      value: _hasActivity ? '5.2 g' : '0 g',
                      label: s.t('co2_saved'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // KOMUNITAS
  // ----------------------------------------------------------------

  Widget _buildCommunity(AppStrings s) {
    final events = <Widget>[
      _CommunityCard(
        title: s.t('ev1_title'),
        location: s.t('ev1_loc'),
        day: '30',
        month: s.t('month_nov'),
        going: '48 ${s.t('going')}',
        type: _EventType.cleanup,
        joinLabel: s.t('join_short'),
        joinedLabel: s.t('joined'),
      ),
      _CommunityCard(
        title: s.t('ev2_title'),
        location: s.t('ev2_loc'),
        day: '06',
        month: s.t('month_dec'),
        going: '126 ${s.t('going')}',
        type: _EventType.workshop,
        joinLabel: s.t('join_short'),
        joinedLabel: s.t('joined'),
      ),
      _CommunityCard(
        title: s.t('ev3_title'),
        location: s.t('ev3_loc'),
        day: '12',
        month: s.t('month_dec'),
        going: '32 ${s.t('going')}',
        type: _EventType.bank,
        joinLabel: s.t('join_short'),
        joinedLabel: s.t('joined'),
      ),
    ];

    return SizedBox(
      height: 226,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: _hPad),
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => events[index],
      ),
    );
  }

  // ----------------------------------------------------------------
  // AKTIVITAS TERBARU
  // ----------------------------------------------------------------

  Widget _buildActivity(AppStrings s) {
    if (!_hasActivity) {
      return _ActivityEmpty(
        title: s.t('activity_empty_title'),
        subtitle: s.t('activity_empty_desc'),
        onTap: _goScan,
      );
    }
    return _ActivityList(
      items: [
        _ActivityData(
          icon: Icons.recycling_rounded,
          fg: AppColors.primaryGreen,
          bg: AppColors.mint,
          title: s.t('activity_dropoff'),
          subtitle: s.t('activity_dropoff_desc'),
          time: s.t('time_today'),
          points: '+150',
        ),
        _ActivityData(
          icon: Icons.emoji_events_rounded,
          fg: _kAmberFg,
          bg: _kAmberBg,
          title: s.t('activity_challenge'),
          subtitle: s.t('activity_challenge_desc'),
          time: s.t('time_yesterday'),
          points: '+200',
        ),
        _ActivityData(
          icon: Icons.menu_book_rounded,
          fg: _kBlueFg,
          bg: _kBlueBg,
          title: s.t('activity_learn'),
          subtitle: s.t('activity_learn_desc'),
          time: s.t('time_2d'),
          points: '+50',
        ),
      ],
    );
  }

  // ----------------------------------------------------------------
  // TIPS
  // ----------------------------------------------------------------

  Widget _buildTips(AppStrings s) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: _hPad),
        itemCount: 2,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _ArticleCard(
              title: s.t('article_food'),
              imageUrl: _imgFood,
              category: s.t('category_food'),
              duration: s.t('duration_12'),
            );
          }
          return _ArticleCard(
            title: s.t('article_eco'),
            imageUrl: _imgEcoLiving,
            category: s.t('category_eco'),
            duration: s.t('duration_5'),
          );
        },
      ),
    );
  }
}

// ==================================================================
// STATISTIK INLINE (kartu poin)
// ==================================================================

class _InlineStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _InlineStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.white.withValues(alpha: 0.9)),
        const SizedBox(width: 5),
        Text.rich(
          TextSpan(
            text: '$value ',
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================================================================
// SHORTCUT / FITUR (ringkas, 4 x 2 dalam satu kartu)
// ==================================================================

class _ShortcutItem {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  const _ShortcutItem(this.icon, this.label, this.bg, this.fg);
}

class _ShortcutGrid extends StatelessWidget {
  final int lang;
  const _ShortcutGrid({required this.lang});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(lang);

    final items = <_ShortcutItem>[
      _ShortcutItem(Icons.military_tech_rounded, s.t('level_badge'), AppColors.mint, AppColors.primaryGreen),
      _ShortcutItem(Icons.stars_rounded, s.t('how_to_earn'), AppColors.mint, AppColors.primaryGreen),
      _ShortcutItem(Icons.redeem_rounded, s.t('redeem'), AppColors.mint, AppColors.primaryGreen),
      _ShortcutItem(Icons.history_rounded, s.t('history'), AppColors.mint, AppColors.primaryGreen),
      _ShortcutItem(Icons.calculate_rounded, s.t('impact_calc'), AppColors.mint, AppColors.primaryGreen),
      _ShortcutItem(Icons.emoji_events_rounded, s.t('challenge'), AppColors.mint, AppColors.primaryGreen),
      _ShortcutItem(Icons.event_rounded, s.t('agenda'), AppColors.mint, AppColors.primaryGreen),
      _ShortcutItem(Icons.menu_book_rounded, s.t('guide'), AppColors.mint, AppColors.primaryGreen),
    ];

    Widget row(List<_ShortcutItem> rowItems) => Row(
          children: [
            for (final item in rowItems) Expanded(child: _ShortcutCell(item: item)),
          ],
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorderColor),
      ),
      child: Column(
        children: [
          row(items.sublist(0, 4)),
          const SizedBox(height: 10),
          row(items.sublist(4, 8)),
        ],
      ),
    );
  }
}

class _ShortcutCell extends StatelessWidget {
  final _ShortcutItem item;
  const _ShortcutCell({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: item.fg, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              item.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _kDarkText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// SECTION HEADER
// ==================================================================

class _SectionHeader extends StatelessWidget {
  final String label;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader(this.label, {this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _kDarkText,
            ),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ==================================================================
// TANTANGAN MINGGUAN
// ==================================================================

class _ChallengeCard extends StatefulWidget {
  final AppStrings s;

  const _ChallengeCard({required this.s});

  @override
  State<_ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<_ChallengeCard> {
  bool _isJoined = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.s;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _kBorderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto cup kopi + overlay info
          SizedBox(
            height: 132,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  _imgCoffee,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(color: AppColors.mint);
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.mint,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.coffee_rounded,
                      size: 44,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: _Chip(
                    icon: Icons.schedule_rounded,
                    label: s.t('challenge_deadline'),
                    bg: AppColors.white.withValues(alpha: 0.92),
                    fg: _kDarkText,
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Row(
                    children: [
                      _Chip(
                        icon: Icons.bolt_rounded,
                        label: s.t('challenge_points'),
                        bg: AppColors.white.withValues(alpha: 0.92),
                        fg: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 6),
                      _Chip(
                        icon: Icons.people_rounded,
                        label: s.t('challenge_joined'),
                        bg: AppColors.white.withValues(alpha: 0.92),
                        fg: AppColors.primaryGreen,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.t('challenge_title'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                    color: _kDarkText,
                  ),
                ),
                const SizedBox(height: 12),
                _AppButton(
                  label: _isJoined ? s.t('joined') : s.t('join'),
                  icon: _isJoined ? Icons.check_circle_rounded : null,
                  background: _isJoined ? AppColors.mint : AppColors.primaryGreen,
                  foreground: _isJoined ? AppColors.primaryGreen : AppColors.white,
                  borderColor: _isJoined ? AppColors.primaryGreen : null,
                  expand: true,
                  onTap: () => setState(() => _isJoined = !_isJoined),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;

  const _Chip({
    required this.icon,
    required this.label,
    this.bg = AppColors.mint,
    this.fg = AppColors.primaryGreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// KOMUNITAS (kartu event horizontal)
// ==================================================================

enum _EventType { cleanup, workshop, bank }

class _CommunityCard extends StatefulWidget {
  final String title;
  final String location;
  final String day;
  final String month;
  final String going;
  final _EventType type;
  final String? imageUrl; // foto dari penyelenggara; kosong = ilustrasi default
  final String joinLabel;
  final String joinedLabel;

  const _CommunityCard({
    required this.title,
    required this.location,
    required this.day,
    required this.month,
    required this.going,
    required this.type,
    required this.joinLabel,
    required this.joinedLabel,
    this.imageUrl,
  });

  @override
  State<_CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<_CommunityCard> {
  bool _joined = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _EventCover(type: widget.type, imageUrl: widget.imageUrl),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 11,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.day} ${widget.month}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: _kDarkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                    color: _kDarkText,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 13,
                      color: _kMutedText,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        widget.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: _kMutedText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const _AvatarStack(),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.going,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: _kDarkText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _AppButton(
                      label: _joined ? widget.joinedLabel : widget.joinLabel,
                      background:
                          _joined ? AppColors.mint : AppColors.primaryGreen,
                      foreground:
                          _joined ? AppColors.primaryGreen : AppColors.white,
                      height: 32,
                      fontSize: 12,
                      radius: 10,
                      onTap: () => setState(() => _joined = !_joined),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cover event: foto penyelenggara bila ada, kalau tidak ilustrasi default
/// sesuai jenis acara (bersih-bersih, workshop, bank sampah).
class _EventCover extends StatelessWidget {
  final _EventType type;
  final String? imageUrl;

  const _EventCover({required this.type, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final Color top;
    final Color bottom;
    final Color waveBack;
    final Color waveFront;
    final Color iconColor;
    final IconData icon;

    switch (type) {
      case _EventType.cleanup:
        top = const Color(0xFFBFEBF2);
        bottom = const Color(0xFFE8F8F4);
        waveBack = const Color(0xFF7DD3CC);
        waveFront = const Color(0xFF2FB1A6);
        iconColor = const Color(0xFF0E8A7B);
        icon = Icons.beach_access_rounded;
        break;
      case _EventType.workshop:
        top = const Color(0xFFFFF1C9);
        bottom = const Color(0xFFF3F9DF);
        waveBack = const Color(0xFFB5E09C);
        waveFront = const Color(0xFF6CBB6F);
        iconColor = const Color(0xFF2E8B57);
        icon = Icons.compost_rounded;
        break;
      case _EventType.bank:
        top = const Color(0xFFDCE8FF);
        bottom = const Color(0xFFEEF4FF);
        waveBack = const Color(0xFFABCBF6);
        waveFront = const Color(0xFF6BA3EA);
        iconColor = const Color(0xFF3B82F6);
        icon = Icons.recycling_rounded;
        break;
    }

    final illustration = Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: _CoverPainter(
            top: top,
            bottom: bottom,
            waveBack: waveBack,
            waveFront: waveFront,
          ),
        ),
        Align(
          alignment: const Alignment(0.55, 0.05),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.92),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: iconColor),
          ),
        ),
      ],
    );

    if (imageUrl == null) return illustration;

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return illustration;
      },
      errorBuilder: (context, error, stackTrace) => illustration,
    );
  }
}

class _CoverPainter extends CustomPainter {
  final Color top;
  final Color bottom;
  final Color waveBack;
  final Color waveFront;

  const _CoverPainter({
    required this.top,
    required this.bottom,
    required this.waveBack,
    required this.waveFront,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, bottom],
        ).createShader(rect),
    );

    // matahari / awan lembut
    canvas.drawCircle(
      Offset(w * 0.18, h * 0.3),
      h * 0.16,
      Paint()..color = AppColors.white.withValues(alpha: 0.45),
    );

    final back = Path()
      ..moveTo(0, h * 0.62)
      ..quadraticBezierTo(w * 0.25, h * 0.46, w * 0.5, h * 0.62)
      ..quadraticBezierTo(w * 0.75, h * 0.78, w, h * 0.58)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(back, Paint()..color = waveBack);

    final front = Path()
      ..moveTo(0, h * 0.78)
      ..quadraticBezierTo(w * 0.3, h * 0.64, w * 0.55, h * 0.78)
      ..quadraticBezierTo(w * 0.8, h * 0.92, w, h * 0.74)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(front, Paint()..color = waveFront);
  }

  @override
  bool shouldRepaint(covariant _CoverPainter old) =>
      old.top != top ||
      old.bottom != bottom ||
      old.waveBack != waveBack ||
      old.waveFront != waveFront;
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack();

  static const List<Color> _colors = [
    Color(0xFFB7E4C7),
    Color(0xFFFFE0A3),
    Color(0xFFBFD8FF),
  ];
  static const List<String> _initials = ['A', 'R', 'D'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22 + 2 * 14,
      height: 22,
      child: Stack(
        children: [
          for (int i = 0; i < _colors.length; i++)
            Positioned(
              left: i * 14.0,
              child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _colors[i],
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 1.5),
                ),
                child: Text(
                  _initials[i],
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: _kDarkText,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==================================================================
// AKTIVITAS TERBARU
// ==================================================================

class _ActivityData {
  final IconData icon;
  final Color fg;
  final Color bg;
  final String title;
  final String subtitle;
  final String time;
  final String points;

  const _ActivityData({
    required this.icon,
    required this.fg,
    required this.bg,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.points,
  });
}

class _ActivityEmpty extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActivityEmpty({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _kBorderColor),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.center_focus_strong_rounded,
                  color: AppColors.primaryGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _kDarkText,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        color: _kMutedText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: _kMutedText,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  final List<_ActivityData> items;
  const _ActivityList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorderColor),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _ActivityRow(data: items[i]),
            if (i < items.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                color: _kBorderColor,
                indent: 56,
              ),
          ],
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final _ActivityData data;
  const _ActivityRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, color: data.fg, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _kDarkText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: _kMutedText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.points,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                data.time,
                style: const TextStyle(
                  fontSize: 11,
                  color: _kMutedText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// KATEGORI SAMPAH (tile horizontal ringkas)
// ==================================================================

class _WasteItem {
  final String image;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bg;
  final Color fg;

  const _WasteItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bg,
    required this.fg,
  });
}

class _WasteCategoryGrid extends StatelessWidget {
  final int lang;
  const _WasteCategoryGrid({required this.lang});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(lang);

    final items = <_WasteItem>[
      _WasteItem(
        image: 'assets/images/organik.jpg',
        title: s.t('waste_organic'),
        subtitle: s.t('waste_organic_sub'),
        icon: Icons.eco_rounded,
        bg: AppColors.mint,
        fg: AppColors.primaryGreen,
      ),
      _WasteItem(
        image: 'assets/images/anorganik.jpg',
        title: s.t('waste_inorganic'),
        subtitle: s.t('waste_inorganic_sub'),
        icon: Icons.recycling_rounded,
        bg: _kBlueBg,
        fg: _kBlueFg,
      ),
      _WasteItem(
        image: 'assets/images/sampah_b3.jpg',
        title: s.t('waste_b3'),
        subtitle: s.t('waste_b3_sub'),
        icon: Icons.warning_amber_rounded,
        bg: _kRoseBg,
        fg: _kRoseFg,
      ),
      _WasteItem(
        image: 'assets/images/sampah_lainnya.jpg',
        title: s.t('waste_other'),
        subtitle: s.t('waste_other_sub'),
        icon: Icons.delete_outline_rounded,
        bg: _kGreyBg,
        fg: _kMutedText,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 72,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _WasteCategory(item: items[index]),
    );
  }
}

class _WasteCategory extends StatelessWidget {
  final _WasteItem item;
  final VoidCallback? onTap;

  const _WasteCategory({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: _kBorderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: Image.asset(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: item.bg,
                      alignment: Alignment.center,
                      child: Icon(item.icon, color: item.fg, size: 26),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: _kDarkText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        height: 1.2,
                        color: _kMutedText,
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
}

// ==================================================================
// BANNER CTA BAWAH
// ==================================================================

class _BottomBanner extends StatelessWidget {
  final int lang;
  final VoidCallback onTap;

  const _BottomBanner({required this.lang, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(lang);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.t('banner_title'),
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.t('banner_desc'),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.white.withValues(alpha: 0.85),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _AppButton(
            label: s.t('banner_btn'),
            icon: Icons.center_focus_strong_rounded,
            background: AppColors.white,
            foreground: AppColors.primaryGreen,
            height: 42,
            fontSize: 13,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String category;
  final String duration;

  const _ArticleCard({
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(color: AppColors.mint);
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.mint,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported_rounded,
                              color: AppColors.primaryGreen,
                              size: 36,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category == 'Makanan' || category == 'Food'
                                ? Icons.restaurant_rounded
                                : Icons.home_rounded,
                            size: 13,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$category • $duration',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _kDarkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40, // Tinggi tetap agar seragam (2 baris max)
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                  color: _kDarkText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// CHATBOT & NOTIF SHEET (Tidak Berubah)
// ==================================================================

class _ChatbotSheet extends StatefulWidget {
  final int lang;
  const _ChatbotSheet({required this.lang});

  @override
  State<_ChatbotSheet> createState() => _ChatbotSheetState();
}

class _ChatbotSheetState extends State<_ChatbotSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    final s = AppStrings(widget.lang);
    _messages.add({'text': s.t('chat_welcome'), 'isUser': false});
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _isTyping = true;
      _controller.clear();
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final botResponse = _getBotResponse(text, widget.lang);
      setState(() {
        _isTyping = false;
        _messages.add({'text': botResponse, 'isUser': false});
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getBotResponse(String input, int lang) {
    final lower = input.toLowerCase();
    final isIndo = lang == 0;

    if (lower.contains('organik') || lower.contains('organic') || lower.contains('sisa makanan')) {
      return isIndo
          ? 'Sampah organik seperti sisa makanan, daun, dan kulit buah bisa dijadikan kompos. Buang ke tempat sampah hijau ya!'
          : 'Organic waste like food scraps, leaves, and fruit peels can be composted. Put them in the green bin!';
    }
    if (lower.contains('anorganik') || lower.contains('plastic') || lower.contains('plastik') || lower.contains('botol')) {
      return isIndo
          ? 'Sampah anorganik seperti plastik, botol, dan kaleng bisa didaur ulang. Pisahkan dan buang ke tempat sampah biru.'
          : 'Inorganic waste like plastic, bottles, and cans can be recycled. Separate and put them in the blue bin.';
    }
    if (lower.contains('b3') || lower.contains('baterai') || lower.contains('battery') || lower.contains('berbahaya')) {
      return isIndo
          ? 'Sampah B3 (Bahan Berbahaya dan Beracun) seperti baterai, lampu, dan obat kadaluarsa harus dibuang ke tempat khusus.'
          : 'Hazardous waste (B3) like batteries, lamps, and expired medicine must be disposed of at special collection points.';
    }
    if (lower.contains('dimana') || lower.contains('where') || lower.contains('lokasi') || lower.contains('location')) {
      return isIndo
          ? 'Anda bisa mencari lokasi setor sampah terdekat melalui menu "Cari Titik" di navigasi bawah.'
          : 'You can find the nearest waste drop-off location via the "Find Point" menu.';
    }
    if (lower.contains('poin') || lower.contains('point') || lower.contains('hadiah')) {
      return isIndo
          ? 'Kumpulkan poin dengan memilah sampah dan menyelesaikan tantangan mingguan. Poin bisa ditukar dengan hadiah menarik!'
          : 'Collect points by sorting waste and completing weekly challenges. Points can be redeemed for rewards!';
    }
    return isIndo
        ? 'Maaf, saya belum mengerti. Coba tanya tentang "organik", "anorganik", "B3", atau "lokasi setor".'
        : 'Sorry, I didn\'t understand. Try asking about "organic", "inorganic", "B3", or "drop-off location".';
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(widget.lang);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.mint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      color: AppColors.primaryGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    s.t('chat_title'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _kDarkText,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: _kDarkText),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildTypingIndicator();
                  }
                  final msg = _messages[index];
                  return _buildMessageBubble(
                    msg['text'] as String,
                    msg['isUser'] as bool,
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: s.t('chat_hint'),
                        hintStyle: const TextStyle(
                          color: _kMutedText,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded,
                          color: AppColors.white, size: 20),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryGreen : AppColors.mint,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? AppColors.white : _kDarkText,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.mint,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(),
            const SizedBox(width: 4),
            _dot(),
            const SizedBox(width: 4),
            _dot(),
          ],
        ),
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _NotificationSheet extends StatelessWidget {
  final AppStrings s;

  const _NotificationSheet({required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.notifications_rounded, color: AppColors.primaryGreen),
              const SizedBox(width: 10),
              Text(
                s.t('notif_title'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _kDarkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 42,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(height: 10),
                Text(
                  s.t('notif_empty'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _kDarkText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  s.t('notif_desc'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _kMutedText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}