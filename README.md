# Pilara

## Firebase AI dan Google Sign-In

Pilala memakai Firebase AI Logic untuk chat dan identifikasi foto. Login Google
mengambil Firebase ID token, lalu menukarkannya ke backend Pilara untuk sesi API.
Android memakai konfigurasi Firebase lokal di `android/app/google-services.json`;
file konfigurasi itu diabaikan Git dan tidak boleh dikirim sebagai pengganti
kredensial server.

Gunakan project Firebase yang sama pada aplikasi dan backend. Aktifkan Google
sebagai provider di Firebase Authentication, Firebase AI Logic untuk model yang
dipakai, serta daftarkan SHA aplikasi Android untuk Google Sign-In. Pada build
debug, daftarkan token Firebase App Check debug sesuai petunjuk log perangkat.

Backend perlu menerima `FIREBASE_PROJECT_ID`, `GOOGLE_APPLICATION_CREDENTIALS`,
dan `JWT_SECRET` melalui environment runtime. Jangan masukkan kredensial Admin
atau secret ke aplikasi Flutter. Konfigurasi `GoogleService-Info.plist` dan URL
scheme OAuth untuk iOS/macOS belum tersedia di worktree ini; platform tersebut
memerlukan konfigurasi Firebase tersendiri.

Jalankan `flutter pub get`, lalu `flutter run` dengan `PILARA_API_URL` yang
mengarah ke backend. Untuk Android emulator, gunakan `http://10.0.2.2:8080`.
