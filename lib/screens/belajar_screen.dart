import 'package:flutter/material.dart';

import '../services/pilara_api.dart';

// ==================================================================
// 1. MODEL & DATA
// ==================================================================

class TutorialStep {
  final String title;
  final String description;
  final List<String> details;
  final String? tip;
  final String? duration;
  final String? imageAsset;

  const TutorialStep({
    required this.title,
    required this.description,
    this.details = const [],
    this.tip,
    this.duration,
    this.imageAsset,
  });
}

class Idea {
  final String title;
  final String desc;
  const Idea(this.title, this.desc);
}

class Trouble {
  final String q;
  final String a;
  const Trouble(this.q, this.a);
}

class Tutorial {
  final String id;
  final String title;
  final String duration;
  final String level;
  final String shortDesc;
  final String heroColorHex;
  final String? imageAsset;
  final String iconName;
  final List<String> tools;
  final List<String> materials;
  final List<TutorialStep> steps;
  final String harvest;
  final List<String> signs;
  final List<Idea> development;
  final List<Trouble> troubles;

  const Tutorial({
    required this.id,
    required this.title,
    required this.duration,
    required this.level,
    required this.shortDesc,
    required this.heroColorHex,
    this.imageAsset,
    required this.iconName,
    required this.tools,
    required this.materials,
    required this.steps,
    required this.harvest,
    required this.signs,
    required this.development,
    required this.troubles,
  });

  Color get heroColor => Color(int.parse(heroColorHex.replaceAll('#', '0xFF')));
}

// ==================================================================
// PROGRES & UPDATE (MONITORING)
// ==================================================================

class ProgressStore extends ChangeNotifier {
  final Map<String, int> _done = {};
  final Set<String> _started = {};

  bool isStarted(String id) => _started.contains(id);
  int doneCount(String id) => _done[id] ?? 0;
  bool isFinished(Tutorial t) => doneCount(t.id) >= t.steps.length;

  Future<void> load() async {
    final progress = await PilaraApi.instance.tutorialProgress();
    _done.clear();
    _started.clear();
    for (final item in progress) {
      _done[item.tutorialId] = item.completedSteps;
      _started.add(item.tutorialId);
    }
    notifyListeners();
  }

  Future<void> start(String id) async {
    await _save(id, 0);
  }

  Future<void> setDone(String id, int n) async {
    await _save(id, n);
  }

  Future<void> _save(String id, int completedSteps) async {
    final saved = await PilaraApi.instance.saveTutorialProgress(
      tutorialId: id,
      completedSteps: completedSteps,
    );
    _done[id] = saved.completedSteps;
    _started.add(id);
    notifyListeners();
  }

  Future<void> reset(String id) async {
    await PilaraApi.instance.resetTutorialProgress(id);
    _started.remove(id);
    _done.remove(id);
    notifyListeners();
  }
}

final progressStore = ProgressStore();

// ==================================================================
// DATA (10 TUTORIAL)
// ==================================================================

