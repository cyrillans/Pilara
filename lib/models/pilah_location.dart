import 'dart:math' as math;

enum PilahCategory {
  organik('Organik', 0xFF2E9E5B),
  anorganik('Anorganik', 0xFF2F6FED),
  b3('B3', 0xFFE04F5F),
  residu('Residu', 0xFF8A948D);

  const PilahCategory(this.label, this.colorValue);

  final String label;
  final int colorValue;
}

class PilahLocation {
  const PilahLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.openHour = '08.00',
    this.closeHour = '17.00',
    this.closedDays = const [],
    this.phone,
    this.accepts = const [],
  });

  final String id;
  final String name;
  final String description;
  final PilahCategory category;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final double rating;
  final String openHour;
  final String closeHour;
  final List<int> closedDays;
  final String? phone;
  final List<String> accepts;

  factory PilahLocation.fromJson(Map<String, dynamic> json) {
    final label = _string(json['category'], 'category').toLowerCase();
    final category = switch (label) {
      'organik' => PilahCategory.organik,
      'anorganik' => PilahCategory.anorganik,
      'b3' => PilahCategory.b3,
      'residu' || 'lainnya' => PilahCategory.residu,
      _ => throw FormatException('Kategori titik pilah tidak dikenal: $label'),
    };
    final openingHours = (json['openTime'] as String?)?.split(' - ');
    final accepts = json['accepts'] ?? json['acceptedWaste'];
    return PilahLocation(
      id: _string(json['id'], 'id'),
      name: _string(json['name'], 'name'),
      description: _string(json['description'], 'description'),
      category: category,
      address: _string(json['address'], 'address'),
      city: json['city'] is String ? json['city'] as String : '',
      latitude: _number(json['latitude'], 'latitude'),
      longitude: _number(json['longitude'], 'longitude'),
      rating: _number(json['rating'], 'rating'),
      openHour: json['openHour'] is String
          ? json['openHour'] as String
          : openingHours?.first ?? '08.00',
      closeHour: json['closeHour'] is String
          ? json['closeHour'] as String
          : openingHours != null && openingHours.length > 1
              ? openingHours[1]
              : '17.00',
      closedDays: _integerList(json['closedDays'], 'closedDays'),
      phone: json['phone'] is String ? json['phone'] as String : null,
      accepts: _stringList(accepts, 'accepts'),
    );
  }

  double distanceKmFrom(double lat, double lng) {
    const earthRadiusKm = 6371.0;
    final dLat = _rad(lat - latitude);
    final dLng = _rad(lng - longitude);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(latitude)) *
            math.cos(_rad(lat)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return earthRadiusKm * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  bool isOpenAt(DateTime now) {
    if (closedDays.contains(now.weekday)) return false;
    final minutesNow = now.hour * 60 + now.minute;
    return minutesNow >= _minutes(openHour) && minutesNow < _minutes(closeHour);
  }

  String statusLabel(DateTime now) =>
      isOpenAt(now) ? 'Buka · tutup $closeHour' : 'Tutup';

  static double _rad(double deg) => deg * math.pi / 180;

  static int _minutes(String hhmm) {
    final parts = hhmm.split('.');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}

String formatDistance(double km) {
  if (km < 1) return '${(km * 1000).round()} m';
  final text = km < 100 ? km.toStringAsFixed(1) : km.round().toString();
  return '${text.replaceAll('.', ',')} km';
}

List<PilahLocation> searchPilah({
  required List<PilahLocation> locations,
  String query = '',
  PilahCategory? category,
  double? userLat,
  double? userLng,
}) {
  final q = query.trim().toLowerCase();
  final results = locations.where((point) {
    if (category != null && point.category != category) return false;
    if (q.isEmpty) return true;
    final haystack = [
      point.name,
      point.description,
      point.address,
      point.city,
      point.category.label,
      ...point.accepts,
    ].join(' ').toLowerCase();
    return haystack.contains(q);
  }).toList();

  if (userLat != null && userLng != null) {
    results.sort(
      (a, b) => a
          .distanceKmFrom(userLat, userLng)
          .compareTo(b.distanceKmFrom(userLat, userLng)),
    );
  }
  return results;
}

String _string(Object? value, String field) {
  if (value is String) return value;
  throw FormatException('Field "$field" harus berupa teks.');
}

double _number(Object? value, String field) {
  if (value is num) return value.toDouble();
  throw FormatException('Field "$field" harus berupa angka.');
}

List<int> _integerList(Object? value, String field) {
  if (value == null) return const [];
  if (value is List && value.every((item) => item is num)) {
    return value.cast<num>().map((item) => item.toInt()).toList();
  }
  throw FormatException('Field "$field" harus berupa daftar angka.');
}

List<String> _stringList(Object? value, String field) {
  if (value == null) return const [];
  if (value is List && value.every((item) => item is String)) {
    return value.cast<String>();
  }
  throw FormatException('Field "$field" harus berupa daftar teks.');
}
