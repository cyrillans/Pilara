import 'dart:async';
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
// PALET WARNA FINAL (Soft, Clean, Modern)
// ==================================================================

const Color _kDarkText = Color(0xFF1F2A24);
const Color _kPrimaryGreen = Color(0xFF1B5E3A);
const Color _kSageBg = Color(0xFFF4F9F6);
const Color _kMintBg = Color(0xFFE8F3EC);
const Color _kBorderColor = Color(0xFFEBF2EC);
const Color _kLavender = Color(0xFFF0EDFB);
const Color _kLavenderDark = Color(0xFF5B4FB5);

// Warna Soft untuk Ikon (Hanya 2 variasi)
const Color _kIconSoftGreen = Color(0xFF2E7D5B);
const Color _kIconSoftBlue = Color(0xFF3A7CA5);

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
      'weekly_challenge': 'TANTANGAN MINGGUAN',
      'sustainability_tips': 'TIPS RAMAH LINGKUNGAN',
      'show_all': 'Lihat semua',
      'waste_category': 'KATEGORI SAMPAH',
      'recent_activity': 'AKTIVITAS TERBARU',
      'recycled': 'Daur Ulang',
      'co2_saved': 'CO2 Dihemat',
      'points': 'Poin',
      'challenge_title': 'Tantangan Kopi Tanpa Sampah',
      'challenge_points': '+200 Poin',
      'challenge_joined': '12rb ikut',
      'article_food': 'Dari Kebun ke Meja',
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
      'community_feed': 'FEED KOMUNITAS',
      'community_desc': 'Aksi bersih-bersih pantai di Bali, 30 Nov. Ayo ikut!',
      'join': 'Ikut',
      'joined': 'Diikuti',
      'level_badge': 'Level',
      'how_to_earn': 'Cara Poin',
      'redeem': 'Reward',
      'history': 'Riwayat',
      'impact_calc': 'Kalkulator',
      'challenge': 'Challenge',
      'agenda': 'Agenda',
      'more': 'Lainnya',
      'activity_dropoff': 'Setoran Drop-off',
      'activity_dropoff_desc': 'Plastik 1.2 kg di Bank Sampah',
      'activity_challenge': 'Progres Challenge',
      'activity_challenge_desc': '2/5 tantangan selesai',
      'activity_learn': 'Belajar',
      'activity_learn_desc': 'Membaca tips pilah B3',
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
      'weekly_challenge': 'WEEKLY CHALLENGE',
      'sustainability_tips': 'SUSTAINABILITY TIPS',
      'show_all': 'Show all',
      'waste_category': 'WASTE CATEGORY',
      'recent_activity': 'RECENT ACTIVITY',
      'recycled': 'Recycled',
      'co2_saved': 'CO2 Saved',
      'points': 'Points',
      'challenge_title': 'Zero-Waste Coffee Challenge',
      'challenge_points': '+200 Points',
      'challenge_joined': '12k joined',
      'article_food': 'From Farm to Fork',
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
      'community_feed': 'COMMUNITY FEED',
      'community_desc': 'Beach clean-up in Bali, Nov 30. Join us!',
      'join': 'Join',
      'joined': 'Joined',
      'level_badge': 'Level',
      'how_to_earn': 'How to Earn',
      'redeem': 'Reward',
      'history': 'History',
      'impact_calc': 'Calculator',
      'challenge': 'Challenge',
      'agenda': 'Agenda',
      'more': 'More',
      'activity_dropoff': 'Drop-off Deposit',
      'activity_dropoff_desc': '1.2 kg plastic at Waste Bank',
      'activity_challenge': 'Challenge Progress',
      'activity_challenge_desc': '2/5 challenge done',
      'activity_learn': 'Learn',
      'activity_learn_desc': 'Read B3 waste tips',
    };
    return (lang == 0 ? id : en)[key] ?? key;
  }
}

// ==================================================================
// DATA PLACEHOLDER
// ==================================================================

const int _pointsPerLevel = 500;

const String _imgTumbler =
    'https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=400&auto=format&fit=crop';
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
      backgroundColor: Colors.white,
      body: IndexedStack(index: currentIndex, children: pages),
      floatingActionButton: _ChatbotFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
// CHATBOT FAB
// ==================================================================