const List<Tutorial> tutorials = [
  Tutorial(
    id: 't1',
    title: 'Biopori',
    duration: '1 hari',
    level: 'Mudah',
    shortDesc:
        'Lubang resapan yang mengubah sampah dapur jadi kompos di dalam tanah.',
    heroColorHex: '#E3F2FD',
    iconName: 'water_drop',
    imageAsset: 'assets/images/biopori.jpg',
    tools: [
      'Bor biopori 10 cm',
      'Meteran',
      'Gergaji / cutter pipa',
      'Sarung tangan'
    ],
    materials: [
      'Pipa PVC 4 inci, ±30 cm',
      'Sampah organik (sisa sayur, buah, daun)',
      'Penutup pipa atau kawat kasa'
    ],
    steps: [
      TutorialStep(
          title: 'Tentukan lokasi',
          description: 'Pilih titik yang dilalui aliran air hujan.',
          duration: '10 menit',
          details: [
            'Pilih dasar talang, sekitar pohon, atau saluran halaman',
            'Jarak antar lubang 50–100 cm',
            'Jauhi pondasi bangunan dan septic tank'
          ],
          tip: 'Titik genangan air adalah lokasi paling efektif.'),
      TutorialStep(
          title: 'Bor lubang',
          description: 'Kedalaman ±100 cm dengan diameter 10 cm.',
          duration: '30 menit',
          details: [
            'Putar bor searah jarum jam sambil ditekan',
            'Angkat tanah setiap ±20 cm',
            'Berhenti sebelum menyentuh muka air tanah'
          ],
          tip: 'Tanah keras? Siram dulu agar lebih mudah dibor.'),
      TutorialStep(
          title: 'Pasang pipa PVC',
          description: 'Pipa mencegah bibir lubang longsor.',
          duration: '10 menit',
          details: [
            'Potong pipa sepanjang ±30 cm',
            'Masukkan di bibir lubang, rata dengan tanah',
            'Padatkan tanah di sekeliling pipa'
          ]),
      TutorialStep(
          title: 'Isi sampah organik',
          description: 'Masukkan sisa dapur yang mudah terurai.',
          duration: '10 menit',
          details: [
            'Masukkan sisa sayur, buah, dan daun',
            'Hindari plastik, kaca, daging, dan minyak',
            'Isi sampai ¾ penuh lalu tutup'
          ]),
      TutorialStep(
          title: 'Isi ulang berkala',
          description: 'Tambah sampah saat volumenya menyusut.',
          duration: 'Rutin',
          details: [
            'Cek setiap 1–2 minggu',
            'Tambahkan sampah baru di atasnya',
            'Siram sedikit saat musim kemarau'
          ]),
      TutorialStep(
          title: 'Panen kompos',
          description: 'Ambil kompos setelah 2–3 bulan.',
          duration: '20 menit',
          details: [
            'Keluarkan sampah lapuk dengan sekop kecil',
            'Kompos matang berwarna gelap dan gembur',
            'Isi kembali lubang dengan sampah baru'
          ]),
    ],
    harvest:
        'Biopori menghasilkan kompos langsung di dalam lubang. Ambil setelah 2–3 bulan, lalu lubang bisa dipakai lagi.',
    signs: [
      'Sampah berubah gelap dan remah',
      'Tidak berbau busuk',
      'Volume sampah menyusut jauh'
    ],
    development: [
      Idea('Tambah jumlah lubang',
          'Buat beberapa lubang di halaman untuk menampung lebih banyak sampah.'),
      Idea('Tanam di sekitar lubang',
          'Tanaman di sekelilingnya ikut mendapat nutrisi.'),
      Idea('Ajak tetangga', 'Buat biopori kolektif di lingkungan RT.')
    ],
    troubles: [
      Trouble('Lubang berbau busuk?',
          'Biasanya terlalu banyak sampah basah. Kurangi sampah basah, tambahkan daun kering.'),
      Trouble('Bibir lubang cepat longsor?',
          'Pasang pipa lebih dalam dan padatkan tanah.')
    ],
  ),
  Tutorial(
    id: 't2',
    title: 'Komposter',
    duration: '1–2 bulan',
    level: 'Mudah',
    shortDesc: 'Wadah pengomposan skala rumah untuk sisa dapur dan daun.',
    heroColorHex: '#E8F5E9',
    iconName: 'recycling',
    imageAsset: 'assets/images/komposter.jpg',
    tools: [
      'Bor untuk lubang ventilasi',
      'Sekop kecil / garpu taman',
      'Pisau atau gunting pencacah',
      'Sarung tangan'
    ],
    materials: [
      'Tong / ember bertutup 20–60 L',
      'Sampah hijau (sisa sayur dan buah)',
      'Sampah cokelat (daun kering, kardus sobekan)',
      'Segenggam tanah atau kompos jadi (starter)',
      'Air dalam botol semprot'
    ],
    steps: [
      TutorialStep(
          title: 'Siapkan komposter',
          description: 'Gunakan wadah tertutup yang berventilasi.',
          duration: '20 menit',
          details: [
            'Buat lubang ±0,5 cm di sisi dan tutup wadah',
            'Beri lubang kecil di dasar untuk drainase',
            'Letakkan di tempat teduh dan beralas'
          ]),
      TutorialStep(
          title: 'Lapisi dasar',
          description: 'Mulai dengan bahan kering agar udara mengalir.',
          duration: '5 menit',
          details: [
            'Alasi dengan ±5 cm daun kering atau ranting kecil',
            'Lapisan ini menyerap cairan berlebih'
          ]),
      TutorialStep(
          title: 'Masukkan sampah organik',
          description: 'Cacah agar cepat terurai.',
          duration: '15 menit',
          details: [
            'Cacah ukuran ±2–3 cm',
            'Rasio bahan kering : basah ±2 : 1',
            'Hindari daging, susu, dan makanan berminyak'
          ],
          tip: 'Terlalu basah? Tambah daun kering atau kardus sobekan.'),
      TutorialStep(
          title: 'Tambahkan starter',
          description: 'Tanah atau kompos jadi membawa mikroorganisme.',
          duration: '5 menit',
          details: [
            'Taburkan 1–2 genggam tanah subur atau kompos jadi',
            'Percikkan air hingga lembap seperti spons diperas'
          ]),
      TutorialStep(
          title: 'Aduk berkala',
          description: 'Aduk seminggu sekali agar udara masuk.',
          duration: 'Mingguan',
          details: [
            'Aduk dari bawah ke atas',
            'Remas sedikit: lembap tapi tidak menetes',
            'Tumpukan terasa hangat berarti proses berjalan baik'
          ]),
      TutorialStep(
          title: 'Panen kompos',
          description: 'Siap dipakai setelah 1–2 bulan.',
          duration: '30 menit',
          details: [
            'Ayak untuk memisahkan bagian kasar',
            'Bagian kasar dikembalikan ke komposter',
            'Simpan kompos halus di wadah teduh'
          ]),
    ],
    harvest:
        'Kompos matang berwarna cokelat kehitaman, remah, dan berbau seperti tanah.',
    signs: [
      'Bentuk bahan awal tidak lagi terlihat',
      'Tumpukan sudah tidak panas',
      'Berbau tanah, bukan busuk'
    ],
    development: [
      Idea('Campur media tanam', 'Campur kompos dengan tanah, misalnya 1 : 3.'),
      Idea('Teh kompos',
          'Rendam kompos dalam air 1–2 hari, saring, lalu siramkan.'),
      Idea('Pakai dua wadah', 'Satu wadah diisi sambil yang lain matang.')
    ],
    troubles: [
      Trouble('Berbau menyengat?',
          'Kemungkinan terlalu basah atau kurang udara. Tambah bahan kering dan aduk lebih sering.'),
      Trouble('Banyak belatung?',
          'Tutup sampah baru dengan daun kering atau tanah.')
    ],
  ),
  Tutorial(
    id: 't3',
    title: 'Ecoenzim dari Kulit Buah',
    duration: '3 bulan',
    level: 'Mudah',
    shortDesc: 'Fermentasi kulit buah menjadi cairan serbaguna.',
    heroColorHex: '#FFF3E0',
    iconName: 'science',
    imageAsset: 'assets/images/ecoenzim.jpg',
    tools: [
      'Timbangan dapur',
      'Gelas ukur',
      'Pisau dan talenan',
      'Saringan dan corong'
    ],
    materials: [
      'Kulit buah segar 300 g',
      'Gula merah atau molase 100 g',
      'Air bersih 1 L',
      'Botol plastik tebal 2 L, mulut lebar',
      'Label dan spidol'
    ],
    steps: [
      TutorialStep(
          title: 'Kumpulkan kulit buah',
          description: 'Pilih kulit yang segar dan tidak berjamur.',
          duration: '1–3 hari',
          details: [
            'Bisa kulit jeruk, nanas, apel, pepaya',
            'Campuran beberapa buah lebih baik',
            'Jangan pakai yang berjamur atau busuk'
          ],
          tip: 'Simpan di freezer sampai terkumpul 300 g.'),
      TutorialStep(
          title: 'Potong kecil-kecil',
          description: 'Ukuran sekitar 2 cm.',
          duration: '10 menit',
          details: [
            'Cuci ringan kulit buah',
            'Potongan kecil mempercepat fermentasi'
          ]),
      TutorialStep(
          title: 'Campur bahan',
          description: 'Rasio gula : kulit : air = 1 : 3 : 10.',
          duration: '10 menit',
          details: [
            'Larutkan 100 g gula merah dalam 1 L air',
            'Masukkan kulit buah',
            'Sisakan ruang kosong 20–30% di wadah',
            'Tulis tanggal pembuatan di label'
          ],
          tip: 'Jangan penuhi wadah, gas fermentasi butuh ruang.'),
      TutorialStep(
          title: 'Tutup dan lepas gas',
          description: 'Fermentasi menghasilkan gas.',
          duration: '2 minggu pertama',
          details: [
            'Minggu 1–2: buka tutup sebentar tiap hari',
            'Setelahnya cukup seminggu sekali',
            'Simpan di tempat teduh',
            'Lapisan putih tipis masih wajar'
          ]),
      TutorialStep(
          title: 'Tunggu fermentasi',
          description: 'Biarkan hingga total 3 bulan.',
          duration: '±90 hari',
          details: [
            'Hitung 90 hari sejak hari pembuatan',
            'Tidak perlu diaduk',
            'Aroma akan berubah menjadi asam segar'
          ]),
      TutorialStep(
          title: 'Saring dan simpan',
          description: 'Panen cairan setelah 3 bulan.',
          duration: '20 menit',
          details: [
            'Saring dengan kain atau saringan halus',
            'Simpan cairan di botol bersih bertutup',
            'Ampas jangan dibuang, masih bisa dipakai'
          ]),
    ],
    harvest:
        'Cairan ecoenzim berwarna cokelat tua dengan aroma asam segar. Bisa dipakai sebagai pembersih, pupuk cair, atau penyegar ruangan.',
    signs: [
      'Warna cokelat tua',
      'Aroma asam segar, bukan busuk',
      'Gelembung gas sudah jarang'
    ],
    development: [
      Idea('Pembersih rumah',
          'Encerkan dengan air 1 : 100 untuk lantai dan kamar mandi.'),
      Idea('Pupuk cair',
          'Encerkan 1 : 500 sampai 1 : 1000, lalu siram ke tanaman.'),
      Idea('Manfaatkan ampas', 'Blender ampas untuk bahan ecoenzim berikutnya.')
    ],
    troubles: [
      Trouble('Tutup menggembung?',
          'Normal di awal karena gas fermentasi. Buka tutup perlahan.'),
      Trouble('Muncul jamur atau belatung?',
          'Jamur putih tipis wajar. Jika jamur hitam atau bau busuk, ulangi dari awal.')
    ],
  ),
  Tutorial(
    id: 't4',
    title: 'Maggot BSF',
    duration: '14–18 hari',
    level: 'Sedang',
    shortDesc:
        'Larva lalat tentara hitam yang cepat menghabiskan sampah dapur.',
    heroColorHex: '#FFF8E1',
    iconName: 'bug_report',
    imageAsset: 'assets/images/maggot.jpg',
    tools: [
      'Wadah / biopond ±40 × 60 cm',
      'Pisau atau blender pencacah',
      'Ayakan',
      'Jaring penutup'
    ],
    materials: [
      'Sisa makanan (nasi, sayur, buah)',
      'Bibit maggot BSF (larva muda)',
      'Dedak atau ampas sebagai campuran'
    ],
    steps: [
      TutorialStep(
          title: 'Siapkan wadah',
          description: 'Gunakan wadah plastik atau kayu dengan drainase.',
          duration: '20 menit',
          details: [
            'Beri lubang drainase agar tidak becek',
            'Tutup dengan jaring agar lalat lain tidak masuk',
            'Letakkan di tempat teduh'
          ]),
      TutorialStep(
          title: 'Siapkan pakan',
          description: 'Cacah sisa makanan agar mudah dimakan.',
          duration: '15 menit',
          details: [
            'Cacah ±1–2 cm',
            'Campur sampah basah dengan sedikit bahan kering',
            'Hindari banyak daging, tulang, minyak, jeruk, pedas'
          ]),
      TutorialStep(
          title: 'Tebar bibit',
          description: 'Mulai dengan larva muda yang sehat.',
          duration: '5 menit',
          details: [
            'Taburkan larva merata di atas pakan',
            'Makin banyak larva, makin cepat sampah habis',
            'Jangan tebar saat pakan terlalu basah'
          ]),
      TutorialStep(
          title: 'Beri makan rutin',
          description: 'Tambah pakan secara bertahap setiap hari.',
          duration: 'Harian',
          details: [
            'Beri pakan pagi dan sore',
            'Jaga media tetap lembap',
            '1 kg maggot menghabiskan ±2 kg sampah per hari'
          ],
          tip: 'Jika pakan belum habis dalam 24 jam, kurangi porsinya.'),
      TutorialStep(
          title: 'Panen maggot',
          description: 'Panen larva umur ±14–18 hari.',
          duration: '30 menit',
          details: [
            'Larva besar berwarna krem hingga cokelat',
            'Pisahkan dengan ayakan',
            'Prepupa akan merayap keluar sendiri'
          ]),
      TutorialStep(
          title: 'Pisahkan kasgot',
          description: 'Residu sisa maggot disebut kasgot.',
          duration: '20 menit',
          details: [
            'Ayak untuk memisahkan sisa maggot',
            'Angin-anginkan sampai kering',
            'Pakai sebagai pupuk organik'
          ]),
    ],
    harvest:
        'Maggot segar dan kasgot (pupuk). Maggot bisa menjadi pakan ayam, bebek, atau ikan.',
    signs: [
      'Larva gemuk dan aktif',
      'Sampah menyusut drastis',
      'Prepupa mulai merayap menjauh'
    ],
    development: [
      Idea('Siklus penuh',
          'Sisihkan sebagian prepupa agar menjadi lalat dewasa dan bertelur.'),
      Idea('Pakan ternak', 'Maggot segar/kering mengurangi biaya pakan.'),
      Idea('Jual hasil', 'Maggot dan kasgot punya nilai jual.')
    ],
    troubles: [
      Trouble('Wadah berbau menyengat?',
          'Terlalu basah atau pakan berlebih. Tambah bahan kering, kurangi porsi.'),
      Trouble('Maggot merayap keluar?',
          'Bisa jadi sudah prepupa, atau media terlalu basah. Beri wadah penampung.')
    ],
  ),
  Tutorial(
    id: 't5',
    title: 'Bokashi',
    duration: '2 minggu',
    level: 'Mudah',
    shortDesc:
        'Fermentasi sampah dapur dalam ember kedap udara dengan aktivator.',
    heroColorHex: '#E1F5FE',
    iconName: 'compost',
    imageAsset: 'assets/images/bokashi.jpg',
    tools: [
      'Sendok takar',
      'Pemadat atau penumbuk',
      'Pisau dan talenan',
      'Gelas penampung lindi'
    ],
    materials: [
      'Ember kedap udara ber-kran ±20 L',
      'Aktivator bokashi (dedak + EM4)',
      'Sisa makanan (nasi, sayur, buah, lauk)'
    ],
    steps: [
      TutorialStep(
          title: 'Siapkan ember',
          description: 'Pastikan kedap udara dan ada kran di bawah.',
          duration: '10 menit',
          details: [
            'Cuci bersih dan keringkan',
            'Pasang saringan di dasar',
            'Taruh di ruangan teduh'
          ]),
      TutorialStep(
          title: 'Taburi aktivator dasar',
          description: 'Lapisan aktivator pertama di dasar ember.',
          duration: '2 menit',
          details: ['Taburkan aktivator tipis dan merata di dasar']),
      TutorialStep(
          title: 'Masukkan sampah',
          description: 'Cacah dan padatkan per lapisan.',
          duration: '10 menit',
          details: [
            'Cacah sisa makanan ±3 cm',
            'Tekan agar udara keluar',
            'Taburi aktivator tiap lapisan ±5 cm',
            'Tutup rapat'
          ],
          tip: 'Tiriskan sampah basah dulu agar lindi tidak berlebihan.'),
      TutorialStep(
          title: 'Fermentasi',
          description: 'Setelah ember penuh, tutup rapat 2 minggu.',
          duration: '2 minggu',
          details: [
            'Jangan dibuka selama fermentasi',
            'Kuras lindi lewat kran setiap 2–3 hari',
            'Simpan di tempat teduh'
          ]),
      TutorialStep(
          title: 'Olah hasil',
          description: 'Kubur atau campur dengan tanah.',
          duration: '30 menit',
          details: [
            'Gali lubang di tanah',
            'Campur dengan tanah dan diamkan ±2 minggu',
            'Bisa juga dimasukkan ke komposter'
          ]),
    ],
    harvest:
        'Sampah terfermentasi beraroma asam manis, serta lindi yang bisa dijadikan pupuk cair.',
    signs: [
      'Aroma asam seperti tape',
      'Boleh ada jamur putih',
      'Sampah tampak utuh tetapi lunak'
    ],
    development: [
      Idea('Pupuk cair', 'Encerkan lindi 1 : 100 sebelum disiramkan.'),
      Idea('Media tanam',
          'Campur hasil bokashi dengan tanah, diamkan 2 minggu.'),
      Idea('Dua ember', 'Gunakan bergantian agar proses berjalan terus.')
    ],
    troubles: [
      Trouble('Ada jamur?',
          'Jamur putih normal. Jamur hijau/hitam + bau busuk = gagal, buang dan ulangi.'),
      Trouble('Lindi terlalu banyak?',
          'Tiriskan sampah sebelum dimasukkan dan kuras kran lebih sering.')
    ],
  ),
  Tutorial(
    id: 't6',
    title: 'Vermikompos',
    duration: '1–2 bulan',
    level: 'Sedang',
    shortDesc: 'Cacing tanah mengurai sampah lunak menjadi kascing.',
    heroColorHex: '#FCE4EC',
    iconName: 'spa',
    imageAsset: 'assets/images/vermikompos.jpg',
    tools: [
      'Bor untuk lubang kotak',
      'Sekop kecil atau garpu',
      'Botol semprot',
      'Sarung tangan'
    ],
    materials: [
      '2 kotak plastik bersusun (berlubang)',
      'Cacing pengurai ±250 g',
      'Media: cocopeat, kertas sobek',
      'Sampah organik lunak',
      'Kain penutup'
    ],
    steps: [
      TutorialStep(
          title: 'Siapkan kotak',
          description: 'Beri lubang sirkulasi udara dan drainase.',
          duration: '20 menit',
          details: [
            'Lubang ±0,5 cm di sisi, tutup, dan dasar',
            'Letakkan wadah penampung di bawah',
            'Taruh di tempat teduh'
          ]),
      TutorialStep(
          title: 'Siapkan media',
          description: 'Media harus lembap dan gembur.',
          duration: '15 menit',
          details: [
            'Campur cocopeat, kertas sobek, daun kering',
            'Lembapkan seperti spons diperas',
            'Ketebalan ±10–15 cm'
          ]),
      TutorialStep(
          title: 'Tebar cacing',
          description: 'Biarkan cacing beradaptasi 1–2 hari.',
          duration: '5 menit',
          details: [
            'Letakkan cacing di atas media',
            'Tutup dengan kain lembap',
            'Jangan beri makan banyak dulu'
          ]),
      TutorialStep(
          title: 'Beri makan',
          description: 'Mulai dari sampah lunak yang dicacah.',
          duration: 'Mingguan',
          details: [
            'Kubur sampah di satu sisi kotak',
            'Beri makan lagi setelah yang lama habis',
            'Hindari jeruk, bawang, daging, berminyak'
          ]),
      TutorialStep(
          title: 'Jaga kelembapan',
          description: 'Semprot air jika media mulai kering.',
          duration: 'Rutin',
          details: [
            'Media lembap, tidak becek',
            'Kuras lindi di wadah bawah',
            'Hindari panas dan hujan'
          ]),
      TutorialStep(
          title: 'Panen kascing',
          description: 'Pisahkan kascing dari cacing.',
          duration: '30 menit',
          details: [
            'Hentikan pakan 1–2 minggu',
            'Taruh makanan baru di satu sisi',
            'Ambil kascing di sisi lainnya'
          ]),
    ],
    harvest:
        'Kascing berupa butiran halus kehitaman yang kaya hara, serta lindi cacing untuk pupuk cair.',
    signs: [
      'Media tampak seperti butiran tanah gelap',
      'Bentuk sampah tidak terlihat',
      'Berbau tanah'
    ],
    development: [
      Idea('Budidaya cacing', 'Cacing berkembang biak dan bisa dibagikan.'),
      Idea('Pupuk kascing', 'Campur dengan tanah 1 : 3 untuk pot.'),
      Idea('Pakan ternak', 'Kelebihan cacing bisa jadi pakan ikan/ayam.')
    ],
    troubles: [
      Trouble('Cacing kabur?',
          'Media terlalu basah, asam, atau panas. Tambah bahan kering.'),
      Trouble('Banyak lalat buah?',
          'Kubur sampah lebih dalam dan tutup dengan kain.')
    ],
  ),
  Tutorial(
    id: 't7',
    title: 'Leaf Mold',
    duration: '6–12 bulan',
    level: 'Mudah',
    shortDesc: 'Daun kering terurai alami menjadi pembenah tanah.',
    heroColorHex: '#F1F8E9',
    iconName: 'forest',
    imageAsset: 'assets/images/leaf_mold.jpg',
    tools: [
      'Garu daun',
      'Sekop atau garpu',
      'Selang / penyiram',
      'Gunting kawat'
    ],
    materials: [
      'Daun kering ±1 karung besar',
      'Karung berpori atau kandang kawat',
      'Air secukupnya'
    ],
    steps: [
      TutorialStep(
          title: 'Kumpulkan daun',
          description: 'Gunakan daun kering yang sudah rontok.',
          duration: '30 menit',
          details: [
            'Hindari daun berminyak (kayu putih)',
            'Hindari daun yang terkena penyakit',
            'Daun yang dicacah lebih cepat lapuk'
          ]),
      TutorialStep(
          title: 'Siapkan wadah',
          description: 'Karung berpori atau kandang kawat.',
          duration: '15 menit',
          details: [
            'Beri lubang ventilasi',
            'Letakkan di tempat teduh dan lembap'
          ]),
      TutorialStep(
          title: 'Isi dan padatkan',
          description: 'Masukkan daun lapis demi lapis.',
          duration: '20 menit',
          details: [
            'Siram tiap lapis hingga lembap',
            'Padatkan dengan tangan',
            'Tutup bagian atas'
          ]),
      TutorialStep(
          title: 'Balik dan jaga lembap',
          description: 'Aduk berkala dan siram saat kering.',
          duration: 'Tiap 1–2 bulan',
          details: [
            'Balik tumpukan setiap 1–2 bulan',
            'Siram bila kering',
            'Tidak perlu aktivator'
          ]),
      TutorialStep(
          title: 'Panen leaf mold',
          description: 'Siap setelah 6–12 bulan.',
          duration: '20 menit',
          details: [
            'Daun berubah menjadi remah gelap',
            'Ayak bila perlu',
            'Pakai sebagai mulsa atau media tanam'
          ]),
    ],
    harvest:
        'Leaf mold berupa remah gelap dan gembur beraroma tanah hutan, bagus untuk pembenah tanah.',
    signs: [
      'Daun sudah hancur menjadi remah',
      'Warna cokelat kehitaman',
      'Aroma seperti tanah hutan'
    ],
    development: [
      Idea('Mulsa tanaman', 'Taburkan di sekitar tanaman.'),
      Idea('Campuran media semai', 'Ayak halus lalu campur dengan tanah.'),
      Idea('Percepat proses', 'Cacah daun lebih dulu.')
    ],
    troubles: [
      Trouble('Daun tak hancur?',
          'Terlalu kering atau daun keras. Basahi, cacah, balik lebih sering.'),
      Trouble(
          'Jamur putih?', 'Wajar, itu jamur pengurai. Tetap jaga kelembapan.')
    ],
  ),
  Tutorial(
    id: 't8',
    title: 'Daur Ulang Cangkang Telur',
    duration: '1 hari',
    level: 'Mudah',
    shortDesc: 'Serbuk kalsium dari cangkang telur untuk tanaman.',
    heroColorHex: '#FFF3E0',
    iconName: 'egg',
    imageAsset: 'assets/images/cangkang_telur.jpg',
    tools: [
      'Panci kecil',
      'Nampan atau loyang',
      'Blender kering atau ulekan',
      'Saringan halus'
    ],
    materials: [
      'Cangkang telur ±10 butir',
      'Air bersih',
      'Toples kering untuk menyimpan'
    ],
    steps: [
      TutorialStep(
          title: 'Bilas dan rebus',
          description: 'Hilangkan sisa putih telur.',
          duration: '10 menit',
          details: ['Bilas cangkang', 'Rebus ±5 menit agar bersih', 'Tiriskan'],
          tip: 'Sisa putih telur mengundang semut dan bau.'),
      TutorialStep(
          title: 'Keringkan',
          description: 'Jemur atau oven hingga benar-benar kering.',
          duration: '1 hari',
          details: [
            'Jemur seharian atau oven suhu rendah',
            'Cangkang kering mudah patah'
          ]),
      TutorialStep(
          title: 'Hancurkan',
          description: 'Giling menjadi serbuk.',
          duration: '15 menit',
          details: [
            'Remukkan dengan tangan lalu blender',
            'Ayak agar ukurannya seragam',
            'Makin halus, makin cepat diserap'
          ]),
      TutorialStep(
          title: 'Simpan dan gunakan',
          description: 'Taburkan sebagai sumber kalsium.',
          duration: '5 menit',
          details: [
            'Simpan di toples kering',
            'Taburkan tipis di sekitar tanaman',
            'Bisa dicampur ke komposter'
          ]),
    ],
    harvest:
        'Serbuk cangkang telur kaya kalsium karbonat, siap dipakai untuk tanaman.',
    signs: ['Putih bersih dan kering', 'Tidak berbau', 'Halus saat diremas'],
    development: [
      Idea('Pupuk kalsium cair',
          'Rendam serbuk dalam cuka makan beberapa hari, lalu encerkan.'),
      Idea('Untuk tomat dan cabai', 'Membantu mencegah busuk ujung buah.'),
      Idea('Campuran komposter', 'Tambahkan untuk menyeimbangkan keasaman.')
    ],
    troubles: [
      Trouble('Bau atau semut?',
          'Masih ada sisa putih telur. Cuci dan keringkan lebih bersih.'),
      Trouble('Serbuk kasar?',
          'Gunakan blender kering lalu ayak. Sisa kasar bisa masuk komposter.')
    ],
  ),
  Tutorial(
    id: 't9',
    title: 'Kompos Tanam Langsung',
    duration: '1–2 bulan',
    level: 'Mudah',
    shortDesc:
        'Trench composting: kubur sampah dapur di lahan yang akan ditanami.',
    heroColorHex: '#EFEBE9',
    iconName: 'landscape',
    imageAsset: 'assets/images/tanam_langsung.jpg',
    tools: [
      'Cangkul atau sekop',
      'Meteran',
      'Selang / penyiram',
      'Sarung tangan'
    ],
    materials: [
      'Sisa sayur dan buah',
      'Daun kering (penutup)',
      'Tanah galian',
      'Bibit tanaman'
    ],
    steps: [
      TutorialStep(
          title: 'Pilih lokasi',
          description: 'Pilih bedengan yang akan ditanami nanti.',
          duration: '10 menit',
          details: [
            'Rencanakan lokasi tanam 1–2 bulan ke depan',
            'Jauh dari sumur',
            'Pilih lahan terbuka'
          ]),
      TutorialStep(
          title: 'Gali parit',
          description: 'Kedalaman 20–30 cm.',
          duration: '30 menit',
          details: [
            'Lebar ±30 cm',
            'Simpan tanah galian di sisi parit',
            'Panjang menyesuaikan sampah'
          ]),
      TutorialStep(
          title: 'Masukkan sampah',
          description: 'Isi dengan sisa dapur organik.',
          duration: '10 menit',
          details: [
            'Tebarkan setebal ±10–15 cm',
            'Hindari daging, tulang, minyak',
            'Cacah agar cepat terurai'
          ]),
      TutorialStep(
          title: 'Timbun',
          description: 'Tutup dengan tanah ±15 cm.',
          duration: '15 menit',
          details: [
            'Padatkan ringan',
            'Tutup dengan daun atau mulsa',
            'Siram sedikit'
          ],
          tip: 'Timbunan tebal mencegah bau dan hewan penggali.'),
      TutorialStep(
          title: 'Tunggu lalu tanam',
          description: 'Tanam setelah 4–8 minggu.',
          duration: '4–8 minggu',
          details: [
            'Biarkan sampah terurai',
            'Tanam bibit di atas parit',
            'Gunakan parit baru untuk sampah berikutnya'
          ]),
    ],
    harvest:
        'Tidak ada panen kompos terpisah. Sampah langsung menjadi nutrisi bagi tanaman.',
    signs: [
      'Tanah di atas parit gembur',
      'Sampah sudah tidak terlihat',
      'Cacing tanah mulai banyak'
    ],
    development: [
      Idea(
          'Tanam sayuran buah', 'Cabai, tomat, dan terong menyukai tanah ini.'),
      Idea('Rotasi parit', 'Pindahkan lokasi parit tiap musim.'),
      Idea('Bedengan subur', 'Parit berurutan bisa jadi bedengan sayur.')
    ],
    troubles: [
      Trouble('Digali hewan?', 'Timbun lebih dalam dan hindari sisa daging.'),
      Trouble('Tanaman layu?', 'Sampah belum terurai. Tunggu lebih lama.')
    ],
  ),
  Tutorial(
    id: 't10',
    title: 'Pengeringan Sampah',
    duration: '2–3 hari',
    level: 'Mudah',
    shortDesc: 'Kurangi kadar air sebelum diolah lebih lanjut.',
    heroColorHex: '#FFFDE7',
    iconName: 'sunny',
    imageAsset: 'assets/images/pengering.jpg',
    tools: [
      'Nampan atau rak jemur',
      'Jaring penutup',
      'Pisau dan talenan',
      'Wadah kedap udara'
    ],
    materials: [
      'Sampah organik (sayur, buah, nasi)',
      'Alas koran atau kain bersih'
    ],
    steps: [
      TutorialStep(
          title: 'Tiriskan dan cacah',
          description: 'Kurangi air dan perkecil ukuran.',
          duration: '20 menit',
          details: [
            'Tiriskan 15–30 menit',
            'Cacah 1–2 cm',
            'Pisahkan sampah berminyak'
          ]),
      TutorialStep(
          title: 'Sebarkan tipis',
          description: 'Letakkan tipis di nampan.',
          duration: '10 menit',
          details: [
            'Tebal maksimal 2–3 cm',
            'Gunakan alas bersih',
            'Tutup dengan jaring'
          ]),
      TutorialStep(
          title: 'Jemur',
          description: 'Di bawah sinar matahari langsung.',
          duration: '2–3 hari',
          details: [
            'Balik tiap beberapa jam',
            'Pindahkan saat hujan',
            'Kering bila renyah'
          ]),
      TutorialStep(
          title: 'Simpan',
          description: 'Gunakan wadah kering dan tertutup.',
          duration: '10 menit',
          details: [
            'Pastikan benar-benar kering',
            'Simpan di toples',
            'Beri label tanggal'
          ]),
    ],
    harvest: 'Sampah kering yang ringan dan tidak mudah busuk.',
    signs: [
      'Renyah dan mudah patah',
      'Bobot berkurang jauh',
      'Tidak berbau busuk'
    ],
    development: [
      Idea('Campuran komposter', 'Sebagai bahan kering penyeimbang.'),
      Idea('Mulsa kebun', 'Taburkan di sekitar tanaman.'),
      Idea('Pupuk organik', 'Hancurkan jadi serbuk.')
    ],
    troubles: [
      Trouble('Berjamur?', 'Cuaca lembap. Tipiskan lapisan atau gunakan oven.'),
      Trouble(
          'Dihinggapi lalat?', 'Tutup dengan jaring dan jemur lebih tinggi.')
    ],
  ),
];

