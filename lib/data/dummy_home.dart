// ============================================================
// DUMMY DATA HOME PILARA
// ============================================================
//
// File ini khusus menyimpan data sementara untuk halaman Home.
// Tidak berisi widget atau kode tampilan.
//
// ============================================================

import 'dummy_articles.dart';

// ============================================================
// POIN AWAL USER
// ============================================================

const int dummyInitialPoints = 0;

// ============================================================
// KATEGORI SAMPAH
// ============================================================

const List<Map<String, dynamic>> dummyWasteCategories = [
  {
    'icon': 'eco',
    'title': 'Organik',
    'subtitle': 'Sisa makanan',
    'color': 'green',
  },
  {
    'icon': 'recycling',
    'title': 'Anorganik',
    'subtitle': 'Plastik & botol',
    'color': 'blue',
  },
  {
    'icon': 'warning',
    'title': 'B3',
    'subtitle': 'Limbah berbahaya',
    'color': 'orange',
  },
  {
    'icon': 'delete',
    'title': 'Lainnya',
    'subtitle': 'Sampah lainnya',
    'color': 'grey',
  },
];

// ============================================================
// ARTIKEL UNTUK HOME
// ============================================================
//
// Home hanya menampilkan 3 artikel pertama.
// Data lengkap artikel berada di dummy_articles.dart.
//
// ============================================================

final List<Article> dummyHomeArticles =
    dummyArticles.take(3).toList();

// ============================================================
// AKTIVITAS TERBARU
// ============================================================

const List<Map<String, dynamic>> dummyRecentActivities = [];