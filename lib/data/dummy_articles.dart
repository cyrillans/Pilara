import 'package:flutter/material.dart';

class Article {
  final int id;
  final String title;
  final String description;
  final String category;
  final String readTime;
  final String author;
  final String updatedDate;
  final String headerImage;
  final IconData icon;
  final String introduction;
  final List<ArticleSection> sections;
  final List<String> importantPoints;
  final String sourceName;
  final String sourceUrl;

  const Article({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.readTime,
    required this.author,
    required this.updatedDate,
    required this.headerImage,
    required this.icon,
    required this.introduction,
    required this.sections,
    required this.importantPoints,
    required this.sourceName,
    required this.sourceUrl,
  });
}

class ArticleSection {
  final String title;
  final String content;

  const ArticleSection({
    required this.title,
    required this.content,
  });
}

const List<Article> dummyArticles = [
  // ============================================================
  // ARTIKEL 1
  // ============================================================
  Article(
    id: 1,
    title: 'Mengenal Jenis Sampah dan Pentingnya Pemilahan',
    description:
        'Memahami jenis sampah merupakan langkah awal untuk melakukan pemilahan dan pengelolaan sampah dengan lebih tepat.',
    category: 'Edukasi',
    readTime: '6 menit',
    author: 'Pilara',
    updatedDate: '12 Oktober 2026',
    headerImage:
        'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?auto=format&fit=crop&w=1200&q=80',
    icon: Icons.recycling_rounded,
    introduction:
        'Sampah merupakan bagian dari aktivitas sehari-hari. Setiap kegiatan yang dilakukan manusia, mulai dari memasak, berbelanja, bekerja, hingga belajar, dapat menghasilkan sampah. Karena itu, persoalan sampah bukan hanya berkaitan dengan tempat pembuangan akhir, tetapi juga dengan bagaimana sampah tersebut diperlakukan sejak pertama kali dihasilkan.',
    sections: [
      ArticleSection(
        title: 'Mengapa sampah perlu dipilah?',
        content:
            'Pemilahan merupakan salah satu bagian penting dalam pengelolaan sampah. Sampah yang tercampur akan lebih sulit ditangani karena berbagai material memiliki karakteristik dan cara pengolahan yang berbeda. Sebaliknya, ketika sampah sudah dipisahkan sejak sumbernya, material yang masih memiliki nilai guna dapat lebih mudah dikumpulkan dan diproses lebih lanjut.\n\n'
            'Pemilahan juga membantu mengurangi kemungkinan material yang dapat dimanfaatkan menjadi tercemar oleh jenis sampah lainnya. Karena itu, kebiasaan memilah sebaiknya dimulai dari tempat sampah pertama, baik di rumah, sekolah, kampus, kantor, maupun tempat umum.',
      ),
      ArticleSection(
        title: 'Sampah organik',
        content:
            'Sampah organik adalah sampah yang berasal dari material yang dapat mengalami proses penguraian secara alami. Dalam kehidupan sehari-hari, contoh yang paling mudah ditemukan adalah sisa makanan, kulit buah, sayuran, daun, dan sisa kegiatan dapur.\n\n'
            'Sampah organik perlu dipisahkan dari sampah lainnya karena memiliki karakteristik yang berbeda. Material organik tertentu dapat diarahkan ke proses pengolahan seperti pengomposan sehingga tidak seluruhnya berakhir sebagai residu.',
      ),
      ArticleSection(
        title: 'Sampah anorganik',
        content:
            'Sampah anorganik umumnya berasal dari material seperti plastik, kertas, logam, dan kaca. Sebagian material tersebut memiliki potensi untuk digunakan kembali atau didaur ulang apabila dikumpulkan dalam kondisi yang sesuai.\n\n'
            'Contohnya adalah botol plastik, kardus, kertas, kaleng, dan beberapa jenis wadah kaca. Pemisahan material tersebut sejak awal dapat membantu proses pengumpulan dan pengelolaan berikutnya.',
      ),
      ArticleSection(
        title: 'Sampah yang membutuhkan penanganan khusus',
        content:
            'Tidak semua sampah rumah tangga dapat diperlakukan dengan cara yang sama. Produk rumah tangga yang mengandung B3 atau Limbah B3, barang elektronik yang sudah rusak, serta beberapa material lainnya membutuhkan pemilahan dan penanganan khusus.\n\n'
            'Baterai bekas, misalnya, sebaiknya tidak dicampurkan begitu saja dengan sampah rumah tangga lainnya. Jenis sampah tersebut perlu diarahkan ke fasilitas atau sistem pengumpulan yang sesuai.',
      ),
      ArticleSection(
        title: 'Mulai dari kebiasaan sederhana',
        content:
            'Pemilahan tidak harus dimulai dengan sistem yang rumit. Langkah sederhana seperti menyediakan beberapa wadah berbeda dan memberi label berdasarkan jenis sampah sudah dapat membantu membangun kebiasaan.\n\n'
            'Yang paling penting adalah konsistensi. Ketika pemilahan dilakukan setiap hari, kegiatan tersebut secara perlahan menjadi bagian dari rutinitas. Dari kebiasaan kecil inilah pengelolaan sampah dapat dimulai dari sumbernya.',
      ),
    ],
    importantPoints: [
      'Kenali jenis sampah sebelum membuangnya.',
      'Pisahkan sampah organik dan anorganik.',
      'Jangan mencampurkan sampah yang membutuhkan penanganan khusus.',
      'Gunakan wadah yang berbeda dan beri label.',
      'Biasakan memilah sampah sejak dari sumbernya.',
    ],
    sourceName: 'SIPSN - Kementerian Lingkungan Hidup',
    sourceUrl: 'https://sipsn.menlhk.go.id/',
  ),

  // ============================================================
  // ARTIKEL 2
  // ============================================================
  Article(
    id: 2,
    title: 'Mengapa Sampah Plastik Menjadi Persoalan Lingkungan?',
    description:
        'Mengenal penggunaan plastik, dampaknya terhadap pengelolaan sampah, dan kebiasaan yang dapat dilakukan untuk menguranginya.',
    category: 'Lingkungan',
    readTime: '7 menit',
    author: 'Pilara',
    updatedDate: '10 Oktober 2026',
    headerImage:
        'https://images.unsplash.com/photo-1604187351574-c75ca79f5807?auto=format&fit=crop&w=1200&q=80',
    icon: Icons.shopping_bag_outlined,
    introduction:
        'Plastik menjadi bagian yang sulit dipisahkan dari kehidupan modern. Material ini digunakan untuk berbagai kebutuhan karena ringan, praktis, dan dapat dibuat dalam berbagai bentuk. Namun, penggunaan plastik yang tinggi juga membuat pengelolaannya menjadi tantangan penting dalam persoalan sampah.',
    sections: [
      ArticleSection(
        title: 'Plastik dan kehidupan sehari-hari',
        content:
            'Berbagai produk yang digunakan sehari-hari menggunakan plastik sebagai bahan utama maupun sebagai kemasan. Botol minuman, kantong belanja, kemasan makanan, wadah produk rumah tangga, dan berbagai barang lainnya dapat menggunakan material plastik.\n\n'
            'Kemudahan penggunaan menjadi salah satu alasan plastik banyak digunakan. Persoalannya muncul ketika barang tersebut sudah tidak digunakan dan berubah menjadi sampah.',
      ),
      ArticleSection(
        title: 'Mengapa pengelolaannya menjadi tantangan?',
        content:
            'Sampah plastik memiliki karakteristik yang membuat pengelolaannya perlu dilakukan dengan baik. Ketika plastik tercampur dengan sampah lainnya, proses pemilahan dan pengolahan menjadi lebih sulit.\n\n'
            'Tidak semua plastik juga memiliki karakteristik yang sama. Jenis material, bentuk, kondisi, dan kontaminasi dapat memengaruhi apakah suatu material dapat dimanfaatkan kembali atau masuk ke proses daur ulang.',
      ),
      ArticleSection(
        title: 'Kurangi dari sumbernya',
        content:
            'Salah satu pendekatan yang dapat dilakukan adalah mengurangi penggunaan barang sekali pakai. Membawa botol minum sendiri, menggunakan tas belanja yang dapat dipakai berulang kali, dan memilih produk dengan penggunaan kemasan yang lebih sederhana merupakan contoh kebiasaan yang dapat dilakukan.\n\n'
            'Tujuan utamanya bukan sekadar mengganti satu jenis barang dengan barang lain, tetapi mengurangi jumlah barang yang digunakan sekali lalu langsung menjadi sampah.',
      ),
      ArticleSection(
        title: 'Gunakan kembali jika masih layak',
        content:
            'Barang berbahan plastik yang masih layak digunakan dapat dimanfaatkan kembali sesuai fungsi dan kondisinya. Penggunaan berulang dapat membantu memperpanjang masa pakai suatu barang sebelum akhirnya menjadi sampah.\n\n'
            'Namun, penggunaan kembali tetap perlu mempertimbangkan kebersihan, keamanan, dan kondisi barang.',
      ),
      ArticleSection(
        title: 'Pilah setelah digunakan',
        content:
            'Jika suatu barang plastik sudah tidak dapat digunakan kembali, langkah berikutnya adalah memilahnya sesuai sistem pengelolaan sampah yang tersedia. Sampah yang sudah terpilah akan lebih mudah dikumpulkan dan diarahkan ke fasilitas pengelolaan yang sesuai.',
      ),
    ],
    importantPoints: [
      'Kurangi penggunaan plastik sekali pakai.',
      'Gunakan kembali barang yang masih layak.',
      'Pilih produk dengan kemasan yang lebih sederhana.',
      'Pilah sampah plastik setelah digunakan.',
      'Salurkan material yang dapat didaur ulang ke fasilitas yang sesuai.',
    ],
    sourceName: 'World Bank - Solid Waste Management',
    sourceUrl: 'https://www.worldbank.org/en/topic/urbandevelopment/brief/solid-waste-management',
  ),

  // ============================================================
  // ARTIKEL 3
  // ============================================================
  Article(
    id: 3,
    title: 'Cara Memilah Sampah dari Rumah',
    description:
        'Langkah praktis memulai kebiasaan memilah sampah dari rumah agar pengelolaan sampah menjadi lebih mudah.',
    category: 'Tips',
    readTime: '6 menit',
    author: 'Pilara',
    updatedDate: '8 Oktober 2026',
    headerImage:
        'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=1200&q=80',
    icon: Icons.delete_sweep_rounded,
    introduction:
        'Pemilahan sampah dapat dimulai dari tempat sampah pertama, yaitu dari rumah. Tidak diperlukan sistem yang rumit untuk memulainya. Hal yang paling penting adalah mengetahui jenis sampah dan menyediakan tempat yang sesuai agar sampah tidak langsung tercampur.',
    sections: [
      ArticleSection(
        title: 'Mulai dengan mengenali sampah',
        content:
            'Langkah pertama adalah memperhatikan jenis sampah yang paling sering dihasilkan. Dari aktivitas rumah tangga, misalnya, kita dapat menemukan sisa makanan, kulit buah, botol plastik, kardus, kertas, kaleng, serta produk yang membutuhkan penanganan khusus.\n\n'
            'Dengan mengenali pola sampah yang dihasilkan, kita dapat menentukan sistem pemilahan yang paling sederhana dan sesuai dengan kondisi rumah.',
      ),
      ArticleSection(
        title: 'Sediakan wadah terpisah',
        content:
            'Wadah pemilahan dapat dibuat sederhana. Setidaknya, sampah yang memiliki karakteristik berbeda perlu dipisahkan agar tidak bercampur.\n\n'
            'Wadah dapat diberi tulisan seperti Organik, Anorganik, dan kategori khusus lainnya sesuai kebutuhan. Label membantu anggota keluarga mengetahui ke mana suatu sampah harus dibuang.',
      ),
      ArticleSection(
        title: 'Jangan campurkan kembali',
        content:
            'Salah satu hal penting dalam pemilahan adalah menjaga agar sampah yang sudah dipisahkan tidak tercampur kembali. Karena itu, wadah sebaiknya ditempatkan pada lokasi yang mudah dijangkau dan digunakan oleh seluruh anggota rumah.\n\n'
            'Jika sampah akan diserahkan kepada bank sampah atau fasilitas pengelolaan lainnya, pertahankan pemisahan tersebut sampai proses pengumpulan.',
      ),
      ArticleSection(
        title: 'Apa yang dilakukan setelah dipilah?',
        content:
            'Sampah yang sudah terpilah dapat diarahkan sesuai jenis dan fasilitas yang tersedia. Material yang memiliki nilai daur ulang dapat dikumpulkan dan diserahkan kepada bank sampah atau fasilitas lain yang menerimanya.\n\n'
            'Sementara itu, sampah organik tertentu dapat diarahkan untuk pengolahan seperti komposting apabila fasilitas dan kondisinya memungkinkan.',
      ),
      ArticleSection(
        title: 'Konsistensi adalah kunci',
        content:
            'Pada awalnya, memilah sampah mungkin terasa merepotkan. Namun, apabila dilakukan setiap hari, kegiatan tersebut dapat berubah menjadi kebiasaan.\n\n'
            'Kebiasaan yang dilakukan secara konsisten juga membuat kita lebih sadar terhadap jumlah dan jenis sampah yang dihasilkan sehingga dapat mendorong pengurangan sampah dari sumbernya.',
      ),
    ],
    importantPoints: [
      'Kenali jenis sampah yang paling sering dihasilkan.',
      'Sediakan wadah yang berbeda.',
      'Gunakan label agar pemilahan lebih mudah.',
      'Jaga sampah tetap terpisah sampai dikumpulkan.',
      'Lakukan pemilahan secara konsisten.',
    ],
    sourceName: 'Kementerian Lingkungan Hidup - SIPSN',
    sourceUrl: 'https://sipsn.menlhk.go.id/',
  ),

  // ============================================================
  // ARTIKEL 4
  // ============================================================
  Article(
    id: 4,
    title: 'Mengenal Sampah Organik dan Pengelolaannya',
    description:
        'Mengenal sampah organik, contoh yang sering ditemukan, serta pilihan pengelolaan yang dapat dilakukan.',
    category: 'Edukasi',
    readTime: '7 menit',
    author: 'Pilara',
    updatedDate: '5 Oktober 2026',
    headerImage:
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=1200&q=80',
    icon: Icons.eco_rounded,
    introduction:
        'Aktivitas rumah tangga menghasilkan banyak material organik, terutama dari kegiatan memasak dan konsumsi makanan. Apabila tidak dipisahkan, sampah organik dapat tercampur dengan material lainnya dan membuat proses pengelolaan menjadi lebih sulit.',
    sections: [
      ArticleSection(
        title: 'Apa yang dimaksud dengan sampah organik?',
        content:
            'Sampah organik berasal dari material yang dapat mengalami proses penguraian secara alami. Contohnya dapat ditemukan dari sisa makanan, kulit buah, sayuran, daun, dan berbagai sisa kegiatan yang berasal dari bahan organik.\n\n'
            'Karakteristik tersebut membuat sampah organik membutuhkan pendekatan pengelolaan yang berbeda dari material seperti plastik, logam, atau kaca.',
      ),
      ArticleSection(
        title: 'Contoh sampah organik di rumah',
        content:
            'Dapur merupakan salah satu tempat utama munculnya sampah organik. Sisa nasi, sayuran yang tidak digunakan, kulit buah, dan sisa bahan makanan merupakan contoh yang umum ditemukan.\n\n'
            'Di luar rumah, daun kering dan sisa kegiatan berkebun juga dapat menjadi bagian dari sampah organik.',
      ),
      ArticleSection(
        title: 'Mengapa perlu dipisahkan?',
        content:
            'Pemisahan sampah organik membantu mencegah material tersebut tercampur dengan sampah lain. Sampah yang sudah tercampur dapat menjadi lebih sulit untuk dimanfaatkan atau diolah.\n\n'
            'Dengan memisahkannya sejak awal, pengelolaan dapat dilakukan berdasarkan karakteristik material dan fasilitas yang tersedia.',
      ),
      ArticleSection(
        title: 'Pengomposan',
        content:
            'Salah satu bentuk pengelolaan sampah organik adalah pengomposan. Melalui proses yang sesuai, material organik dapat diolah menjadi kompos yang dapat dimanfaatkan untuk kebutuhan tertentu.\n\n'
            'Pengomposan membutuhkan kondisi dan pengelolaan yang tepat sehingga tidak semua sampah organik dapat langsung dicampurkan tanpa memperhatikan prosesnya.',
      ),
      ArticleSection(
        title: 'Kurangi makanan yang terbuang',
        content:
            'Selain mengelola sampah yang sudah dihasilkan, langkah yang tidak kalah penting adalah mengurangi timbulnya sampah sejak awal. Mengambil makanan sesuai kebutuhan, menyimpan bahan makanan dengan baik, dan memanfaatkan makanan secara optimal merupakan beberapa kebiasaan yang dapat dilakukan.',
      ),
    ],
    importantPoints: [
      'Sisa makanan termasuk sampah organik.',
      'Pisahkan sampah organik dari material lainnya.',
      'Daun dan sisa kegiatan berkebun dapat dipilah.',
      'Sampah organik tertentu dapat diolah melalui komposting.',
      'Kurangi makanan yang terbuang sejak dari sumbernya.',
    ],
    sourceName: 'Kementerian Lingkungan Hidup - SIPSN',
    sourceUrl: 'https://sipsn.menlhk.go.id/',
  ),

  // ============================================================
  // ARTIKEL 5
  // ============================================================
  Article(
    id: 5,
    title: 'Mengenal Sampah yang Mengandung B3 dan Limbah Elektronik',
    description:
        'Mengapa baterai, barang elektronik rusak, dan beberapa produk rumah tangga perlu dipilah secara khusus.',
    category: 'Edukasi',
    readTime: '7 menit',
    author: 'Pilara',
    updatedDate: '3 Oktober 2026',
    headerImage:
        'https://images.unsplash.com/photo-1605600659908-0ef719419d41?auto=format&fit=crop&w=1200&q=80',
    icon: Icons.warning_amber_rounded,
    introduction:
        'Di dalam rumah terdapat berbagai produk yang setelah tidak digunakan tidak sebaiknya langsung dicampurkan dengan sampah rumah tangga biasa. Beberapa di antaranya adalah produk yang mengandung B3 atau Limbah B3 dan barang elektronik yang sudah rusak.',
    sections: [
      ArticleSection(
        title: 'Mengapa membutuhkan penanganan khusus?',
        content:
            'Beberapa produk rumah tangga memiliki karakteristik yang membuatnya membutuhkan pengelolaan berbeda. Apabila dibuang sembarangan atau dicampurkan dengan sampah lainnya, risiko terhadap lingkungan dan kesehatan dapat meningkat.\n\n'
            'Karena itu, pemilahan menjadi tahap penting untuk memastikan material tersebut dapat diarahkan ke sistem pengelolaan yang sesuai.',
      ),
      ArticleSection(
        title: 'Contoh yang dapat ditemukan di rumah',
        content:
            'Contoh yang sering dijumpai antara lain baterai bekas, produk rumah tangga yang mengandung bahan tertentu, kemasan produk yang mengandung B3, barang elektronik yang sudah rusak, dan material lain sesuai karakteristik yang ditetapkan dalam peraturan.\n\n'
            'Jenis dan karakteristik setiap material perlu diperhatikan karena tidak semuanya dapat diperlakukan dengan cara yang sama.',
      ),
      ArticleSection(
        title: 'Pisahkan dari sampah biasa',
        content:
            'Material yang termasuk kategori khusus sebaiknya dipisahkan sejak dari sumbernya. Jangan langsung memasukkannya ke wadah sampah rumah tangga biasa apabila tersedia sistem pengumpulan khusus.\n\n'
            'Peraturan Menteri Lingkungan Hidup dan Kehutanan juga mengatur pemilahan sampah yang mengandung B3 dan Limbah B3 berdasarkan kelompok tertentu, termasuk produk rumah tangga, kemasan bekas, barang elektronik rusak, serta B3 kedaluwarsa atau tumpah.',
      ),
      ArticleSection(
        title: 'Cari fasilitas pengelolaan yang sesuai',
        content:
            'Setelah dipisahkan, material tersebut perlu diarahkan ke fasilitas atau sistem pengumpulan yang menerima jenis sampah tersebut. Jangan membuang material khusus secara sembarangan hanya karena ukurannya kecil.\n\n'
            'Informasi mengenai fasilitas pengelolaan dapat berbeda berdasarkan wilayah. Karena itu, masyarakat perlu mencari fasilitas yang sesuai di daerah masing-masing.',
      ),
      ArticleSection(
        title: 'Peran aplikasi dalam pemilahan',
        content:
            'Informasi mengenai jenis sampah dapat membantu pengguna menentukan langkah awal sebelum membuang suatu barang. Melalui aplikasi seperti Pilara, pengguna dapat mengenali kategori sampah dan mencari informasi mengenai pengelolaannya.\n\n'
            'Namun, untuk material yang membutuhkan penanganan khusus, pengguna tetap perlu mengikuti ketentuan dan fasilitas pengelolaan yang berlaku di wilayahnya.',
      ),
    ],
    importantPoints: [
      'Tidak semua sampah dapat dicampurkan dengan sampah rumah tangga.',
      'Baterai bekas perlu mendapatkan perhatian khusus.',
      'Barang elektronik rusak perlu dipilah sesuai ketentuan.',
      'Jangan membuang sampah khusus sembarangan.',
      'Cari fasilitas pengumpulan yang sesuai.',
    ],
    sourceName: 'Kementerian Lingkungan Hidup dan Kehutanan',
    sourceUrl: 'https://jdih.menlhk.go.id/',
  ),

  // ============================================================
  // ARTIKEL 6
  // ============================================================
  Article(
    id: 6,
    title: 'Pengelolaan Sampah dari Rumah hingga Fasilitas Pengolahan',
    description:
        'Memahami perjalanan sampah setelah dipilah dan mengapa pemilahan dari sumber sangat penting.',
    category: 'Lingkungan',
    readTime: '8 menit',
    author: 'Pilara',
    updatedDate: '1 Oktober 2026',
    headerImage:
        'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?auto=format&fit=crop&w=1200&q=80',
    icon: Icons.home_work_outlined,
    introduction:
        'Pengelolaan sampah bukan hanya persoalan membuang sampah ke tempat yang tersedia. Setelah sampah dihasilkan, terdapat rangkaian proses yang dapat meliputi pemilahan, pengumpulan, pengangkutan, pengolahan, hingga pemrosesan akhir. Setiap tahap memiliki peran dalam menentukan bagaimana sampah akhirnya dikelola.',
    sections: [
      ArticleSection(
        title: 'Sampah dimulai dari sumbernya',
        content:
            'Sumber sampah dapat berasal dari rumah tangga, perkantoran, pasar, fasilitas publik, kawasan, dan berbagai kegiatan lainnya. Karena setiap aktivitas menghasilkan jenis dan jumlah sampah yang berbeda, pengelolaan perlu memperhatikan karakteristik sumber tersebut.\n\n'
            'Tahap paling awal adalah ketika sampah muncul. Pada tahap ini, masyarakat memiliki peran penting karena keputusan untuk mengurangi dan memilah dapat dilakukan langsung.',
      ),
      ArticleSection(
        title: 'Pemilahan dari sumber',
        content:
            'Pemilahan dari sumber membuat sampah yang dihasilkan tidak langsung tercampur. Hal ini penting karena sampah yang sudah terpilah akan lebih mudah dikumpulkan dan diarahkan ke fasilitas pengelolaan yang sesuai.\n\n'
            'Dalam pengelolaan bank sampah, misalnya, sampah yang dikumpulkan dari rumah tangga dapat dipersyaratkan sudah dipilah berdasarkan jenisnya. Sampah yang telah dipilah kemudian dikumpulkan dalam wadah yang sesuai dan diberi label.',
      ),
      ArticleSection(
        title: 'Pengumpulan dan pengangkutan',
        content:
            'Setelah dipilah, sampah dapat dikumpulkan untuk kemudian dibawa ke fasilitas pengelolaan. Sistem pengumpulan dapat dilakukan oleh masyarakat sendiri atau oleh pengelola sesuai mekanisme yang berlaku di wilayah tersebut.\n\n'
            'Sampah yang sudah terpilah sebaiknya tetap dijaga agar tidak tercampur kembali selama proses pengumpulan dan pengangkutan.',
      ),
      ArticleSection(
        title: 'Pengolahan dan pemanfaatan',
        content:
            'Material yang masih memiliki nilai guna dapat diarahkan untuk digunakan kembali, didaur ulang, atau dimanfaatkan melalui proses lain yang sesuai. Sampah organik tertentu dapat masuk ke proses pengolahan seperti komposting.\n\n'
            'Sistem pengelolaan juga dapat melibatkan bank sampah, TPS 3R, TPST, rumah kompos, dan berbagai fasilitas lainnya sesuai kondisi wilayah.',
      ),
      ArticleSection(
        title: 'Bagaimana dengan sampah yang tidak dapat dimanfaatkan?',
        content:
            'Tidak seluruh sampah dapat dimanfaatkan kembali atau didaur ulang. Material yang menjadi residu setelah proses pengelolaan perlu diarahkan ke tahap pemrosesan akhir sesuai sistem yang berlaku.\n\n'
            'Karena itu, tujuan pengelolaan sampah bukan hanya memindahkan sampah dari satu tempat ke tempat lain, tetapi juga mengurangi jumlah sampah yang dihasilkan dan meningkatkan jumlah material yang dapat dikelola dengan tepat.',
      ),
      ArticleSection(
        title: 'Peran masyarakat sangat penting',
        content:
            'Pengelolaan sampah membutuhkan keterlibatan berbagai pihak. Pemerintah, pengelola fasilitas, dunia usaha, dan masyarakat memiliki peran masing-masing.\n\n'
            'Bagi masyarakat, salah satu kontribusi paling sederhana tetapi penting adalah mengurangi sampah, memilah dari sumber, dan menyerahkan sampah kepada sistem pengelolaan yang sesuai. Kebiasaan tersebut dapat membantu proses pengelolaan pada tahap berikutnya.',
      ),
    ],
    importantPoints: [
      'Pengelolaan sampah dimulai dari sumbernya.',
      'Pemilahan membuat proses pengumpulan lebih mudah.',
      'Sampah harus dijaga agar tidak tercampur kembali.',
      'Material yang masih bernilai dapat diarahkan untuk dimanfaatkan.',
      'Residu perlu ditangani melalui pemrosesan akhir yang sesuai.',
      'Masyarakat memiliki peran penting dalam pengelolaan sampah.',
    ],
    sourceName: 'SIPSN - Kementerian Lingkungan Hidup',
    sourceUrl: 'https://sipsn.menlhk.go.id/',
  ),
];