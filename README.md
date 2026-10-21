♻️ Pilara

Pilara — Aplikasi Pintar untuk Memilah Sampah

Pilara adalah aplikasi berbasis Flutter yang membantu masyarakat memilah sampah dengan lebih mudah, cepat, dan edukatif. Aplikasi ini menggabungkan fitur klasifikasi sampah berbasis kamera dengan informasi edukasi untuk meningkatkan kesadaran terhadap pentingnya pengelolaan sampah yang benar.

📑 Daftar Isi
Tentang Aplikasi
Fitur Utama
Teknologi
Kategori Sampah
Machine Learning
Tampilan Aplikasi
Struktur Folder
Instalasi
Status Pengembangan
Tim Pengembang
🌱 Tentang Aplikasi

Pilara hadir sebagai solusi digital untuk mendukung pengelolaan sampah rumah tangga dan lingkungan. Aplikasi ini berangkat dari kebutuhan masyarakat untuk mengenali jenis sampah dengan lebih mudah sekaligus mendorong kebiasaan memilah sampah sejak dini.

Tujuan utama Pilara:

♻️ Mempermudah pengguna mengidentifikasi jenis sampah.
🗂️ Membantu pengelolaan sampah berdasarkan kategori yang benar.
📚 Memberikan edukasi melalui artikel dan informasi lingkungan.
🌍 Meningkatkan kesadaran serta partisipasi masyarakat dalam pengelolaan sampah.
✨ Fitur Utama

Pilara memiliki enam fitur utama yang dirancang untuk mendukung aktivitas pemilahan sampah dan edukasi lingkungan.

Fitur	Deskripsi
🏠 Home	Menampilkan ringkasan fitur dan navigasi utama aplikasi.
♻️ Pilah Sampah	Fitur utama untuk mengelompokkan sampah berdasarkan kategori.
📷 Kamera	Memungkinkan pengguna mengunggah atau mengambil foto sampah untuk klasifikasi.
🕘 Riwayat	Menampilkan aktivitas atau data sampah yang sebelumnya diproses.
👤 Profile	Menampung data pengguna dan pengaturan akun.
📖 Artikel	Menyediakan edukasi terkait sampah, lingkungan, dan pengelolaan limbah.
🛠️ Teknologi

Proyek Pilara dibangun menggunakan teknologi dan pustaka berikut:

Teknologi	Kegunaan
Flutter	Pengembangan aplikasi lintas platform
Dart	Bahasa pemrograman utama
TensorFlow Lite	Menjalankan model Machine Learning pada aplikasi
Camera	Mengakses fitur kamera
Geolocator	Mengakses informasi lokasi
Flutter Map	Menampilkan peta
Maps Launcher	Membuka aplikasi peta
URL Launcher	Membuka URL dan tautan eksternal

Model Machine Learning disimpan dalam format TensorFlow Lite pada lokasi berikut:

assets/models/model.tflite

Teknologi yang digunakan dalam proyek ini mengikuti dependensi utama yang terpasang, yaitu Flutter, Dart, TensorFlow Lite, camera, geolocator, flutter_map, maps_launcher, dan url_launcher.

🗑️ Kategori Sampah

Pilara mengelompokkan sampah ke dalam empat kategori utama:

Kategori	Deskripsi
Anorganik	Kategori untuk sampah anorganik.
B3	Kategori untuk sampah bahan berbahaya dan beracun.
Organik	Kategori untuk sampah organik.
Lainnya	Kategori untuk sampah di luar kategori yang telah ditentukan.

Kategori ini digunakan untuk membantu proses klasifikasi dan edukasi mengenai jenis sampah yang berbeda serta cara penanganannya.

🤖 Machine Learning

Pilara menggunakan pendekatan Machine Learning berbasis TensorFlow Lite untuk mengklasifikasikan sampah melalui citra.

Dataset
Dataset dikategorikan sesuai kelas sampah yang dibutuhkan aplikasi.
Label kelas disimpan pada assets/models/labels.txt.
Model utama disimpan pada assets/models/model.tflite.
Proses Training
Model dilatih menggunakan data sampah yang telah diberi label.
Data melalui tahap preprocessing agar format gambar dan fitur konsisten sebelum masuk ke model.
Model dikonversi ke format TensorFlow Lite agar dapat digunakan pada aplikasi mobile.
Arsitektur Model
Model digunakan untuk melakukan klasifikasi citra sampah.
Arsitektur berbasis jaringan konvolusional (Convolutional Neural Network/CNN) atau pendekatan image classifier yang sesuai dengan kebutuhan klasifikasi sampah.
Output model menghasilkan label kelas sampah sesuai kategori yang telah ditentukan.
Evaluasi
Evaluasi model perlu dilakukan dengan menghitung akurasi, loss, serta performa klasifikasi pada data uji.
Keberhasilan model diukur berdasarkan kemampuannya membedakan sampah sesuai kategori dengan hasil yang stabil dan konsisten.
Hasil evaluasi menjadi dasar untuk meningkatkan kualitas model pada pengembangan berikutnya.
📱 Tampilan Aplikasi

Berikut adalah tampilan antarmuka utama aplikasi Pilara.

