import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/pilah_location.dart';

abstract interface class TokenStore {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> delete();
}

class _SecureTokenStore implements TokenStore {
  const _SecureTokenStore();

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'pilara_token';

  @override
  Future<String?> read() => _storage.read(key: _tokenKey);

  @override
  Future<void> write(String token) =>
      _storage.write(key: _tokenKey, value: token);

  @override
  Future<void> delete() => _storage.delete(key: _tokenKey);
}

class PilaraApi {
  PilaraApi({
    http.Client? client,
    TokenStore? tokenStore,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _tokenStore = tokenStore ?? const _SecureTokenStore(),
        _baseUrl = (baseUrl ??
                const String.fromEnvironment(
                  'PILARA_API_URL',
                  defaultValue: 'http://127.0.0.1:8080',
                ))
            .replaceFirst(RegExp(r'/$'), '');

  static final instance = PilaraApi();

  final http.Client _client;
  final TokenStore _tokenStore;
  final String _baseUrl;

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _request(
      'POST',
      '/api/auth/register',
      body: {'name': name, 'email': email, 'password': password},
      authenticated: false,
    );
    return _saveAuthResponse(response);
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _request(
      'POST',
      '/api/auth/login',
      body: {'email': email, 'password': password},
      authenticated: false,
    );
    return _saveAuthResponse(response);
  }

  Future<AppUser> loginWithGoogle({required String firebaseIdToken}) async {
    final response = await _request(
      'POST',
      '/api/auth/google',
      body: {'idToken': firebaseIdToken},
      authenticated: false,
    );
    return _saveAuthResponse(response);
  }

  Future<AppUser?> restoreSession() async {
    if (await _tokenStore.read() == null) return null;
    final response = await _request('GET', '/api/auth/me');
    return AppUser.fromJson(_object(response['user'], 'user'));
  }

  Future<AppUser> currentUser() async {
    final response = await _request('GET', '/api/auth/me');
    return AppUser.fromJson(_object(response['user'], 'user'));
  }

  Future<AppUser> updateProfile({
    required String name,
    required String bio,
  }) async {
    final response = await _request(
      'PATCH',
      '/api/auth/me',
      body: {'name': name, 'bio': bio},
    );
    return AppUser.fromJson(_object(response['user'], 'user'));
  }

  Future<void> logout() => _tokenStore.delete();

  Future<List<PilahLocation>> wastePoints() async {
    final response = await _request(
      'GET',
      '/api/waste-points',
      authenticated: false,
    );
    final records = _list(response['wastePoints'], 'wastePoints');
    return records
        .map((item) => PilahLocation.fromJson(_object(item, 'wastePoint')))
        .toList();
  }

  Future<List<ArticleMetadata>> articles() async {
    final response = await _request(
      'GET',
      '/api/articles',
      authenticated: false,
    );
    final records = _list(response['articles'], 'articles');
    return records
        .map((item) => ArticleMetadata.fromJson(_object(item, 'article')))
        .toList();
  }

  Future<ActivitySummary> activities({DateTime? month}) async {
    final parameters = <String, String>{};
    if (month != null) {
      parameters['month'] = '${month.year.toString().padLeft(4, '0')}-'
          '${month.month.toString().padLeft(2, '0')}';
      parameters['timezoneOffsetMinutes'] =
          DateTime.now().timeZoneOffset.inMinutes.toString();
    }
    final path = Uri(
      path: '/api/me/activities',
      queryParameters: parameters.isEmpty ? null : parameters,
    ).toString();
    final response = await _request('GET', path);
    final records = _list(response['activities'], 'activities');
    final summary = _object(response['summary'], 'summary');
    return ActivitySummary(
      activities: records
          .map((item) => ActivityRecord.fromJson(_object(item, 'activity')))
          .toList(),
      totalPoints: _integer(summary['totalPoints'], 'totalPoints'),
      totalActivities: _integer(summary['totalActivities'], 'totalActivities'),
      sortedCount: _integer(summary['sortedCount'], 'sortedCount'),
      depositedCount: _integer(summary['depositedCount'], 'depositedCount'),
    );
  }

  Future<void> recordClassification({
    required String wasteType,
    double? confidence,
  }) async {
    await _request(
      'POST',
      '/api/me/activities',
      body: {
        'wasteType': wasteType,
        if (confidence != null) 'confidence': confidence,
      },
    );
  }

  Future<List<TutorialProgress>> tutorialProgress() async {
    final response = await _request('GET', '/api/me/tutorial-progress');
    final records = _list(response['tutorialProgress'], 'tutorialProgress');
    return records
        .map(
          (item) =>
              TutorialProgress.fromJson(_object(item, 'tutorialProgress')),
        )
        .toList();
  }

  Future<TutorialProgress> saveTutorialProgress({
    required String tutorialId,
    required int completedSteps,
  }) async {
    final response = await _request(
      'PUT',
      '/api/me/tutorial-progress/${Uri.encodeComponent(tutorialId)}',
      body: {'completedSteps': completedSteps},
    );
    return TutorialProgress.fromJson(_object(response['progress'], 'progress'));
  }

  Future<void> resetTutorialProgress(String tutorialId) async {
    await _request(
      'DELETE',
      '/api/me/tutorial-progress/${Uri.encodeComponent(tutorialId)}',
    );
  }

  Future<List<CommunityEvent>> events() async {
    final response = await _request('GET', '/api/me/events');
    final records = _list(response['events'], 'events');
    return records
        .map((item) => CommunityEvent.fromJson(_object(item, 'event')))
        .toList();
  }

  Future<CommunityEvent> joinEvent(String eventId) async {
    final response = await _request(
      'POST',
      '/api/me/events/${Uri.encodeComponent(eventId)}/registration',
    );
    return CommunityEvent.fromJson(_object(response['event'], 'event'));
  }

  Future<CommunityEvent> leaveEvent(String eventId) async {
    final response = await _request(
      'DELETE',
      '/api/me/events/${Uri.encodeComponent(eventId)}/registration',
    );
    return CommunityEvent.fromJson(_object(response['event'], 'event'));
  }

  Future<AppUser> _saveAuthResponse(Map<String, dynamic> response) async {
    final token = response['token'];
    if (token is! String || token.isEmpty) {
      throw const FormatException(
          'Respons autentikasi tidak menyertakan token.');
    }
    await _tokenStore.write(token);
    return AppUser.fromJson(_object(response['user'], 'user'));
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, Object?>? body,
    bool authenticated = true,
  }) async {
    final headers = <String, String>{'content-type': 'application/json'};
    if (authenticated) {
      final token = await _tokenStore.read();
      if (token == null || token.isEmpty) {
        throw const ApiException(401, 'Silakan masuk untuk melanjutkan.');
      }
      headers['authorization'] = 'Bearer $token';
    }

    final uri = Uri.parse('$_baseUrl$path');
    final encodedBody = body == null ? null : jsonEncode(body);
    final response = switch (method) {
      'GET' => await _client.get(uri, headers: headers),
      'POST' => await _client.post(uri, headers: headers, body: encodedBody),
      'PUT' => await _client.put(uri, headers: headers, body: encodedBody),
      'PATCH' => await _client.patch(uri, headers: headers, body: encodedBody),
      'DELETE' =>
        await _client.delete(uri, headers: headers, body: encodedBody),
      _ =>
        throw ArgumentError.value(method, 'method', 'Unsupported HTTP method'),
    };

    final decoded =
        response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Respons API harus berupa objek JSON.');
    }
    if (response.statusCode == 401 && authenticated) {
      await _tokenStore.delete();
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = decoded['error'];
      final message =
          error is Map<String, dynamic> && error['message'] is String
              ? error['message'] as String
              : 'Permintaan gagal (${response.statusCode}).';
      throw ApiException(response.statusCode, message);
    }
    return decoded;
  }
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.bio = '',
  });

  final int id;
  final String name;
  final String email;
  final String bio;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: _integer(json['id'], 'id'),
        name: _string(json['name'], 'name'),
        email: _string(json['email'], 'email'),
        bio: json['bio'] is String ? json['bio'] as String : '',
      );
}