final List<Tutorial> sortedTutorials = List.unmodifiable(tutorials);

// ==================================================================
// STYLE
// ==================================================================

const _ink = Color(0xFF18221C);
const _muted = Color(0xFF75837B);
const _line = Color(0xFFE9EEEA);
const _green = Color(0xFF2E9E5B);
const _darkGreen = Color(0xFF1B5E20);
const _brand = Color(0xFF2E7D32);
const _soft = Color(0xFFE8F5E9);
const _bgColor = Color(0xFFF6F9F7);
const _amber = Color(0xFFF2A100);

IconData _getIcon(String name) {
  switch (name) {
    case 'water_drop':
      return Icons.water_drop_rounded;
    case 'recycling':
      return Icons.recycling_rounded;
    case 'science':
      return Icons.science_rounded;
    case 'bug_report':
      return Icons.bug_report_rounded;
    case 'compost':
      return Icons.compost_rounded;
    case 'spa':
      return Icons.spa_rounded;
    case 'forest':
      return Icons.forest_rounded;
    case 'egg':
      return Icons.egg_alt_rounded;
    case 'landscape':
      return Icons.landscape_rounded;
    case 'sunny':
      return Icons.wb_sunny_rounded;
    default:
      return Icons.eco_rounded;
  }
}

void _openTutorial(BuildContext context, Tutorial t) {
  Navigator.push(context,
      MaterialPageRoute(builder: (_) => TutorialDetailScreen(tutorial: t)));
}

