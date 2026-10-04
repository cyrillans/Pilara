import 'package:flutter/material.dart';

class WastePointDummy {
  final String name;
  final String address;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> acceptedWaste;
  final double rating;
  final String openTime;
  final IconData icon;

  const WastePointDummy({
    required this.name,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.acceptedWaste,
    required this.rating,
    required this.openTime,
    required this.icon,
  });
}

// ============================================================
// DATA DUMMY LOKASI PILAH
// ============================================================
//
// Data ini masih berupa data demo untuk kebutuhan pengembangan UI.
//
// GPS pengguna dan peta yang ditampilkan tetap menggunakan
// data lokasi nyata dari perangkat.
//
// Nantinya data lokasi ini dapat diganti dengan data dari:
// Firebase / API / database.
// ============================================================

const List<WastePointDummy> dummyWastePoints = [
  WastePointDummy(
    name: 'Titik Pilah Organik',
    address: 'Lokasi pengelolaan sampah organik',
    description:
        'Menerima sampah organik seperti sisa makanan, daun, dan limbah dapur.',
    latitude: 0.5105,
    longitude: 101.4515,
    acceptedWaste: [
      'Organik',
    ],
    rating: 4.7,
    openTime: '08.00 - 17.00',
    icon: Icons.eco_rounded,
  ),

  WastePointDummy(
    name: 'Titik Daur Ulang Anorganik',
    address: 'Lokasi pengumpulan sampah anorganik',
    description:
        'Menerima botol plastik, kardus, kertas, kaleng, dan material daur ulang.',
    latitude: 0.5028,
    longitude: 101.4430,
    acceptedWaste: [
      'Anorganik',
    ],
    rating: 4.8,
    openTime: '08.00 - 18.00',
    icon: Icons.recycling_rounded,
  ),

  WastePointDummy(
    name: 'Titik Pengumpulan B3',
    address: 'Lokasi khusus limbah B3',
    description:
        'Area khusus untuk pengumpulan limbah berbahaya seperti baterai dan lampu.',
    latitude: 0.5135,
    longitude: 101.4400,
    acceptedWaste: [
      'B3',
    ],
    rating: 4.6,
    openTime: '09.00 - 16.00',
    icon: Icons.warning_amber_rounded,
  ),

  WastePointDummy(
    name: 'Titik Sampah Campuran',
    address: 'Lokasi pengelolaan sampah lainnya',
    description:
        'Tempat pengumpulan untuk kategori sampah yang belum termasuk kategori utama.',
    latitude: 0.4980,
    longitude: 101.4540,
    acceptedWaste: [
      'Lainnya',
    ],
    rating: 4.5,
    openTime: '08.00 - 17.00',
    icon: Icons.delete_sweep_rounded,
  ),
];