Screenshot menggunakan gambar asli yang telah diunggah ke GitHub. Tata letak berikut mengatur gambar agar lebih proporsional dan mudah dibandingkan.
🏠 Home

<p align="center">
<img src="https://github.com/user-attachments/assets/2b5e3ebe-05b6-4122-b599-16cb11b529b3" alt="Home Screen Pilara" width="280">
</p>

♻️ Pilah Sampah

<p align="center">
<img src="https://github.com/user-attachments/assets/55ef2534-d7c0-4b02-9c56-c29651703831" alt="Pilah Sampah Screen 1" width="280">
&nbsp;&nbsp;
<img src="https://github.com/user-attachments/assets/30677e5a-6b8a-4dea-b06e-91726ed0bcf3" alt="Pilah Sampah Screen 2" width="280">
</p>

📷 Kamera / Scan Sampah

<p align="center">
<img src="https://github.com/user-attachments/assets/356360d4-0450-45cb-ba28-d8a9ac82dce2" alt="Kamera dan Scan Sampah Screen" width="280">
</p>

🕘 Riwayat

<p align="center">
<img src="https://github.com/user-attachments/assets/57d9ca80-d3bd-49c0-9d4e-6b1e87ef0217" alt="Riwayat Screen 1" width="280">
&nbsp;&nbsp;
<img src="https://github.com/user-attachments/assets/e2e15cc9-975d-4a1f-b631-38f8bd70da51" alt="Riwayat Screen 2" width="280">
</p>

👤 Profile

<p align="center">
<img src="https://github.com/user-attachments/assets/48c73007-3d46-4538-b264-8c3e7f3d97f8" alt="Profile Screen 1" width="280">
&nbsp;&nbsp;
<img src="https://github.com/user-attachments/assets/b3fe569c-1536-440a-9039-7853edb955b9" alt="Profile Screen 2" width="280">
</p>

📖 Artikel

<p align="center">
<img src="https://github.com/user-attachments/assets/3d14e8de-23e3-41f1-94c5-909a4913e1d4" alt="Artikel Screen Pilara" width="280">
</p>

Bagian tampilan ini dapat diperbarui dengan screenshot tambahan secara manual untuk melengkapi dokumentasi saat proyek siap dipublikasikan.

📂 Struktur Folder

Berikut struktur folder penting dalam proyek Pilara:

pilara/
├── android/                 # Konfigurasi proyek Android
├── ios/                     # Konfigurasi proyek iOS
├── linux/                   # Konfigurasi proyek Linux
├── macos/                   # Konfigurasi proyek macOS
├── windows/                 # Konfigurasi proyek Windows
├── web/                     # Konfigurasi proyek web
├── assets/
│   ├── images/              # Gambar, logo, dan UI assets
│   └── models/
│       ├── model.tflite     # Model TensorFlow Lite
│       └── labels.txt       # Label kelas model
├── lib/
│   ├── data/                # Data dummy dan data aplikasi
│   ├── routers/             # Routing aplikasi
│   ├── screens/             # Halaman utama aplikasi
│   ├── services/            # Logika layanan dan integrasi
│   └── main.dart            # Entry point aplikasi
├── test/                    # Uji otomatis
├── analysis_options.yaml
├── pubspec.yaml             # Konfigurasi dependency Flutter
├── README.md                # Dokumentasi proyek
└── ...

🚀 Instalasi

Ikuti langkah berikut untuk menjalankan Pilara di komputer lokal.

Prasyarat
Flutter dan Dart telah terpasang di komputer.
Repository proyek telah tersedia secara lokal.
Langkah 1 — Clone Repository

Clone repository proyek ini, lalu masuk ke direktori proyek:

cd Pilara

Langkah 2 — Instal Dependency
flutter pub get

Langkah 3 — Jalankan Aplikasi
flutter run

Menjalankan pada Perangkat Tertentu

Untuk melihat daftar perangkat yang tersedia:

flutter devices


Jalankan aplikasi pada perangkat pilihan:

flutter run -d <device-id>

Menjalankan di Browser

Untuk menjalankan aplikasi di Google Chrome:

flutter run -d chrome

📈 Status Pengembangan

Pengembangan Pilara mencakup fitur utama aplikasi, integrasi Machine Learning, serta peningkatan kualitas pengalaman pengguna.

✅ Sudah Dikembangkan
Splash screen
Sign in / sign up
Home
Kamera
Pilah Sampah
Riwayat
Profile
Artikel
Integrasi model TFLite
🔧 Masih dalam Pengembangan
Optimasi akurasi model klasifikasi sampah
Peningkatan desain UI/UX
Penambahan data riwayat yang lebih lengkap
Penyempurnaan fitur edukasi dan analitik penggunaan
Pengujian lintas perangkat dan perbaikan bug
👥 Tim Pengembang

Pilara dikembangkan oleh tim yang terdiri dari:
- Cyrilla Nathania Silalahi 241401067
- Muhammad Adli Hummaidi 241401103
- Resti Nadia Marpaung 241401139

<p align="center">
<strong>♻️ Pilara — Pilah Sampah, Jaga Lingkungan.</strong>
<br>
Proyek yang menggabungkan teknologi mobile modern dengan kecerdasan buatan untuk mendorong perubahan perilaku masyarakat dalam membuang dan memilah sampah dengan lebih bijak.
</p>
