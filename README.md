# Pilara

Pilara adalah aplikasi berbasis Flutter yang membantu masyarakat dalam memilah sampah secara lebih mudah, cepat, dan edukatif. Aplikasi ini menggabungkan fitur klasifikasi sampah berbasis kamera dengan informasi edukasi agar pengguna lebih sadar terhadap pentingnya pengelolaan sampah yang benar.

## Daftar Isi

- [Tentang Aplikasi](#tentang-aplikasi)
- [Fitur Utama](#fitur-utama)
- [Teknologi](#teknologi)
- [Kategori Sampah](#kategori-sampah)
- [Machine Learning](#machine-learning)
- [Tampilan Aplikasi](#tampilan-aplikasi)"
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
- Kamera (identifikasi foto dengan Gemini)
- Riwayat
- Profile
- Artikel
- Pilala (chat asisten kebersihan dan identifikasi sampah dari foto)

Penjelasan singkat:

- Home: menampilkan ringkasan fitur dan navigasi utama aplikasi.
- Pilah Sampah: fitur utama untuk mengelompokkan sampah berdasarkan kategori.
- Kamera: mengambil foto sampah untuk klasifikasi menggunakan Firebase AI Logic.
- Riwayat: menampilkan aktivitas atau data sampah yang sebelumnya diproses.
- Profile: menampung data pengguna dan pengaturan akun.
- Artikel: menyediakan edukasi terkait sampah, lingkungan, dan pengelolaan limbah.
- Pilala: menjawab pertanyaan seputar kebersihan dan mengidentifikasi sampah dari foto.

## Teknologi

Project ini dibangun menggunakan teknologi berikut:

- Flutter
- Dart
- Camera
- Firebase AI Logic (`firebase_ai`)
- Geolocator
- Flutter Map
- Maps Launcher
- URL Launcher
- Firebase App Check dan `image_picker`

Kamera dan identifikasi foto di Pilala memakai layanan Gemini yang sama.
File model TFLite lama masih tersimpan sebagai aset, tetapi tidak digunakan oleh
alur klasifikasi saat ini.

Profil mendukung perubahan nama dan bio melalui backend, sedangkan email tetap
menjadi informasi login. Preferensi tampilan terang/gelap disimpan pada
perangkat dan diterapkan ke tema aplikasi.

## Kategori Sampah

Aplikasi Pilara mengelompokkan sampah ke dalam beberapa kategori utama, yaitu:

- Anorganik
- B3
- Organik
- Lainnya

Kategori ini digunakan untuk membantu proses klasifikasi dan edukasi mengenai jenis sampah yang berbeda serta cara penanganannya.

## Identifikasi Sampah

Kamera utama dan unggah foto di chat Pilala memakai Firebase AI Logic dengan
model `gemini-2.5-flash`. Foto kamera disiapkan maksimal 1024x1024 piksel dan
dikompresi sebelum dikirim. Hasil berisi nama benda, kategori, dan cara
pengolahan; hasil kamera disimpan ke riwayat tanpa skor confidence yang tidak
disediakan oleh model.

Model TFLite dan label lama masih ada di `assets/models/`, tetapi tidak aktif
dalam alur klasifikasi ini. Mengaktifkannya kembali memerlukan dataset serta
pemetaan kelas yang sesuai dengan model.

## Tampilan Aplikasi

Berikut adalah area tampilan utama yang terdapat pada aplikasi Pilara:

- Home Screen
- Pilah Sampah Screen
- Kamera / Scan Sampah Screen
- Riwayat Screen
- Profile Screen
- Artikel Screen

Bagian ini dapat ditambahkan screenshot aplikasi secara manual jika Anda menginginkannya di versi dokumentasi yang lebih formal atau saat proyek sudah siap dipublikasikan.

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

### Login Google

Login Google adalah opsi terpisah pada Android; pengguna dapat memilihnya tanpa
pernah mendaftar atau masuk dengan email/password. Pada login Google pertama,
backend membuat akun Pilara otomatis dari identitas Google terverifikasi. Jika
email Google cocok dengan akun Pilara yang sudah ada, akun tersebut digunakan
kembali tanpa meminta password. Aktifkan provider Google pada Firebase Console di
**Authentication → Sign-in method**, lalu daftarkan SHA-1 dari signing key
debug dan release yang benar pada pengaturan aplikasi Android Firebase.
Konfigurasi lokal `google-services.json` harus cocok dengan package
`com.example.pilara`.

Aplikasi menukar kredensial Google menjadi Firebase ID token, lalu mengirimnya
ke endpoint backend `/api/auth/google`. Backend memverifikasi token menggunakan
Firebase Admin dan menerbitkan token Pilara untuk pemanggilan REST API. Simpan
kredensial Firebase Admin hanya di server; jangan masukkan file service account
ke aplikasi.

### Integrasi Firebase AI Pilala

Fitur chat Pilala dan identifikasi sampah dari foto menggunakan Firebase AI Logic
(`firebase_ai`) dengan model `gemini-2.5-flash`.

1. Buat atau pilih project Firebase, lalu jalankan `flutterfire configure` dari
   direktori `Pilara` dan daftarkan aplikasi Android/iOS/macOS yang digunakan.
2. Aktifkan Firebase AI Logic pada project tersebut.
3. Jalankan aplikasi pada Android, iOS, atau macOS. Konfigurasi App Check
   menggunakan provider debug pada build debug dan Play Integrity / App Attest
   pada build rilis. Daftarkan debug token yang muncul di log pada Firebase
   Console sebelum menguji project yang mewajibkan App Check.
4. Buka tab Home lalu tekan tombol **Pilala**. Ikon foto dapat digunakan untuk
   mengambil gambar atau memilih foto; gambar dibatasi hingga 1024×1024 dengan
   kualitas 80 sebelum dikirim untuk dianalisis.

Firebase AI Logic belum didukung oleh konfigurasi Pilara untuk Windows, Linux,
atau web. Jangan menambahkan API key atau kredensial service account ke source
code aplikasi.

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
- Pilala AI (chat kebersihan dan identifikasi sampah dari foto)
- Integrasi model TFLite

### Masih dalam pengembangan

- Optimasi akurasi model klasifikasi sampah
- Peningkatan desain UI/UX
- Penambahan data riwayat yang lebih lengkap
- Penyempurnaan fitur edukasi dan analitik penggunaan
- Pengujian lintas perangkat dan perbaikan bug

## Tim Pengembang

Pilara dikembangkan oleh tim yang terdiri dari:

- Cyrilla Nathania Silalahi 241401067
- Muhammad Adli Humaidi 241401103
- Resti Nadia Marpaung 241401139

Pilara adalah proyek yang menggabungkan teknologi mobile modern dengan kecerdasan buatan untuk mendorong perubahan perilaku masyarakat dalam membuang dan memilah sampah dengan lebih bijak.
