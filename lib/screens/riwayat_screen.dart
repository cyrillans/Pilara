import 'package:flutter/material.dart';

import '../data/dummy_riwayat.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  DateTime _selectedMonth = DateTime(2026, 10);
  DateTime? _selectedDate;
  String _selectedFilter = 'Semua';

  final List<Activity> _activities = dummyActivities;

  List<Activity> get _filteredActivities {
    List<Activity> result = _activities.where((activity) {
      final sameMonth =
          activity.date.year == _selectedMonth.year &&
          activity.date.month == _selectedMonth.month;

      if (!sameMonth) return false;

      if (_selectedFilter == 'Semua') return true;

      return activity.category == _selectedFilter;
    }).toList();

    result.sort((a, b) {
      final dateCompare = b.date.compareTo(a.date);

      if (dateCompare != 0) {
        return dateCompare;
      }

      return b.time.compareTo(a.time);
    });

    return result;
  }

  List<Activity> _activitiesForDate(DateTime date) {
    return _activities.where((activity) {
      return activity.date.year == date.year &&
          activity.date.month == date.month &&
          activity.date.day == date.day;
    }).toList();
  }

  bool _hasActivity(DateTime date) {
    return _activitiesForDate(date).isNotEmpty;
  }

  int get _totalPoints {
    return _activities
        .where(
          (activity) =>
              activity.date.year == _selectedMonth.year &&
              activity.date.month == _selectedMonth.month,
        )
        .fold(0, (sum, activity) => sum + activity.points);
  }

  int get _totalActivities {
    return _activities
        .where(
          (activity) =>
              activity.date.year == _selectedMonth.year &&
              activity.date.month == _selectedMonth.month,
        )
        .length;
  }

  int get _sortedCount {
    return _activities
        .where(
          (activity) =>
              activity.date.year == _selectedMonth.year &&
              activity.date.month == _selectedMonth.month &&
              activity.category == 'Dipilah',
        )
        .length;
  }

  int get _depositedCount {
    return _activities
        .where(
          (activity) =>
              activity.date.year == _selectedMonth.year &&
              activity.date.month == _selectedMonth.month &&
              activity.category == 'Disetor',
        )
        .length;
  }

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + offset,
      );
      _selectedDate = null;
    });
  }

  String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return months[month - 1];
  }

  String _dayName(int weekday) {
    const days = [
      'Sen',
      'Sel',
      'Rab',
      'Kam',
      'Jum',
      'Sab',
      'Min',
    ];

    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            SliverToBoxAdapter(
              child: _buildPointsCard(),
            ),
            SliverToBoxAdapter(
              child: _buildStats(),
            ),
            SliverToBoxAdapter(
              child: _buildCalendarSection(),
            ),
            SliverToBoxAdapter(
              child: _buildAchievements(),
            ),
            SliverToBoxAdapter(
              child: _buildChallenge(),
            ),
            SliverToBoxAdapter(
              child: _buildRecommendation(),
            ),
            SliverToBoxAdapter(
              child: _buildFilter(),
            ),
            SliverToBoxAdapter(
              child: _buildActivitySection(),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat Aktivitas',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Pantau perjalananmu dalam memilah sampah',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                _showNotification();
              },
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF43A047),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.22),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Poin Bulan Ini',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$_totalPoints Poin',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Terus kumpulkan poinmu!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Text(
                'LEVEL',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Eco Hero',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 5),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              icon: Icons.recycling_rounded,
              value: '$_sortedCount',
              label: 'Dipilah',
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              icon: Icons.local_shipping_outlined,
              value: '$_depositedCount',
              label: 'Disetor',
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              icon: Icons.event_available_rounded,
              value: '$_totalActivities',
              label: 'Aktivitas',
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 25,
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    final firstDay = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    ).day;

    final startingWeekday = firstDay.weekday;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Kalender Aktivitas',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Text(
                '${_monthName(_selectedMonth.month)} ${_selectedMonth.year}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$_totalActivities aktivitas bulan ini',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              Text(
                '$_totalPoints poin',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: List.generate(
              7,
              (index) => Expanded(
                child: Center(
                  child: Text(
                    _dayName(index + 1),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: startingWeekday - 1 + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              if (index < startingWeekday - 1) {
                return const SizedBox();
              }

              final day = index - startingWeekday + 2;

              final date = DateTime(
                _selectedMonth.year,
                _selectedMonth.month,
                day,
              );

              final hasActivity = _hasActivity(date);
              final isSelected = _selectedDate != null &&
                  _selectedDate!.year == date.year &&
                  _selectedDate!.month == date.month &&
                  _selectedDate!.day == date.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });

                  _showDateDetail(date);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.green.shade100
                        : hasActivity
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(
                            color: Colors.green,
                            width: 1.5,
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: hasActivity
                              ? Colors.green.shade800
                              : Colors.red.shade400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasActivity ? '😊' : '•',
                        style: TextStyle(
                          fontSize: hasActivity ? 13 : 15,
                          color: hasActivity
                              ? Colors.green
                              : Colors.red.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _calendarLegend(
                color: Colors.green.shade50,
                icon: '😊',
                label: 'Ada aktivitas',
              ),
              const SizedBox(width: 15),
              _calendarLegend(
                color: Colors.red.shade50,
                icon: '•',
                label: 'Tidak ada aktivitas',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _calendarLegend({
    required Color color,
    required String icon,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 27,
          height: 27,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            icon,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    final badges = dummyBadges;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pencapaian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 125,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: badges.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final badge = badges[index];

                return Container(
                  width: 130,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        badge.icon,
                        style: const TextStyle(fontSize: 27),
                      ),
                      const Spacer(),
                      Text(
                        badge.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        badge.subtitle,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallenge() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.orange.shade100,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🔥',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Challenge',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pilah sampah 5 hari berturut-turut',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 9),
                LinearProgressIndicator(
                  value: 0.6,
                  minHeight: 6,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            '3/5',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: Colors.green.shade700,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips untukmu',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kamu cukup aktif memilah sampah anorganik. '
                  'Coba mulai memilah sampah organik juga!',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green.shade900,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    final filters = ['Semua', 'Dipilah', 'Disetor'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aktivitas Terbaru',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((filter) {
                final selected = _selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: Colors.green.shade100,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selected
                          ? Colors.green.shade800
                          : Colors.grey.shade700,
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: selected
                          ? Colors.green.shade300
                          : Colors.grey.shade200,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    final activities = _filteredActivities;

    if (activities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 45,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 10),
                Text(
                  'Belum ada aktivitas',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: activities.map(_activityTile).toList(),
      ),
    );
  }

  Widget _activityTile(Activity activity) {
    return GestureDetector(
      onTap: () {
        _showActivityDetail(activity);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 9,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                activity.icon,
                color: Colors.green.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    activity.subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${activity.date.day} ${_monthName(activity.date.month)} • ${activity.time}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+${activity.points}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: activity.category == 'Disetor'
                        ? Colors.orange.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    activity.category,
                    style: TextStyle(
                      fontSize: 9,
                      color: activity.category == 'Disetor'
                          ? Colors.orange.shade800
                          : Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDateDetail(DateTime date) {
    final activities = _activitiesForDate(date);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
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
                Text(
                  '${date.day} ${_monthName(date.month)} ${date.year}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  activities.isEmpty
                      ? 'Tidak ada aktivitas pada hari ini.'
                      : '${activities.length} aktivitas',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 15),
                if (activities.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Center(
                      child: Text(
                        '😊 Tidak apa-apa.\n'
                        'Tetap semangat memilah sampah!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  )
                else
                  ...activities.map(_detailActivityTile),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailActivityTile(Activity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            activity.icon,
            color: Colors.green,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${activity.time} • ${activity.subtitle}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${activity.points}',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showActivityDetail(Activity activity) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
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
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        activity.icon,
                        color: Colors.green.shade700,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            activity.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+${activity.points}',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _detailRow(
                  Icons.calendar_today_outlined,
                  'Tanggal',
                  '${activity.date.day} ${_monthName(activity.date.month)} ${activity.date.year}',
                ),
                _detailRow(
                  Icons.access_time_rounded,
                  'Waktu',
                  activity.time,
                ),
                _detailRow(
                  Icons.delete_outline_rounded,
                  'Jenis Sampah',
                  activity.wasteType,
                ),
                _detailRow(
                  Icons.info_outline_rounded,
                  'Keterangan',
                  activity.subtitle,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: Colors.green.shade700,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotification() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return const SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.green,
                  size: 45,
                ),
                SizedBox(height: 12),
                Text(
                  'Belum Ada Notifikasi',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Notifikasi aktivitas dan pencapaianmu akan muncul di sini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}