void _openPilara(BuildContext context, String contextMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pilara akan menjawab: $contextMessage')));
}

BoxDecoration _card(
        {double radius = 20, Color color = Colors.white, Color? border}) =>
    BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: border ?? _line),
    );

// ==================================================================
// 2. SCREEN UTAMA
// ==================================================================

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      await progressStore.load();
      if (mounted) setState(() => _isLoading = false);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: _bgColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_loadError != null) {
      return Scaffold(
        backgroundColor: _bgColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Progres belajar tidak dapat dimuat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _loadError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: _muted),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadProgress,
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListenableBuilder(
      listenable: progressStore,
      builder: (context, _) {
        final learning = tutorials
            .where((t) =>
                progressStore.isStarted(t.id) && !progressStore.isFinished(t))
            .toList();

        return Scaffold(
          backgroundColor: _bgColor,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(22, 20, 22, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Belajar',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: _ink,
                                letterSpacing: -0.5)),
                        SizedBox(height: 4),
                        Text('Ubah sampahmu jadi sesuatu yang berguna.',
                            style: TextStyle(fontSize: 13, color: _muted)),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(child: _LearningPill(learning: learning)),
                        const SizedBox(width: 10),
                        _HeaderButton(
                          icon: Icons.chat_bubble_rounded,
                          tooltip: 'Tanya Pilara',
                          filled: true,
                          size: 52,
                          onTap: () => _openPilara(
                              context, "Halo! Mau belajar apa hari ini?"),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${sortedTutorials.length} tutorial',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _ink)),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded, size: 14, color: _amber),
                            SizedBox(width: 3),
                            Text('panduan langkah demi langkah',
                                style:
                                    TextStyle(fontSize: 11.5, color: _muted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: _FocusBanner(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  sliver: SliverList.separated(
                    itemCount: sortedTutorials.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (_, i) {
                      final t = sortedTutorials[i];
                      return _TutorialCard(
                          tutorial: t, onTap: () => _openTutorial(context, t));
                    },
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

// ==================================================================
// 3. SCREEN DETAIL
// ==================================================================

class TutorialDetailScreen extends StatefulWidget {
  final Tutorial tutorial;
  const TutorialDetailScreen({super.key, required this.tutorial});

  @override
  State<TutorialDetailScreen> createState() => _TutorialDetailScreenState();
}

class _TutorialDetailScreenState extends State<TutorialDetailScreen> {
  final Set<String> _checked = {};
  int? _open;
  bool _isSavingProgress = false;

  Tutorial get t => widget.tutorial;

  @override
  void initState() {
    super.initState();
    // Cek sinkronisasi: Jika sudah selesai, jangan auto-buka langkah manapun.
    // Ini mencegah "telat baca" saat masuk ke halaman yang sudah 100%.
    final done = progressStore.doneCount(t.id);
    if (progressStore.isStarted(t.id) && done < t.steps.length) {
      _open = done;
    } else {
      _open = null;
    }
  }

  Future<bool> _saveProgress(Future<void> Function() save) async {
    if (_isSavingProgress) return false;
    setState(() => _isSavingProgress = true);
    try {
      await save();
      return true;
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Progres gagal disimpan: $error')),
        );
      }
      return false;
    } finally {
      if (mounted) setState(() => _isSavingProgress = false);
    }
  }

  Future<void> _primaryAction() async {
    final id = t.id;
    if (!progressStore.isStarted(id)) {
      if (await _saveProgress(() => progressStore.start(id)) && mounted) {
        setState(() => _open = 0);
      }
      return;
    }
    final d = progressStore.doneCount(id);
    if (d >= t.steps.length) return;
    if (await _saveProgress(() => progressStore.setDone(id, d + 1)) &&
        mounted) {
      setState(() => _open = d + 1 < t.steps.length ? d + 1 : null);
    }
  }

  Future<void> _undoStep(int stepIndex) async {
    final saved = await _saveProgress(
      () => progressStore.setDone(t.id, stepIndex),
    );
    if (saved && mounted) setState(() => _open = stepIndex);
  }

  Future<void> _resetProgress() async {
    final saved = await _saveProgress(() => progressStore.reset(t.id));
    if (saved && mounted) setState(() => _open = null);
  }

  void _toggleChecked(String key) {
    setState(() =>
        _checked.contains(key) ? _checked.remove(key) : _checked.add(key));
  }

  void _goToNextTutorial() {
    final currentIndex = sortedTutorials.indexWhere((item) => item.id == t.id);
    final hasNext =
        currentIndex >= 0 && currentIndex + 1 < sortedTutorials.length;

    if (hasNext) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TutorialDetailScreen(
            tutorial: sortedTutorials[currentIndex + 1],
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _showCompletionDialog() {
    final currentIndex = sortedTutorials.indexWhere((item) => item.id == t.id);
    final hasNext =
        currentIndex >= 0 && currentIndex + 1 < sortedTutorials.length;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events_rounded,
                  size: 42, color: _green),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hebat! Tutorial selesai',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 19, fontWeight: FontWeight.w800, color: _ink),
            ),
            const SizedBox(height: 8),
            Text(
              'Kamu berhasil menuntaskan ${t.steps.length} langkah ${t.title}. Terima kasih sudah ikut mengurangi sampah!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, height: 1.45, color: _muted),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _goToNextTutorial();
            },
            style: FilledButton.styleFrom(
              backgroundColor: _brand,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(hasNext
                ? 'Pelajari tutorial berikutnya'
                : 'Kembali ke daftar tutorial'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: progressStore,
      builder: (context, _) {
        final total = t.steps.length;
        final done = progressStore.doneCount(t.id);
        final started = progressStore.isStarted(t.id);
        final finished = done >= total;
        final active = started && !finished ? done : -1;
        final canMarkDone = !started || (started && _open == done && !finished);

        return Scaffold(
          backgroundColor: _bgColor,
          appBar: AppBar(
            backgroundColor: _bgColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: _ink, size: 20),
                onPressed: () => Navigator.pop(context)),
            actions: [
              if (started)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz_rounded, color: _ink),
                  onSelected: (_) {
                    _resetProgress();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                        value: 'reset', child: Text('Berhenti & reset progres'))
                  ],
                ),
              _HeaderButton(
                icon: Icons.chat_bubble_rounded,
                tooltip: 'Tanya Pilara',
                filled: true,
                onTap: () => _openPilara(context,
                    "Sedang mengerjakan ${t.title} langkah ${done + 1}. Ada yang bisa dibantu?"),
              ),
              const SizedBox(width: 20),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            children: [
              // HERO IMAGE
              SizedBox(
                height: 220,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: _TutorialArt(tutorial: t, iconSize: 72)),
              ),
              const SizedBox(height: 20),
              Text(
                t.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(t.shortDesc,
                  style: const TextStyle(
                      fontSize: 14, color: _muted, height: 1.45)),
              const SizedBox(height: 16),

              // STATISTIK
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: _card(),
                child: Row(
                  children: [
                    _Stat(
                        icon: Icons.schedule_rounded,
                        value: t.duration,
                        label: 'Durasi'),
                    const _VDivider(),
                    _Stat(
                        icon: Icons.signal_cellular_alt_rounded,
                        value: t.level,
                        label: 'Tingkat'),
                    const _VDivider(),
                    _Stat(
                        icon: Icons.format_list_numbered_rounded,
                        value: '$total',
                        label: 'Langkah'),
                  ],
                ),
              ),
              // PROGRES
              if (started) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _card(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(finished ? 'Selesai' : 'Progresmu',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _ink)),
                          Text('$done dari $total langkah',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: _muted,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                            value: done / total,
                            minHeight: 8,
                            backgroundColor: _soft,
                            color: _green),
                      ),
                    ],
                  ),
                ),
              ],

              // CHECKLIST ALAT & BAHAN
              const SizedBox(height: 24),
              _ChecklistCard(
                  title: 'Alat',
                  icon: Icons.handyman_rounded,
                  items: t.tools,
                  checked: _checked,
                  prefix: 'a',
                  onToggle: _toggleChecked),
              const SizedBox(height: 12),
              _ChecklistCard(
                  title: 'Bahan',
                  icon: Icons.inventory_2_rounded,
                  items: t.materials,
                  checked: _checked,
                  prefix: 'b',
                  onToggle: _toggleChecked),

              // LANGKAH-LANGKAH
              const SizedBox(height: 28),
              const _Heading('Langkah-langkah',
                  sub: 'Ketuk langkah untuk melihat rincian'),
              const SizedBox(height: 14),
              for (var i = 0; i < total; i++)
                _StepTile(
                  index: i,
                  step: t.steps[i],
                  state: i < done
                      ? _StepState.done
                      : (i == active ? _StepState.active : _StepState.todo),
                  isLast: i == total - 1,
                  expanded: _open == i,
                  onTap: () => setState(() => _open = _open == i ? null : i),
                  onUndo: () => _undoStep(i),
                ),

              // APRESIASI SAAT SEMUA LANGKAH SELESAI
              if (finished) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF6EE),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFD5EBDC)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.emoji_events_rounded,
                            color: _amber, size: 27),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Keren, kamu berhasil!',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: _darkGreen)),
                            SizedBox(height: 4),
                            Text(
                                'Semua langkah tutorial sudah selesai. Progres ini tersimpan di perangkatmu.',
                                style: TextStyle(
                                    fontSize: 12.5,
                                    height: 1.4,
                                    color: _muted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // PANEN & HASIL
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: _card(
                    color: const Color(0xFFEAF6EE),
                    border: const Color(0xFFD5EBDC)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.agriculture_rounded,
                            color: _darkGreen, size: 22),
                        SizedBox(width: 8),
                        Text('Panen & hasil',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _ink)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(t.harvest,
                        style: const TextStyle(
                            fontSize: 13.5, color: _ink, height: 1.5)),
                    const SizedBox(height: 14),
                    const Text('Tanda siap panen',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _muted)),
                    const SizedBox(height: 8),
                    for (final s in t.signs)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                                padding: EdgeInsets.only(top: 1),
                                child: Icon(Icons.check_circle_rounded,
                                    size: 16, color: _green)),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(s,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: _ink,
                                        height: 1.35))),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // PENGEMBANGAN & MASALAH UMUM
              const SizedBox(height: 28),
              const _Heading('Pengembangan lanjutan',
                  sub: 'Setelah panen, apa lagi yang bisa dilakukan'),
              const SizedBox(height: 12),
              Container(
                decoration: _card(),
                child: Column(
                  children: [
                    for (var i = 0; i < t.development.length; i++) ...[
                      if (i > 0) const Divider(height: 1, color: _line),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4D6),
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.lightbulb_rounded,
                                  size: 18, color: _amber),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.development[i].title,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: _ink)),
                                  const SizedBox(height: 3),
                                  Text(t.development[i].desc,
                                      style: const TextStyle(
                                          fontSize: 12.5,
                                          color: _muted,
                                          height: 1.45)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const _Heading('Masalah umum'),
              const SizedBox(height: 12),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: _card(),
                child: Column(
                  children: [
                    for (var i = 0; i < t.troubles.length; i++) ...[
                      if (i > 0) const Divider(height: 1, color: _line),
                      Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          childrenPadding:
                              const EdgeInsets.fromLTRB(16, 0, 16, 14),
                          shape: const Border(),
                          collapsedShape: const Border(),
                          iconColor: _muted,
                          collapsedIconColor: _muted,
                          title: Text(t.troubles[i].q,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _ink)),
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(t.troubles[i].a,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: _muted,
                                      height: 1.5)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // BANTUAN PILARA
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration:
                    _card(color: _soft, border: const Color(0xFFD5EBDC)),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Masih bingung?',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: _ink)),
                          SizedBox(height: 3),
                          Text(
                              'Tanyakan langsung ke Pilara soal langkah yang sedang kamu kerjakan.',
                              style: TextStyle(
                                  fontSize: 12.5, color: _muted, height: 1.4)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _openPilara(context,
                          "Tentang ${t.title}: apa yang ingin kamu tanyakan?"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brand,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Tanya',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.fromLTRB(
                20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: _line))),
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSavingProgress
                    ? null
                    : finished
                        ? _showCompletionDialog
                        : (!started
                            ? _primaryAction
                            : (canMarkDone
                                ? _primaryAction
                                : () => setState(() => _open = done))),
                icon: Icon(
                  _isSavingProgress
                      ? Icons.sync_rounded
                      : finished
                          ? Icons.emoji_events_rounded
                          : (!started
                              ? Icons.play_arrow_rounded
                              : (canMarkDone
                                  ? Icons.check_rounded
                                  : Icons.arrow_forward_rounded)),
                  size: 20,
                ),
                label: Text(
                  _isSavingProgress
                      ? 'Menyimpan progres...'
                      : finished
                          ? 'Lihat pencapaian & lanjut'
                          : (!started
                              ? 'Mulai belajar'
                              : (canMarkDone
                                  ? 'Tandai langkah ${done + 1} selesai'
                                  : 'Lanjut ke langkah ${done + 1}')),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brand,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void _showLearningSheet(BuildContext context, List<Tutorial> learning) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: _SheetHandle()),
            const SizedBox(height: 8),
            const Text('Sedang kamu pelajari',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: _ink)),
            const SizedBox(height: 14),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: learning.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: _line),
                itemBuilder: (_, i) {
                  final t = learning[i];
                  final done = progressStore.doneCount(t.id);
                  final total = t.steps.length;
                  return InkWell(
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _openTutorial(context, t);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: SizedBox(
                                width: 52,
                                height: 52,
                                child: _TutorialArt(tutorial: t, iconSize: 24)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                        color: _ink)),
                                const SizedBox(height: 2),
                                Text(
                                    'Langkah ${done + 1}: ${t.steps[done].title}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12, color: _muted)),
                                const SizedBox(height: 7),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                      value: done / total,
                                      minHeight: 5,
                                      backgroundColor: _soft,
                                      color: _green),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('$done/$total',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: _muted)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ==================================================================
// 5. WIDGETS PENDUKUNG
// ==================================================================

class _FocusBanner extends StatelessWidget {
  const _FocusBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC8E6C9)),
      ),
      child: Row(
        children: [
          const Icon(Icons.eco_rounded, color: _darkGreen, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Fokus sampah organik. Kategori anorganik & B3 segera hadir.',
              style: TextStyle(
                  fontSize: 12,
                  color: _darkGreen,
                  fontWeight: FontWeight.w600,
                  height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialArt extends StatelessWidget {
  final Tutorial tutorial;
  final double iconSize;
  const _TutorialArt({required this.tutorial, this.iconSize = 44});

  @override
  Widget build(BuildContext context) {
    final fallback = Stack(
      fit: StackFit.expand,
      children: [
        Container(color: tutorial.heroColor),
        Positioned(
          right: -iconSize * 0.3,
          bottom: -iconSize * 0.3,
          child: Icon(_getIcon(tutorial.iconName),
              size: iconSize * 2.6, color: Colors.white.withValues(alpha: 0.6)),
        ),
        Center(
            child: Icon(_getIcon(tutorial.iconName),
                size: iconSize, color: _darkGreen.withValues(alpha: 0.75))),
      ],
    );

    if (tutorial.imageAsset == null) return fallback;
    return Image.asset(
      tutorial.imageAsset!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 4),
      width: 40,
      height: 4,
      decoration:
          BoxDecoration(color: _line, borderRadius: BorderRadius.circular(4)),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool filled;
  final double size;
  const _HeaderButton(
      {required this.icon,
      required this.tooltip,
      required this.onTap,
      this.filled = false,
      this.size = 38});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: filled ? _brand : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: filled ? Colors.transparent : _line),
            boxShadow: filled
                ? [
                    BoxShadow(
                        color: _brand.withValues(alpha: 0.28),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ]
                : null,
          ),
          child: Icon(icon,
              size: size * 0.47, color: filled ? Colors.white : _ink),
        ),
      ),
    );
  }
}

