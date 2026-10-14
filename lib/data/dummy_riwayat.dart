import 'package:flutter/material.dart';

class Activity {
  final DateTime date;
  final String time;
  final String title;
  final String subtitle;
  final String category;
  final String wasteType;
  final int points;
  final IconData icon;

  const Activity({
    required this.date,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.wasteType,
    required this.points,
    required this.icon,
  });
}

final List<Activity> dummyActivities = [
  Activity(
    date: DateTime(2026, 10, 12),
    time: '18:45',
    title: 'Setoran Sampah',
    subtitle: '2.5 kg sampah disetor',
    category: 'Disetor',
    wasteType: 'Campuran',
    points: 100,
    icon: Icons.recycling_rounded,
  ),
  Activity(
    date: DateTime(2026, 10, 12),
    time: '14:17',
    title: 'Kardus',
    subtitle: 'Sampah anorganik dipilah',
    category: 'Dipilah',
    wasteType: 'Anorganik',
    points: 80,
    icon: Icons.inventory_2_rounded,
  ),
  Activity(
    date: DateTime(2026, 10, 12),
    time: '08:32',
    title: 'Botol Plastik',
    subtitle: 'Berhasil diidentifikasi',
    category: 'Dipilah',
    wasteType: 'Anorganik',
    points: 50,
    icon: Icons.local_drink_rounded,
  ),
  Activity(
    date: DateTime(2026, 10, 11),
    time: '16:20',
    title: 'Sisa Makanan',
    subtitle: 'Sampah organik dipilah',
    category: 'Dipilah',
    wasteType: 'Organik',
    points: 40,
    icon: Icons.eco_rounded,
  ),
  Activity(
    date: DateTime(2026, 10, 10),
    time: '19:05',
    title: 'Setoran Daur Ulang',
    subtitle: '1.8 kg sampah disetor',
    category: 'Disetor',
    wasteType: 'Anorganik',
    points: 90,
    icon: Icons.recycling_rounded,
  ),
  Activity(
    date: DateTime(2026, 10, 10),
    time: '10:12',
    title: 'Kaleng Minuman',
    subtitle: 'Berhasil diidentifikasi',
    category: 'Dipilah',
    wasteType: 'Anorganik',
    points: 50,
    icon: Icons.circle_outlined,
  ),
  Activity(
    date: DateTime(2026, 10, 9),
    time: '15:30',
    title: 'Kantong Plastik',
    subtitle: 'Sampah anorganik dipilah',
    category: 'Dipilah',
    wasteType: 'Anorganik',
    points: 40,
    icon: Icons.shopping_bag_outlined,
  ),
  Activity(
    date: DateTime(2026, 10, 8),
    time: '17:10',
    title: 'Kertas',
    subtitle: 'Sampah anorganik dipilah',
    category: 'Dipilah',
    wasteType: 'Anorganik',
    points: 40,
    icon: Icons.description_outlined,
  ),
  Activity(
    date: DateTime(2026, 10, 8),
    time: '09:25',
    title: 'Botol Plastik',
    subtitle: 'Berhasil diidentifikasi',
    category: 'Dipilah',
    wasteType: 'Anorganik',
    points: 50,
    icon: Icons.local_drink_rounded,
  ),
  Activity(
    date: DateTime(2026, 10, 6),
    time: '12:15',
    title: 'Sisa Makanan',
    subtitle: 'Sampah organik dipilah',
    category: 'Dipilah',
    wasteType: 'Organik',
    points: 40,
    icon: Icons.eco_rounded,
  ),
  Activity(
    date: DateTime(2026, 10, 5),
    time: '16:45',
    title: 'Setoran Daur Ulang',
    subtitle: '3.2 kg sampah disetor',
    category: 'Disetor',
    wasteType: 'Campuran',
    points: 120,
    icon: Icons.recycling_rounded,
  ),
  Activity(
    date: DateTime(2026, 10, 4),
    time: '10:30',
    title: 'Kardus',
    subtitle: 'Sampah anorganik dipilah',
    category: 'Dipilah',
    wasteType: 'Anorganik',
    points: 60,
    icon: Icons.inventory_2_rounded,
  ),
  Activity(
    date: DateTime(2026, 10, 3),
    time: '09:15',
    title: 'Botol Plastik',
    subtitle: 'Berhasil diidentifikasi',
    category: 'Dipilah',
    wasteType: 'Anorganik',
    points: 50,
    icon: Icons.local_drink_rounded,
  ),
  Activity(
    date: DateTime(2026, 10, 2),
    time: '15:40',
    title: 'Setoran Sampah',
    subtitle: '2.0 kg sampah disetor',
    category: 'Disetor',
    wasteType: 'Campuran',
    points: 100,
    icon: Icons.recycling_rounded,
  ),
  Activity(
    date: DateTime(2026, 10, 1),
    time: '08:20',
    title: 'Kardus',
    subtitle: 'Sampah anorganik dipilah',
    category: 'Dipilah',
    wasteType: 'Anorganik',
    points: 50,
    icon: Icons.inventory_2_rounded,
  ),
];

class Badge {
  final String icon;
  final String title;
  final String subtitle;

  const Badge({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

const List<Badge> dummyBadges = [
  Badge(
    icon: '♻️',
    title: 'Pemilah Aktif',
    subtitle: '10x memilah',
  ),
  Badge(
    icon: '⭐',
    title: '1K Poin',
    subtitle: 'Tercapai',
  ),
  Badge(
    icon: '🔥',
    title: '7 Hari',
    subtitle: 'Streak',
  ),
  Badge(
    icon: '🌱',
    title: 'Eco Starter',
    subtitle: 'Pemula',
  ),
];