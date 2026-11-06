import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const _apiBaseUrl = String.fromEnvironment(
  'PILARA_API_URL',
  defaultValue: 'http://127.0.0.1:8080',
);

class PilaraApi {
  PilaraApi._();

  static final PilaraApi instance = PilaraApi._();

  static const _tokenKey = 'pilara_access_token';
  static const _storage = FlutterSecureStorage();
  final http.Client _client = http.Client();

  Future<AppUser?> currentUser() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null) return null;
    try {
      final response = await _send('GET', '/api/auth/me', token: token);
      return AppUser.fromJson(response['user'] as Map<String, dynamic>);
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await clearSession();
        return null;
      }
      rethrow;
    }
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _send(
      'POST',
      '/api/auth/login',
      body: {'email': email, 'password': password},
    );
    return _saveSession(response);
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _send(
      'POST',
      '/api/auth/register',
      body: {'name': name, 'email': email, 'password': password},
    );
    return _saveSession(response);
  }

  Future<void> clearSession() => _storage.delete(key: _tokenKey);

  Future<List<ArticleSummary>> fetchArticles() async {
    final response = await _send('GET', '/api/articles');
    final values = response['articles'] as List<dynamic>;
    return values
        .map((item) => ArticleSummary.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<WastePoint>> fetchWastePoints() async {
    final response = await _send('GET', '/api/waste-points');
    final values = response['wastePoints'] as List<dynamic>;
    return values
        .map((item) => WastePoint.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ActivitySummary> fetchActivities({DateTime? month}) async {
    final token = await _requiredToken();
    final path = month == null
        ? '/api/me/activities'
        : '/api/me/activities?month=${month.year.toString().padLeft(4, '0')}-${month.month.toString().padLeft(2, '0')}';
    final response = await _send('GET', path, token: token);
    final activities = (response['activities'] as List<dynamic>)
        .map((item) => ActivityRecord.fromJson(item as Map<String, dynamic>))
        .toList();
    final summary =
        response['summary'] as Map<String, dynamic>? ?? const {};
    return ActivitySummary(
      activities: activities,
      totalPoints: summary['totalPoints'] as int? ?? 0,
      totalActivities: summary['totalActivities'] as int? ?? activities.length,
      sortedCount: summary['sortedCount'] as int? ?? 0,
      depositedCount: summary['depositedCount'] as int? ?? 0,
    );
  }

  Future<ActivityRecord> recordClassification({
    required String wasteType,
    required double confidence,
  }) async {
    final token = await _requiredToken();
    final response = await _send(
      'POST',
      '/api/me/activities',
      token: token,
      body: {'wasteType': wasteType, 'confidence': confidence},
    );
    return ActivityRecord.fromJson(
      response['activity'] as Map<String, dynamic>,
    );
  }

  Future<AppUser> _saveSession(Map<String, dynamic> response) async {
    final token = response['token'];
    if (token is! String || token.isEmpty) {
      throw const ApiException('Server tidak mengembalikan token sesi.');
    }
    await _storage.write(key: _tokenKey, value: token);
    return AppUser.fromJson(response['user'] as Map<String, dynamic>);
  }

  Future<String> _requiredToken() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null) {
      throw const ApiException('Silakan masuk untuk menggunakan fitur ini.');
    }
    return token;
  }

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    String? token,
    Map<String, Object?>? body,
  }) async {
    final uri = Uri.parse('$_apiBaseUrl$path');
    final headers = <String, String>{
      'accept': 'application/json',
      if (body != null) 'content-type': 'application/json',
      if (token != null) 'authorization': 'Bearer $token',
    };

    try {
      final response = switch (method) {
        'GET' => await _client.get(uri, headers: headers),
        'POST' => await _client.post(
          uri,
          headers: headers,
          body: jsonEncode(body),
        ),
        _ => throw ArgumentError.value(method, 'method'),
      };
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw ApiException(
          'Respons server tidak sesuai format.',
          statusCode: response.statusCode,
        );
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = decoded['message'];
        throw ApiException(
          message is String ? message : 'Permintaan ke server gagal.',
          statusCode: response.statusCode,
        );
      }
      return decoded;
    } on http.ClientException {
      throw const ApiException(
        'Tidak dapat terhubung ke server Pilara. Pastikan backend sedang berjalan.',
      );
    } on FormatException {
      throw const ApiException('Server mengirim respons yang tidak valid.');
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

class ArticleSummary {
  const ArticleSummary({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.readTime,
    required this.author,
    required this.updatedDate,
    required this.headerImage,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final String readTime;
  final String author;
  final String updatedDate;
  final String headerImage;

  factory ArticleSummary.fromJson(Map<String, dynamic> json) =>
      ArticleSummary(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
        readTime: json['readTime'] as String,
        author: json['author'] as String,
        updatedDate: json['updatedDate'] as String,
        headerImage: json['headerImage'] as String,
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

  final int id;
  final String title;
  final String subtitle;
  final String category;
  final String wasteType;
  final int points;
  final double? confidence;
  final DateTime occurredAt;

  factory ActivityRecord.fromJson(Map<String, dynamic> json) => ActivityRecord(
    id: json['id'] as int,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    category: json['category'] as String,
    wasteType: json['wasteType'] as String,
    points: json['points'] as int,
    confidence: (json['confidence'] as num?)?.toDouble(),
    occurredAt: DateTime.parse(json['occurredAt'] as String),
  );
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