class _ChatbotFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: appLanguage,
      builder: (context, lang, _) {
        return FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => _ChatbotSheet(lang: lang),
            );
          },
          backgroundColor: _kPrimaryGreen,
          child: const Icon(Icons.smart_toy_rounded, color: Colors.white),
        );
      },
    );
  }
}

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
          color: Colors.white,
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
                      color: _kMintBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      color: _kPrimaryGreen,
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
                color: Colors.white,
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
                          color: AppColors.mutedText,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: _kSageBg,
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
                      color: _kPrimaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
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
          color: isUser ? _kPrimaryGreen : _kMintBg,
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
            color: isUser ? Colors.white : _kDarkText,
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
          color: _kMintBg,
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
        color: _kPrimaryGreen,
        shape: BoxShape.circle,
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
                  color: Colors.white,
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
                        color: _kPrimaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _kPrimaryGreen.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        currentIndex == 1
                            ? Icons.recycling_rounded
                            : Icons.center_focus_strong_rounded,
                        color: Colors.white,
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
    final color = selected ? _kPrimaryGreen : AppColors.mutedText;

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

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final clamped = mq.textScaler.clamp(
      minScaleFactor: 0.9,
      maxScaleFactor: 1.15,
    );

    final int points = dummyInitialPoints.toInt();

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
              padding: const EdgeInsets.only(top: 16, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HEADER (Avatar + Sapaan + Tombol + Mini Impact)
                  _px(_buildHeader(s, points)),
                  const SizedBox(height: 24),

                  // 2. GRID 8 SHORTCUT
                  _px(_ShortcutGrid(lang: lang)),
                  const SizedBox(height: 28),

                  // 3. WEEKLY CHALLENGE
                  _px(_SectionHeader(s.t('weekly_challenge'))),
                  const SizedBox(height: 12),
                  _px(_ChallengeCard(onTap: () => widget.onNavigateTab?.call(3), s: s)),
                  const SizedBox(height: 28),

                  // 4. FEED KOMUNITAS
                  _px(_CommunityFeed(lang: lang)),
                  const SizedBox(height: 28),

                  // 5. TIPS / ARTIKEL (Gambar Lebar)
                  _px(
                    _SectionHeader(
                      s.t('sustainability_tips'),
                      actionLabel: s.t('show_all'),
                      onAction: () => Navigator.pushNamed(context, AppRouter.articles),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: _hPad),
                      itemCount: 2,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
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
                  ),
                  const SizedBox(height: 28),

                  // 6. KATEGORI SAMPAH (Gambar Besar)
                  _px(_SectionHeader(s.t('waste_category'))),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 230,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: _hPad),
                      itemCount: dummyWasteCategories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final item = dummyWasteCategories[index];
                        final imagePath = _wasteImagePath(item['icon'].toString());
                        return _WasteCategory(
                          imagePath: imagePath,
                          title: item['title'].toString(),
                          subtitle: item['subtitle'].toString(),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                title: Text(
                                  item['title'].toString(),
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                                content: Text(
                                  'Panduan lengkap untuk kategori ${item['title']}. Materi detail B3 tersedia di menu Belajar.',
                                  style: const TextStyle(color: AppColors.mutedText),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Tutup'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 7. AKTIVITAS TERBARU (Soft Berwarna)
                  _px(_SectionHeader(s.t('recent_activity'))),
                  const SizedBox(height: 12),
                  _px(
                    Column(
                      children: [
                        _ActivityItem(
                          icon: Icons.recycling,
                          iconColor: _kIconSoftGreen,
                          title: s.t('activity_dropoff'),
                          subtitle: s.t('activity_dropoff_desc'),
                          points: '+150',
                        ),
                        const SizedBox(height: 10),
                        _ActivityItem(
                          icon: Icons.emoji_events,
                          iconColor: _kIconSoftGreen,
                          title: s.t('activity_challenge'),
                          subtitle: s.t('activity_challenge_desc'),
                          points: '+200',
                        ),
                        const SizedBox(height: 10),
                        _ActivityItem(
                          icon: Icons.menu_book,
                          iconColor: _kIconSoftBlue,
                          title: s.t('activity_learn'),
                          subtitle: s.t('activity_learn_desc'),
                          points: '+50',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ================================================================
  // HEADER (Clean, Mini Impact di Bawah)
  // ================================================================
  Widget _buildHeader(AppStrings s, int points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _kMintBg,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=150&auto=format&fit=crop',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.person_rounded,
                  color: _kPrimaryGreen,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, Charlotte!',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedText,
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
            Material(
              color: _kMintBg,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  appLanguage.value = appLanguage.value == 0 ? 1 : 0;
                },
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Center(
                    child: Text(
                      appLanguage.value == 0 ? 'ID' : 'EN',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _kPrimaryGreen,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: _kLavender,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _NotificationSheet(s: s),
                  );
                },
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: _kLavenderDark,
                        size: 22,
                      ),
                      Positioned(
                        top: 11,
                        right: 11,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.softGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: _kLavender, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Mini Impact Badges (Soft Colors)
        Row(
          children: [
            _MiniImpact(
              icon: Icons.recycling_rounded,
              value: '3.5 kg',
              label: s.t('recycled'),
              color: _kIconSoftGreen,
            ),
            const SizedBox(width: 12),
            _MiniImpact(
              icon: Icons.eco_rounded,
              value: '5.2 g',
              label: s.t('co2_saved'),
              color: _kIconSoftGreen,
            ),
            const SizedBox(width: 12),
            _MiniImpact(
              icon: Icons.stars_rounded,
              value: points.toString(),
              label: s.t('points'),
              color: _kIconSoftBlue,
            ),
          ],
        ),
      ],
    );
  }
}

// ==================================================================
// MINI IMPACT BADGE
// ==================================================================

class _MiniImpact extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MiniImpact({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: _kDarkText,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.mutedText,
          ),
        ),
      ],
    );
  }
}