class ArticleMetadata {
  const ArticleMetadata({
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

  factory ArticleMetadata.fromJson(Map<String, dynamic> json) =>
      ArticleMetadata(
        id: _integer(json['id'], 'id'),
        title: _string(json['title'], 'title'),
        description: _string(json['description'], 'description'),
        category: _string(json['category'], 'category'),
        readTime: _string(json['readTime'], 'readTime'),
        author: _string(json['author'], 'author'),
        updatedDate: _string(json['updatedDate'], 'updatedDate'),
        headerImage: _string(json['headerImage'], 'headerImage'),
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

class ActivityRecord {
  const ActivityRecord({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.wasteType,
    required this.points,
    required this.occurredAt,
  });

  final int id;
  final String title;
  final String subtitle;
  final String category;
  final String wasteType;
  final int points;
  final DateTime occurredAt;

  factory ActivityRecord.fromJson(Map<String, dynamic> json) => ActivityRecord(
        id: _integer(json['id'], 'id'),
        title: _string(json['title'], 'title'),
        subtitle: _string(json['subtitle'], 'subtitle'),
        category: _string(json['category'], 'category'),
        wasteType: _string(json['wasteType'], 'wasteType'),
        points: _integer(json['points'], 'points'),
        occurredAt:
            DateTime.parse(_string(json['occurredAt'], 'occurredAt')).toLocal(),
      );
}

class TutorialProgress {
  const TutorialProgress({
    required this.tutorialId,
    required this.completedSteps,
    required this.updatedAt,
  });

  final String tutorialId;
  final int completedSteps;
  final DateTime updatedAt;

  factory TutorialProgress.fromJson(Map<String, dynamic> json) =>
      TutorialProgress(
        tutorialId: _string(json['tutorialId'], 'tutorialId'),
        completedSteps: _integer(json['completedSteps'], 'completedSteps'),
        updatedAt:
            DateTime.parse(_string(json['updatedAt'], 'updatedAt')).toLocal(),
      );
}

class CommunityEvent {
  const CommunityEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.startsAt,
    required this.participantCount,
    required this.capacity,
    required this.isJoined,
    required this.registrationOpen,
    this.coverImage,
  });

  final String id;
  final String title;
  final String description;
  final String location;
  final String type;
  final DateTime startsAt;
  final int participantCount;
  final int? capacity;
  final bool isJoined;
  final bool registrationOpen;
  final String? coverImage;

  factory CommunityEvent.fromJson(Map<String, dynamic> json) => CommunityEvent(
        id: _string(json['id'], 'id'),
        title: _string(json['title'], 'title'),
        description: _string(json['description'], 'description'),
        location: _string(json['location'], 'location'),
        type: _string(json['type'], 'type'),
        startsAt:
            DateTime.parse(_string(json['startsAt'], 'startsAt')).toLocal(),
        participantCount: _integer(json['participantCount'], 'participantCount'),
        capacity: json['capacity'] == null
            ? null
            : _integer(json['capacity'], 'capacity'),
        isJoined: json['isJoined'] is bool
            ? json['isJoined'] as bool
            : throw const FormatException('Field "isJoined" harus berupa bool.'),
        registrationOpen: json['registrationOpen'] is bool
            ? json['registrationOpen'] as bool
            : throw const FormatException(
                'Field "registrationOpen" harus berupa bool.',
              ),
        coverImage: json['coverImage'] == null
            ? null
            : _string(json['coverImage'], 'coverImage'),
      );
}

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => message;
}

Map<String, dynamic> _object(Object? value, String field) {
  if (value is Map<String, dynamic>) return value;
  throw FormatException('Field "$field" harus berupa objek.');
}

List<Object?> _list(Object? value, String field) {
  if (value is List<Object?>) return value;
  throw FormatException('Field "$field" harus berupa daftar.');
}

String _string(Object? value, String field) {
  if (value is String) return value;
  throw FormatException('Field "$field" harus berupa teks.');
}

int _integer(Object? value, String field) {
  if (value is num) return value.toInt();
  throw FormatException('Field "$field" harus berupa angka.');
}