class _LearningPill extends StatelessWidget {
  final List<Tutorial> learning;
  const _LearningPill({required this.learning});

  @override
  Widget build(BuildContext context) {
    const h = 52.0;

    if (learning.isEmpty) {
      return Container(
        height: h,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(h / 2),
            border: Border.all(color: _line)),
        child: const Row(
          children: [
            Icon(Icons.eco_rounded, size: 22, color: _green),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sedang kamu pelajari',
                      style: TextStyle(
                          fontSize: 10.5,
                          color: _muted,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 1),
                  Text('Belum ada, yuk mulai!',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _ink)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final t = learning.first;
    final done = progressStore.doneCount(t.id);
    final total = t.steps.length;

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(h / 2),
          side: const BorderSide(color: _line)),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(h / 2)),
        onTap: () => learning.length == 1
            ? _openTutorial(context, t)
            : _showLearningSheet(context, learning),
        child: Container(
          height: h,
          padding: const EdgeInsets.fromLTRB(10, 0, 14, 0),
          child: Row(
            children: [
              SizedBox(
                width: 34,
                height: 34,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 34,
                      height: 34,
                      child: CircularProgressIndicator(
                        value: done / total,
                        strokeWidth: 3,
                        backgroundColor: _soft,
                        color: _green,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Icon(_getIcon(t.iconName), size: 15, color: _darkGreen),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sedang kamu pelajari',
                        style: TextStyle(
                            fontSize: 10.5,
                            color: _muted,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 1),
                    Text(
                      '${t.title} · $done/$total',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _ink),
                    ),
                  ],
                ),
              ),
              if (learning.length > 1) ...[
                const SizedBox(width: 8),
                _Chip(label: '+${learning.length - 1}', bg: _soft, fg: _brand),
              ] else
                const Icon(Icons.chevron_right_rounded,
                    color: _muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String text;
  final String? sub;
  const _Heading(this.text, {this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800, color: _ink)),
        if (sub != null) ...[
          const SizedBox(height: 2),
          Text(sub!, style: const TextStyle(fontSize: 12.5, color: _muted)),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Chip({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style:
              TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

class _PhotoBadge extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String label;
  final Color bg;
  final Color fg;
  const _PhotoBadge(
      {this.icon,
      this.iconColor,
      required this.label,
      this.bg = Colors.white,
      this.fg = _ink});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: iconColor ?? fg),
            const SizedBox(width: 4)
          ],
          Text(label,
              style: TextStyle(
                  fontSize: 11.5, fontWeight: FontWeight.w800, color: fg)),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Meta(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: _muted),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: _muted)),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _Stat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: _green),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w800, color: _ink)),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: _muted)),
        ],
      ),
    );
  }
}

