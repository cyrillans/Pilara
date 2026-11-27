import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pilara/models/pilah_location.dart';
import 'package:pilara/services/pilara_api.dart';

class _MemoryTokenStore implements TokenStore {
  String? token;

  @override
  Future<String?> read() async => token;

  @override
  Future<void> write(String value) async => token = value;

  @override
  Future<void> delete() async => token = null;
}

void main() {
  test('Google login exchanges Firebase ID token for a Pilara session',
      () async {
    final tokenStore = _MemoryTokenStore();
    late http.Request capturedRequest;
    final api = PilaraApi(
      baseUrl: 'http://localhost:8080',
      tokenStore: tokenStore,
      client: MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          jsonEncode({
            'token': 'pilara-session-token',
            'user': {
              'id': 42,
              'name': 'Google User',
              'email': 'google@example.com',
              'bio': '',
            },
          }),
          200,
        );
      }),
    );

    final user = await api.loginWithGoogle(
      firebaseIdToken: 'firebase-id-token',
    );

    expect(capturedRequest.method, 'POST');
    expect(capturedRequest.url.path, '/api/auth/google');
    expect(capturedRequest.headers.containsKey('authorization'), isFalse);
    expect(jsonDecode(capturedRequest.body), {'idToken': 'firebase-id-token'});
    expect(tokenStore.token, 'pilara-session-token');
    expect(user.email, 'google@example.com');
  });

  test('classification is sent to the authenticated activity endpoint',
      () async {
    final tokenStore = _MemoryTokenStore()..token = 'session-token';
    late http.Request capturedRequest;
    final api = PilaraApi(
      baseUrl: 'http://localhost:8080',
      tokenStore: tokenStore,
      client: MockClient((request) async {
        capturedRequest = request;
        return http.Response('{}', 201);
      }),
    );

    await api.recordClassification(wasteType: 'Organik');

    expect(capturedRequest.url.path, '/api/me/activities');
    expect(capturedRequest.headers['authorization'], 'Bearer session-token');
    expect(jsonDecode(capturedRequest.body), {'wasteType': 'Organik'});
  });

  test('tutorial progress is read, saved, and reset through authenticated API',
      () async {
    final tokenStore = _MemoryTokenStore()..token = 'session-token';
    final requests = <http.Request>[];
    final api = PilaraApi(
      baseUrl: 'http://localhost:8080',
      tokenStore: tokenStore,
      client: MockClient((request) async {
        requests.add(request);
        if (request.method == 'GET') {
          return http.Response(
            jsonEncode({
              'tutorialProgress': [
                {
                  'tutorialId': 't1',
                  'completedSteps': 2,
                  'updatedAt': '2026-11-27T10:00:00.000Z',
                },
              ],
            }),
            200,
          );
        }
        if (request.method == 'PUT') {
          return http.Response(
            jsonEncode({
              'progress': {
                'tutorialId': 't1',
                'completedSteps': 3,
                'updatedAt': '2026-11-27T10:01:00.000Z',
              },
            }),
            200,
          );
        }
        return http.Response('', 204);
      }),
    );

    final progress = await api.tutorialProgress();
    expect(progress.single.completedSteps, 2);
    final saved = await api.saveTutorialProgress(
      tutorialId: 't1',
      completedSteps: 3,
    );
    await api.resetTutorialProgress('t1');

    expect(saved.completedSteps, 3);
    expect(requests.map((request) => request.method), ['GET', 'PUT', 'DELETE']);
    expect(
      requests.map((request) => request.url.path),
      [
        '/api/me/tutorial-progress',
        '/api/me/tutorial-progress/t1',
        '/api/me/tutorial-progress/t1',
      ],
    );
    expect(
      requests.every(
        (request) => request.headers['authorization'] == 'Bearer session-token',
      ),
      isTrue,
    );
    expect(jsonDecode(requests[1].body), {'completedSteps': 3});
  });

  test('community events load, join, and leave through authenticated API',
      () async {
    final tokenStore = _MemoryTokenStore()..token = 'session-token';
    final requests = <http.Request>[];
    final event = {
      'id': 'cleanup-1',
      'title': 'Aksi Bersih',
      'description': 'Bersih-bersih lingkungan.',
      'location': 'Pekanbaru',
      'type': 'cleanup',
      'startsAt': '2026-12-01T10:00:00.000Z',
      'participantCount': 3,
      'capacity': 20,
      'isJoined': true,
      'registrationOpen': true,
      'coverImage': null,
    };
    final api = PilaraApi(
      baseUrl: 'http://localhost:8080',
      tokenStore: tokenStore,
      client: MockClient((request) async {
        requests.add(request);
        if (request.method == 'GET') {
          return http.Response(
              jsonEncode({
                'events': [event]
              }),
              200);
        }
        return http.Response(jsonEncode({'event': event}), 200);
      }),
    );

    final events = await api.events();
    final joined = await api.joinEvent('cleanup-1');
    final left = await api.leaveEvent('cleanup-1');

    expect(events.single.participantCount, 3);
    expect(joined.isJoined, isTrue);
    expect(left.capacity, 20);
    expect(
      requests.map((request) => '${request.method} ${request.url.path}'),
      [
        'GET /api/me/events',
        'POST /api/me/events/cleanup-1/registration',
        'DELETE /api/me/events/cleanup-1/registration',
      ],
    );
    expect(
      requests.every(
        (request) => request.headers['authorization'] == 'Bearer session-token',
      ),
      isTrue,
    );
  });

  test('monthly activity response is parsed using the requested month',
      () async {
    final tokenStore = _MemoryTokenStore()..token = 'session-token';
    final api = PilaraApi(
      baseUrl: 'http://localhost:8080',
      tokenStore: tokenStore,
      client: MockClient((request) async {
        expect(request.url.path, '/api/me/activities');
        expect(request.url.queryParameters['month'], '2026-10');
        return http.Response(
          jsonEncode({
            'activities': [
              {
                'id': 12,
                'title': 'Organik',
                'subtitle': 'Berhasil diidentifikasi',
                'category': 'Dipilah',
                'wasteType': 'Organik',
                'points': 0,
                'occurredAt': '2026-10-12T10:00:00.000Z',
              },
            ],
            'summary': {
              'totalPoints': 0,
              'totalActivities': 1,
              'sortedCount': 1,
              'depositedCount': 0,
            },
          }),
          200,
        );
      }),
    );

    final result = await api.activities(month: DateTime(2026, 10));

    expect(result.totalActivities, 1);
    expect(result.activities.single.wasteType, 'Organik');
    expect(result.activities.single.points, 0);
  });

  test('waste point metadata maps to the frontend location model', () {
    final location = PilahLocation.fromJson({
      'id': 'organic',
      'name': 'Titik Pilah Organik',
      'address': 'Jl. Contoh',
      'description': 'Menerima sampah organik.',
      'category': 'Organik',
      'city': 'Pekanbaru',
      'latitude': 0.5105,
      'longitude': 101.4515,
      'rating': 4.7,
      'openHour': '08.00',
      'closeHour': '17.00',
      'closedDays': [7],
      'accepts': ['daun', 'sisa makanan'],
      'phone': null,
    });

    expect(location.category, PilahCategory.organik);
    expect(location.city, 'Pekanbaru');
    expect(location.accepts, ['daun', 'sisa makanan']);
    expect(location.isOpenAt(DateTime(2026, 10, 12, 9)), isTrue);
  });
}