// ==================================================================
// SHORTCUT GRID (Seragam, Soft Green)
// ==================================================================

class _ShortcutGrid extends StatelessWidget {
  final int lang;
  const _ShortcutGrid({required this.lang});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(lang);

    final items = [
      _ShortcutItem(icon: Icons.military_tech_rounded, label: s.t('level_badge')),
      _ShortcutItem(icon: Icons.stars_rounded, label: s.t('how_to_earn')),
      _ShortcutItem(icon: Icons.redeem_rounded, label: s.t('redeem')),
      _ShortcutItem(icon: Icons.history_rounded, label: s.t('history')),
      _ShortcutItem(icon: Icons.calculate_rounded, label: s.t('impact_calc')),
      _ShortcutItem(icon: Icons.emoji_events_rounded, label: s.t('challenge')),
      _ShortcutItem(icon: Icons.event_rounded, label: s.t('agenda')),
      _ShortcutItem(icon: Icons.more_horiz_rounded, label: s.t('more')),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${item.label} - Coming soon')),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _kMintBg, // Seragam: hijau sage lembut
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  item.icon,
                  color: _kPrimaryGreen, // Ikon hijau tua
                  size: 26,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _kDarkText,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShortcutItem {
  final IconData icon;
  final String label;
  _ShortcutItem({required this.icon, required this.label});
}

// ==================================================================
// COMMUNITY FEED
// ==================================================================

class _CommunityFeed extends StatelessWidget {
  final int lang;
  const _CommunityFeed({required this.lang});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(lang);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorderColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: _kMintBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.groups_rounded, color: _kPrimaryGreen, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.t('community_feed'),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mutedText,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.t('community_desc'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kDarkText,
                    height: 1.3,
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
              fontSize: 12,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w800,
              color: AppColors.mutedText,
            ),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  color: _kPrimaryGreen,
                  fontSize: 12,
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
// CHALLENGE CARD
// ==================================================================

class _ChallengeCard extends StatefulWidget {
  final VoidCallback onTap;
  final AppStrings s;

  const _ChallengeCard({required this.onTap, required this.s});

  @override
  State<_ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<_ChallengeCard> {
  bool _isJoined = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _kBorderColor, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            width: 130,
            child: Image.network(
              _imgTumbler,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: _kMintBg),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white,
                    Colors.white.withValues(alpha: 0.95),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          widget.s.t('challenge_title'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.25,
                            fontWeight: FontWeight.w800,
                            color: _kDarkText,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => _isJoined = !_isJoined);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isJoined ? _kPrimaryGreen : _kMintBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _isJoined ? widget.s.t('joined') : widget.s.t('join'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: _isJoined ? Colors.white : _kPrimaryGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _Chip(
                      icon: Icons.bolt_rounded,
                      label: widget.s.t('challenge_points'),
                    ),
                    const SizedBox(width: 8),
                    _Chip(
                      icon: Icons.people_rounded,
                      label: widget.s.t('challenge_joined'),
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

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: _kMintBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: _kPrimaryGreen),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: _kPrimaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// ARTICLE CARD
// ==================================================================

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
        width: 240,
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
                          return Container(color: _kMintBg);
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: _kMintBg,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported_rounded,
                              color: _kPrimaryGreen,
                              size: 36,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
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
                            color: _kPrimaryGreen,
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
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_outward_rounded,
                        size: 18,
                        color: _kDarkText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 1.3,
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
// WASTE CATEGORY (Besar & Jelas)
// ==================================================================

String _wasteImagePath(String key) {
  switch (key) {
    case 'eco':
      return 'assets/images/organik.jpg';
    case 'recycling':
      return 'assets/images/anorganik.jpg';
    case 'warning':
      return 'assets/images/sampah_b3.jpg';
    default:
      return 'assets/images/sampah_lainnya.jpg';
  }
}

class _WasteCategory extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _WasteCategory({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _kBorderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: _kMintBg,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_rounded,
                        color: _kPrimaryGreen,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: _kDarkText,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// ACTIVITY ITEM (Soft Colors)
// ==================================================================

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String points;

  const _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorderColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _kDarkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _kMintBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              points,
              style: const TextStyle(
                color: _kPrimaryGreen,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// NOTIFICATION SHEET
// ==================================================================

class _NotificationSheet extends StatelessWidget {
  final AppStrings s;

  const _NotificationSheet({required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
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
              const Icon(Icons.notifications_rounded, color: _kPrimaryGreen),
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
              color: _kMintBg,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 42,
                  color: _kPrimaryGreen,
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
                    color: AppColors.mutedText,
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