class _VDivider extends StatelessWidget {
  const _VDivider();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 40, color: _line);
}

class _TutorialCard extends StatelessWidget {
  final Tutorial tutorial;
  final VoidCallback onTap;
  const _TutorialCard({required this.tutorial, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final started = progressStore.isStarted(tutorial.id);
    final finished = progressStore.isFinished(tutorial);
    final done = progressStore.doneCount(tutorial.id);
    final total = tutorial.steps.length;

    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: const BorderSide(color: _line)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _TutorialArt(tutorial: tutorial, iconSize: 64),
                  if (finished)
                    const Positioned(
                      right: 12,
                      top: 12,
                      child: _PhotoBadge(
                          icon: Icons.check_circle_rounded,
                          label: 'Selesai',
                          bg: _brand,
                          fg: Colors.white),
                    )
                  else if (started)
                    Positioned(
                      right: 12,
                      top: 12,
                      child: _PhotoBadge(
                          icon: Icons.play_circle_rounded,
                          iconColor: _green,
                          label: '$done/$total'),
                    ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: _PhotoBadge(
                      icon: Icons.signal_cellular_alt_rounded,
                      iconColor: _green,
                      label: tutorial.level,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tutorial.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: _ink)),
                  const SizedBox(height: 4),
                  Text(tutorial.shortDesc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, color: _muted, height: 1.35)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _Meta(Icons.schedule_rounded, tutorial.duration),
                      const SizedBox(width: 14),
                      _Meta(
                          Icons.format_list_numbered_rounded, '$total langkah'),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_rounded,
                          size: 18, color: _green),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final Set<String> checked;
  final String prefix;
  final void Function(String key) onToggle;

  const _ChecklistCard({
    required this.title,
    required this.icon,
    required this.items,
    required this.checked,
    required this.prefix,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final count =
        List.generate(items.length, (i) => checked.contains('$prefix$i'))
            .where((b) => b)
            .length;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: _soft, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 17, color: _brand),
              ),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: _ink)),
              const Spacer(),
              Text('$count/${items.length} siap',
                  style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: _muted)),
            ],
          ),
          const SizedBox(height: 6),
          for (var i = 0; i < items.length; i++)
            InkWell(
              onTap: () => onToggle('$prefix$i'),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      checked.contains('$prefix$i')
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 20,
                      color: checked.contains('$prefix$i')
                          ? _green
                          : const Color(0xFFC9D3CD),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        items[i],
                        style: TextStyle(
                          fontSize: 13.5,
                          color: checked.contains('$prefix$i')
                              ? const Color(0xFFB0BEC5)
                              : _ink,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum _StepState { done, active, todo }

class _StepTile extends StatelessWidget {
  final int index;
  final TutorialStep step;
  final _StepState state;
  final bool isLast;
  final bool expanded;
  final VoidCallback onTap;
  final VoidCallback onUndo;

  const _StepTile({
    required this.index,
    required this.step,
    required this.state,
    required this.isLast,
    required this.expanded,
    required this.onTap,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = state == _StepState.done;
    final isActive = state == _StepState.active;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? _green : (isActive ? _soft : Colors.white),
                    border: Border.all(
                        color: isDone || isActive ? _green : _line,
                        width: isActive ? 2 : 1),
                  ),
                  child: isDone
                      ? const Icon(Icons.check_rounded,
                          size: 18, color: Colors.white)
                      : Text('${index + 1}',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isActive ? _brand : _muted)),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: isDone ? _green : _line),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: isActive ? _green : _line,
                        width: isActive ? 1.5 : 1),
                  ),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(step.title,
                                  style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: _ink)),
                            ),
                            if (step.duration != null) ...[
                              Text(step.duration!,
                                  style: const TextStyle(
                                      fontSize: 11.5, color: _muted)),
                              const SizedBox(width: 4),
                            ],
                            Icon(
                                expanded
                                    ? Icons.expand_less_rounded
                                    : Icons.expand_more_rounded,
                                size: 20,
                                color: _muted),
                          ],
                        ),
                        if (expanded) ...[
                          const SizedBox(height: 6),
                          Text(step.description,
                              style: const TextStyle(
                                  fontSize: 13, color: _muted, height: 1.45)),
                          if (step.imageAsset != null) ...[
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                step.imageAsset!,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 160,
                                  color: _soft,
                                  child: const Center(
                                      child: Icon(Icons.broken_image_rounded,
                                          color: _muted)),
                                ),
                              ),
                            ),
                          ],
                          if (step.details.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            for (final d in step.details)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 7, right: 10),
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                          color: _green,
                                          shape: BoxShape.circle),
                                    ),
                                    Expanded(
                                        child: Text(d,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: _ink,
                                                height: 1.4))),
                                  ],
                                ),
                              ),
                          ],
                          if (step.tip != null) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFF8E1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.lightbulb_rounded,
                                      size: 16, color: _amber),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(step.tip!,
                                          style: const TextStyle(
                                              fontSize: 12.5,
                                              color: Color(0xFF7A5200),
                                              height: 1.4))),
                                ],
                              ),
                            ),
                          ],
                          if (isDone) ...[
                            const SizedBox(height: 4),
                            TextButton(
                              onPressed: onUndo,
                              style: TextButton.styleFrom(
                                  foregroundColor: _muted,
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 32),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap),
                              child: const Text('Batalkan tanda selesai',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
