import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/dummy_articles.dart';
import '../data/dummy_pilah.dart';
import '../data/dummy_riwayat.dart' as dummy_riwayat;

class PilaraApi {
  PilaraApi._();

  static final PilaraApi instance = PilaraApi._();

  // Lazy: Firebase baru diakses saat dipakai, bukan saat objek dibuat.
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  Future<AppUser?> currentUser() async {
    final user = await _guard(() => _auth.authStateChanges().first);
    return user == null ? null : _toUser(user);
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final credential = await _guard(
      () => _auth.signInWithEmailAndPassword(email: email, password: password),
    );
    return _toUser(credential.user!);
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _guard(
      () => _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
    await credential.user!.updateDisplayName(name);
    return AppUser(id: 0, name: name, email: email);
  }

  Future<void> clearSession() => _auth.signOut();

  Future<List<Article>> fetchArticles() async {
    try {
      final snapshot = await _guard(
        _db.collection('articles').orderBy('id').get,
      );
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
      }
    } catch (_) {
      // Firestore gagal: pakai data dummy.
    }
    return dummyArticles;
  }

  Future<List<WastePoint>> fetchWastePoints() async {
    try {
      final snapshot = await _guard(_db.collection('wastePoints').get);
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => WastePoint.fromJson(doc.data()))
            .toList();
      }
    } catch (_) {
      // Firestore gagal: pakai data dummy.
    }
    return [
      for (var i = 0; i < dummyWastePoints.length; i++)
        WastePoint(
          id: '${i + 1}',
          name: dummyWastePoints[i].name,
          address: dummyWastePoints[i].address,
          description: dummyWastePoints[i].description,
          latitude: dummyWastePoints[i].latitude,
          longitude: dummyWastePoints[i].longitude,
          acceptedWaste: dummyWastePoints[i].acceptedWaste,
          rating: dummyWastePoints[i].rating,
          openTime: dummyWastePoints[i].openTime,
          icon: switch (dummyWastePoints[i].acceptedWaste.first) {
            'Organik' => 'eco',
            'B3' => 'warning',
            'Lainnya' => 'delete',
            _ => 'recycling',
          },
        ),
    ];
  }

  Future<ActivitySummary> fetchActivities({DateTime? month}) async {
    try {
      return await _fetchActivitiesFromFirestore(month: month);
    } catch (_) {
      // Firestore gagal: pakai data dummy.
      return _dummyActivities(month: month);
    }
  }

  ActivitySummary _dummyActivities({DateTime? month}) {
    final activities = <ActivityRecord>[];
    for (final item in dummy_riwayat.dummyActivities) {
      if (month != null &&
          (item.date.year != month.year || item.date.month != month.month)) {
        continue;
      }
      final time = item.time.split(':');
      activities.add(
        ActivityRecord(
          id: 'dummy-${activities.length}',
          title: item.title,
          subtitle: item.subtitle,
          category: item.category,
          wasteType: item.wasteType,
          points: item.points,
          confidence: null,
          occurredAt: DateTime(
            item.date.year,
            item.date.month,
            item.date.day,
            int.parse(time[0]),
            int.parse(time[1]),
          ),
        ),
      );
    }
    return ActivitySummary(
      activities: activities,
      totalPoints: activities.fold(0, (total, a) => total + a.points),
      totalActivities: activities.length,
      sortedCount: activities.where((a) => a.category == 'Dipilah').length,
      depositedCount: activities.where((a) => a.category == 'Disetor').length,
    );
  }

  Future<ActivitySummary> _fetchActivitiesFromFirestore({
    DateTime? month,
  }) async {
    var query = _activities().orderBy('occurredAt', descending: true);
    if (month != null) {
      query = query
          .where(
            'occurredAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(
              DateTime(month.year, month.month),
            ),
          )
          .where(
            'occurredAt',
            isLessThan: Timestamp.fromDate(
              DateTime(month.year, month.month + 1),
            ),
          );
    }
    final snapshot = await _guard(query.get);
    final activities = snapshot.docs
        .map((doc) => ActivityRecord.fromDoc(doc))
        .toList();
    return ActivitySummary(
      activities: activities,
      totalPoints: activities.fold(0, (total, a) => total + a.points),
      totalActivities: activities.length,
      sortedCount: activities.where((a) => a.category == 'Dipilah').length,
      depositedCount: activities.where((a) => a.category == 'Disetor').length,
    );
  }

  Future<ActivityRecord> recordClassification({
    required String wasteType,
    required double confidence,
  }) async {
    final data = {
      'title': 'Memilah sampah $wasteType',
      'subtitle': 'Hasil scan kamera',
      'category': 'Dipilah',
      'wasteType': wasteType,
      'points': 10,
      'confidence': confidence,
      'occurredAt': Timestamp.now(),
    };
    final doc = await _guard(() => _activities().add(data));
    return ActivityRecord.fromDoc(await doc.get());
  }

  CollectionReference<Map<String, dynamic>> _activities() {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ApiException('Silakan masuk untuk menggunakan fitur ini.');
    }
    return _db.collection('users').doc(user.uid).collection('activities');
  }

  AppUser _toUser(User user) => AppUser(
    id: 0,
    name: user.displayName ?? user.email ?? 'Pengguna',
    email: user.email ?? '',
  );

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (error) {
      throw ApiException(switch (error.code) {
        'invalid-credential' ||
        'wrong-password' ||
        'user-not-found' => 'Email atau kata sandi salah.',
        'email-already-in-use' => 'Email sudah terdaftar.',
        'weak-password' => 'Kata sandi terlalu lemah.',
        'invalid-email' => 'Format email tidak valid.',
        'network-request-failed' => 'Tidak ada koneksi internet.',
        _ => error.message ?? 'Autentikasi gagal.',
      });
    } on FirebaseException catch (error) {
      throw ApiException(error.message ?? 'Permintaan ke Firebase gagal.');
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
  });

  final int id;
  final String name;
  final String email;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
  );
}

class WastePoint {
  const WastePoint({
    required this.id,
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

  final String id;
  final String name;
  final String address;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> acceptedWaste;
  final double rating;
  final String openTime;
  final String icon;

  factory WastePoint.fromJson(Map<String, dynamic> json) => WastePoint(
    id: json['id'] as String,
    name: json['name'] as String,
    address: json['address'] as String,
    description: json['description'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    acceptedWaste: (json['acceptedWaste'] as List<dynamic>).cast<String>(),
    rating: (json['rating'] as num).toDouble(),
    openTime: json['openTime'] as String,
    icon: json['icon'] as String,
  );
}

class ActivityRecord {
  const ActivityRecord({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.wasteType,
    required this.points,
    required this.confidence,
    required this.occurredAt,
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String wasteType;
  final int points;
  final double? confidence;
  final DateTime occurredAt;

  factory ActivityRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data()!;
    return ActivityRecord(
      id: doc.id,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      category: json['category'] as String,
      wasteType: json['wasteType'] as String,
      points: json['points'] as int,
      confidence: (json['confidence'] as num?)?.toDouble(),
      occurredAt: (json['occurredAt'] as Timestamp).toDate(),
    );
  }
}

class ActivitySummary {
  const ActivitySummary({
    required this.activities,
    required this.totalPoints,
    required this.totalActivities,
    required this.sortedCount,
    required this.depositedCount,
  });

  final List<ActivityRecord> activities;
  final int totalPoints;
  final int totalActivities;
  final int sortedCount;
  final int depositedCount;
}
