# Pilara

Pilara adalah aplikasi berbasis Flutter yang membantu masyarakat dalam memilah sampah secara lebih mudah, cepat, dan edukatif. Aplikasi ini menggabungkan fitur klasifikasi sampah berbasis kamera dengan informasi edukasi agar pengguna lebih sadar terhadap pentingnya pengelolaan sampah yang benar.

## Daftar Isi

- [Tentang Aplikasi](#tentang-aplikasi)
- [Fitur Utama](#fitur-utama)
- [Teknologi](#teknologi)
- [Kategori Sampah](#kategori-sampah)
- [Machine Learning](#machine-learning)
- [Tampilan Aplikasi](#tampilan-aplikasi)
- [Struktur Folder](#struktur-folder)
- [Instalasi](#instalasi)
- [Status Pengembangan](#status-pengembangan)
- [Tim Pengembang](#tim-pengembang)

## Tentang Aplikasi

Pilara hadir sebagai solusi digital untuk mendukung pengelolaan sampah rumah tangga dan lingkungan. Latar belakang aplikasi ini berangkat dari kebutuhan masyarakat untuk mengenali jenis sampah dengan lebih mudah, sekaligus mendorong kebiasaan memilah sampah sejak dini.

Tujuan utama Pilara adalah:

- mempermudah pengguna dalam mengidentifikasi jenis sampah,
- membantu pengelolaan sampah berdasarkan kategori yang benar,
- memberikan edukasi melalui artikel dan informasi lingkungan,
- meningkatkan kesadaran serta partisipasi masyarakat dalam pengelolaan sampah.

## Fitur Utama

Aplikasi Pilara memiliki beberapa fitur utama, yaitu:

- Home
- Pilah Sampah
- Kamera
- Riwayat
- Profile
- Artikel

Penjelasan singkat:

- Home: menampilkan ringkasan fitur dan navigasi utama aplikasi.
- Pilah Sampah: fitur utama untuk mengelompokkan sampah berdasarkan kategori.
- Kamera: memungkinkan pengguna mengunggah atau mengambil foto sampah untuk klasifikasi.
- Riwayat: menampilkan aktivitas atau data sampah yang sebelumnya diproses.
- Profile: menampung data pengguna dan pengaturan akun.
- Artikel: menyediakan edukasi terkait sampah, lingkungan, dan pengelolaan limbah.

## Teknologi

Project ini dibangun menggunakan teknologi berikut:

- Flutter
- Dart
- TensorFlow Lite
- Camera
- Geolocator
- Flutter Map
- Maps Launcher
- URL Launcher
- Model ML berbasis file TFLite (`assets/models/model.tflite`)

Teknologi yang benar-benar digunakan dalam proyek ini sesuai dependensi utama yang terpasang adalah Flutter, Dart, TensorFlow Lite, camera, geolocator, flutter_map, maps_launcher, dan url_launcher.

## Kategori Sampah

Aplikasi Pilara mengelompokkan sampah ke dalam beberapa kategori utama, yaitu:

- Anorganik
- B3
- Organik
- Lainnya

Kategori ini digunakan untuk membantu proses klasifikasi dan edukasi mengenai jenis sampah yang berbeda serta cara penanganannya.

## Machine Learning

Pilara menggunakan pendekatan Machine Learning berbasis model TensorFlow Lite untuk mengklasifikasikan sampah.

### Dataset

- Dataset dikategorikan sesuai kelas sampah yang sesuai dengan kebutuhan aplikasi.
- Label kelas disimpan pada file `assets/models/labels.txt`.
- Model utama disimpan pada `assets/models/model.tflite`.

### Proses Training

- Proses pelatihan model dilakukan pada data sampah dengan label yang sudah diklasifikasikan.
- Data diproses melalui tahap preprocessing agar format gambar dan fitur konsisten sebelum masuk ke model.
- Model kemudian dikonversi ke format TensorFlow Lite agar dapat digunakan pada aplikasi mobile.

### Arsitektur Model

- Model yang digunakan bersifat klasifikasi citra sampah.
- Pada tahap implementasi, model berbasis jaringan konvolusional (CNN) atau pendekatan image classifier yang sesuai dengan kebutuhan klasifikasi sampah.
- Output model akan menghasilkan label kelas sampah yang sesuai dengan kategori yang telah ditentukan.

### Evaluasi

- Evaluasi model perlu dilakukan dengan menghitung akurasi, loss, serta performa klasifikasi pada data uji.
- Keberhasilan model diukur berdasarkan sejauh mana model mampu membedakan sampah sesuai kategori dengan hasil yang stabil dan konsisten.
- Hasil evaluasi juga menjadi dasar untuk peningkatan kualitas model di pengembangan berikutnya.

Tampilan Aplikasi

Berikut adalah area tampilan utama yang terdapat pada aplikasi Pilara:

Home Screen

<p align="center">
<img src="https://github.com/user-attachments/assets/2b5e3ebe-05b6-4122-b599-16cb11b529b3" alt="Home Screen Pilara" width="280" />
</p>

Pilah Sampah Screen

<p align="center">
<img src="https://github.com/user-attachments/assets/55ef2534-d7c0-4b02-9c56-c29651703831" alt="Pilah Sampah Screen 1" width="280" />
&nbsp;&nbsp;
<img src="https://github.com/user-attachments/assets/30677e5a-6b8a-4dea-b06e-91726ed0bcf3" alt="Pilah Sampah Screen 2" width="280" />
</p>

Kamera / Scan Sampah Screen

<p align="center">
<img src="https://github.com/user-attachments/assets/356360d4-0450-45cb-ba28-d8a9ac82dce2" alt="Kamera / Scan Sampah Screen" width="280" />
</p>

Riwayat Screen

<p align="center">
<img src="https://github.com/user-attachments/assets/57d9ca80-d3bd-49c0-9d4e-6b1e87ef0217" alt="Riwayat Screen 1" width="280" />
&nbsp;&nbsp;
<img src="https://github.com/user-attachments/assets/e2e15cc9-975d-4a1f-b631-38f8bd70da51" alt="Riwayat Screen 2" width="280" />
</p>

Profile Screen

<p align="center">
<img src="https://github.com/user-attachments/assets/48c73007-3d46-4538-b264-8c3e7f3d97f8" alt="Profile Screen 1" width="280" />
&nbsp;&nbsp;
<img src="https://github.com/user-attachments/assets/b3fe569c-1536-440a-9039-7853edb955b9" alt="Profile Screen 2" width="280" />
</p>

Artikel Screen

<p align="center">
<img src="https://github.com/user-attachments/assets/3d14e8de-23e3-41f1-94c5-909a4913e1d4" alt="Artikel Screen Pilara" width="280" />
</p>

## Struktur Folder

Berikut struktur folder penting dalam project Pilara:

```text
pilara/
├─ android/              # Konfigurasi project Android
├─ ios/                  # Konfigurasi project iOS
├─ linux/                # Konfigurasi project Linux
├─ macos/                # Konfigurasi project macOS
├─ windows/              # Konfigurasi project Windows
├─ web/                  # Konfigurasi project web
├─ assets/
│  ├─ images/           # Gambar/logo/UI assets
│  └─ models/
│     ├─ model.tflite   # Model TensorFlow Lite
│     └─ labels.txt     # Label kelas model
├─ lib/
│  ├─ data/             # Data dummy dan data aplikasi
│  ├─ routers/          # Routing aplikasi
│  ├─ screens/          # Halaman utama aplikasi
│  ├─ services/         # Logika layanan dan integrasi
│  └─ main.dart         # Entry point aplikasi
├─ test/                 # Uji otomatis
├─ analysis_options.yaml
├─ pubspec.yaml          # Konfigurasi dependency Flutter
├─ README.md            # Dokumentasi project
└─ ...
```

## Instalasi

Untuk menjalankan project Pilara di komputer, ikuti langkah berikut:

1. Pastikan Flutter dan Dart sudah terpasang di komputer Anda.
2. Clone repository project ini.
3. Masuk ke folder project:

```bash
cd Pilara
```

4. Instal dependency project:

```bash
flutter pub get
```

5. Jalankan aplikasi:

```bash
flutter run
```

Untuk menjalankan pada perangkat tertentu, gunakan:

```bash
flutter devices
flutter run -d <device-id>
```

Jika ingin dijalankan di browser, dapat menggunakan:

```bash
flutter run -d chrome
```

## Status Pengembangan

Status pengembangan proyek Pilara saat ini:

### Sudah dikembangkan

- Splash screen
- Sign in / sign up
- Home
- Kamera
- Pilah Sampah
- Riwayat
- Profile
- Artikel
- Integrasi model TFLite

### Masih dalam pengembangan

- Optimasi akurasi model klasifikasi sampah
- Peningkatan desain UI/UX
- Penambahan data riwayat yang lebih lengkap
- Penyempurnaan fitur edukasi dan analitik penggunaan
- Pengujian lintas perangkat dan perbaikan bug

## Tim Pengembang

Pilara dikembangkan oleh tim yang terdiri dari:

- Cyrilla Nathania Silalahi 241401103
- Muhammad Adli Humaidi 241401103
- Resti Nadia Marpaung 241401139

Pilara adalah proyek yang menggabungkan teknologi mobile modern dengan kecerdasan buatan untuk mendorong perubahan perilaku masyarakat dalam membuang dan memilah sampah dengan lebih bijak.
