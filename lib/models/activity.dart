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
