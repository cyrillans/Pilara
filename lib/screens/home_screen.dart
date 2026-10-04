import 'package:flutter/material.dart';

import '../data/dummy_home.dart';
import '../data/dummy_articles.dart';
import '../routers/app_router.dart';
import 'camera_screen.dart';
import 'pilah_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ============================================================
  // INDEX HALAMAN
  // ============================================================
  //
  // 0 = Home
  // 1 = Pilah
  // 2 = Riwayat
  // 3 = Profile
  //
  // ============================================================

  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeContent(),
    PilahScreen(),

    Center(
      child: Text(
        'Riwayat',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    Center(
      child: Text(
        'Profile',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ];

  // ============================================================
  // BUKA KAMERA
  // ============================================================

  void _openCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CameraScreen(),
      ),
    );
  }

  // ============================================================
  // INDEX NAVBAR
  // ============================================================

  int get navigationIndex {
    if (currentIndex >= 2) {
      return currentIndex + 1;
    }

    return currentIndex;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],

      body: pages[currentIndex],

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationIndex,

        onDestinationSelected: (index) {
          // ----------------------------------------------------
          // KAMERA
          // ----------------------------------------------------

          if (index == 2) {
            _openCamera();
            return;
          }

          // ----------------------------------------------------
          // HOME
          // ----------------------------------------------------

          if (index == 0) {
            setState(() {
              currentIndex = 0;
            });
            return;
          }

          // ----------------------------------------------------
          // PILAH
          // ----------------------------------------------------

          if (index == 1) {
            setState(() {
              currentIndex = 1;
            });
            return;
          }

          // ----------------------------------------------------
          // RIWAYAT
          // ----------------------------------------------------

          if (index == 3) {
            setState(() {
              currentIndex = 2;
            });
            return;
          }

          // ----------------------------------------------------
          // PROFILE
          // ----------------------------------------------------

          if (index == 4) {
            setState(() {
              currentIndex = 3;
            });
          }
        },

        // ======================================================
        // NAVIGATION ITEMS
        // ======================================================

        destinations: [
          // ----------------------------------------------------
          // HOME
          // ----------------------------------------------------

          const NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),

          // ----------------------------------------------------
          // PILAH
          // ----------------------------------------------------

          const NavigationDestination(
            icon: Icon(
              Icons.recycling_outlined,
            ),
            selectedIcon: Icon(
              Icons.recycling,
            ),
            label: 'Pilah',
          ),

          // ----------------------------------------------------
          // KAMERA
          // ----------------------------------------------------

          NavigationDestination(
            icon: Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: Color(0xFF3F7040),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 28,
              ),
            ),
            label: 'Foto',
          ),

          // ----------------------------------------------------
          // RIWAYAT
          // ----------------------------------------------------

          const NavigationDestination(
            icon: Icon(
              Icons.history_outlined,
            ),
            selectedIcon: Icon(
              Icons.history,
            ),
            label: 'Riwayat',
          ),

          // ----------------------------------------------------
          // PROFILE
          // ----------------------------------------------------

          const NavigationDestination(
            icon: Icon(
              Icons.person_outline,
            ),
            selectedIcon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// HOME CONTENT
// ==================================================================

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // HEADER
            // ======================================================

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, Pilara! 👋',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Mari jaga bumi bersama.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                // ------------------------------------------------
                // NOTIFICATION BUTTON
                // ------------------------------------------------

                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return const _NotificationSheet();
                        },
                      );
                    },
                    customBorder: const CircleBorder(),
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.green,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ======================================================
            // POINT CARD
            // ======================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade700,
                    Colors.green.shade500,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.eco,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Poin Pilara',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$dummyInitialPoints Poin',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ======================================================
            // PILAH SAMPAH
            // ======================================================

            const Text(
              'Pilah Sampah',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Kenali jenis sampah dan tempatkan dengan benar.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 15),

            // ======================================================
            // CATEGORY ROW 1
            // ======================================================

            Row(
              children: [
                Expanded(
                  child: _WasteCategory(
                    icon: _getWasteIcon(
                      dummyWasteCategories[0]['icon'],
                    ),
                    title: dummyWasteCategories[0]['title'],
                    subtitle:
                        dummyWasteCategories[0]['subtitle'],
                    color: _getWasteColor(
                      dummyWasteCategories[0]['color'],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _WasteCategory(
                    icon: _getWasteIcon(
                      dummyWasteCategories[1]['icon'],
                    ),
                    title: dummyWasteCategories[1]['title'],
                    subtitle:
                        dummyWasteCategories[1]['subtitle'],
                    color: _getWasteColor(
                      dummyWasteCategories[1]['color'],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ======================================================
            // CATEGORY ROW 2
            // ======================================================

            Row(
              children: [
                Expanded(
                  child: _WasteCategory(
                    icon: _getWasteIcon(
                      dummyWasteCategories[2]['icon'],
                    ),
                    title: dummyWasteCategories[2]['title'],
                    subtitle:
                        dummyWasteCategories[2]['subtitle'],
                    color: _getWasteColor(
                      dummyWasteCategories[2]['color'],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _WasteCategory(
                    icon: _getWasteIcon(
                      dummyWasteCategories[3]['icon'],
                    ),
                    title: dummyWasteCategories[3]['title'],
                    subtitle:
                        dummyWasteCategories[3]['subtitle'],
                    color: _getWasteColor(
                      dummyWasteCategories[3]['color'],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ======================================================
            // ARTIKEL
            // ======================================================

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Artikel Pilara',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ------------------------------------------------
                // SELENGKAPNYA
                // ------------------------------------------------

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.articles,
                    );
                  },
                  child: Text(
                    'Selengkapnya',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const Text(
              'Tips sederhana untuk menjaga lingkungan.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 15),

            // ======================================================
            // 3 ARTIKEL HOME
            // ======================================================

            SizedBox(
              height: 205,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dummyHomeArticles.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final article =
                      dummyHomeArticles[index];

                  return _ArticleCard(
                    article: article,
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            // ======================================================
            // AKTIVITAS TERBARU
            // ======================================================

            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // ------------------------------------------------------
            // BELUM ADA AKTIVITAS
            // ------------------------------------------------------

            if (dummyRecentActivities.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.eco_outlined,
                      size: 42,
                      color: Colors.green.shade400,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Belum ada aktivitas',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Mulai pilah sampah untuk mendapatkan poin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

            // ------------------------------------------------------
            // AKTIVITAS
            // ------------------------------------------------------

            ...dummyRecentActivities.map(
              (activity) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: _ActivityItem(
                    icon: _getActivityIcon(
                      activity['icon'],
                    ),
                    title: activity['title'],
                    subtitle: activity['subtitle'],
                    points: activity['points'].toString(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// NOTIFICATION SHEET
// ==================================================================

class _NotificationSheet extends StatelessWidget {
  const _NotificationSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        30,
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

          const Row(
            children: [
              Icon(
                Icons.notifications_rounded,
                color: Color(0xFF3F7040),
              ),
              SizedBox(width: 10),
              Text(
                'Notifikasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: 42,
                  color: Colors.green.shade600,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Belum ada notifikasi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Notifikasi aktivitas Pilara akan muncul di sini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
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

// ==================================================================
// WASTE CATEGORY
// ==================================================================

class _WasteCategory extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final MaterialColor color;

  const _WasteCategory({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color[700],
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
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
  final Article article;

  const _ArticleCard({
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.articleDetail,
          arguments: article,
        );
      },
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------
            // FOTO HEADER ARTIKEL
            // --------------------------------------------------

            SizedBox(
              height: 125,
              width: double.infinity,
              child: Image.network(
                article.headerImage,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    color: Colors.green.shade50,
                    child: Icon(
                      article.icon,
                      color: Colors.green.shade700,
                      size: 42,
                    ),
                  );
                },
              ),
            ),

            // --------------------------------------------------
            // JUDUL ARTIKEL
            // --------------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                11,
                14,
                12,
              ),
              child: Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
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
// ACTIVITY ITEM
// ==================================================================

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String points;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.green[700],
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
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Text(
            points,
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// ICON HELPERS
// ==================================================================

IconData _getWasteIcon(String icon) {
  switch (icon) {
    case 'eco':
      return Icons.eco;

    case 'recycling':
      return Icons.recycling;

    case 'warning':
      return Icons.warning_amber;

    case 'delete':
      return Icons.delete_outline;

    default:
      return Icons.delete_outline;
  }
}

// ==================================================================
// ACTIVITY ICON
// ==================================================================

IconData _getActivityIcon(String icon) {
  switch (icon) {
    case 'recycling':
      return Icons.recycling;

    case 'eco':
      return Icons.eco;

    default:
      return Icons.history;
  }
}

// ==================================================================
// WASTE COLOR
// ==================================================================

MaterialColor _getWasteColor(String color) {
  switch (color) {
    case 'green':
      return Colors.green;

    case 'blue':
      return Colors.blue;

    case 'orange':
      return Colors.orange;

    case 'grey':
      return Colors.grey;

    default:
      return Colors.green;
  }
}