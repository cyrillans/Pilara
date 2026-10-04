import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/dummy_pilah.dart';

class PilahScreen extends StatefulWidget {
  const PilahScreen({super.key});

  @override
  State<PilahScreen> createState() => _PilahScreenState();
}

class _PilahScreenState extends State<PilahScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController =
      TextEditingController();

  // Default awal sebelum GPS berhasil didapatkan.
  // Akan otomatis berpindah ke lokasi HP setelah GPS aktif.
  static const LatLng _defaultLocation =
      LatLng(0.5071, 101.4478);

  LatLng _currentLocation = _defaultLocation;

  bool _isLoadingLocation = true;
  bool _locationReady = false;

  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  final List<String> _categories = [
    'Semua',
    'Organik',
    'Anorganik',
    'B3',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery =
            _searchController.text.trim().toLowerCase();
      });
    });

    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOCATION
  // ============================================================

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          _isLoadingLocation = false;
          _locationReady = false;
        });

        _showLocationMessage(
          'GPS belum aktif. Silakan aktifkan lokasi pada HP.',
          actionLabel: 'Buka',
          onAction: () async {
            await Geolocator.openLocationSettings();
          },
        );

        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        setState(() {
          _isLoadingLocation = false;
          _locationReady = false;
        });

        _showLocationMessage(
          'Izin lokasi diperlukan untuk mencari titik terdekat.',
        );

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          _isLoadingLocation = false;
          _locationReady = false;
        });

        _showLocationMessage(
          'Izin lokasi ditolak permanen. Aktifkan dari Pengaturan.',
          actionLabel: 'Pengaturan',
          onAction: () async {
            await Geolocator.openAppSettings();
          },
        );

        return;
      }

      final position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final newLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _currentLocation = newLocation;
        _locationReady = true;
        _isLoadingLocation = false;
      });

      _mapController.move(
        newLocation,
        14.5,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingLocation = false;
        _locationReady = false;
      });

      _showLocationMessage(
        'Lokasi belum berhasil didapatkan. Coba lagi.',
      );
    }
  }

  Future<void> _centerToCurrentLocation() async {
    if (_isLoadingLocation) return;

    if (!_locationReady) {
      await _getCurrentLocation();
      return;
    }

    _mapController.move(
      _currentLocation,
      15,
    );
  }

  // ============================================================
  // FILTER
  // ============================================================

  List<WastePointDummy> get _filteredPlaces {
    List<WastePointDummy> result =
        List.from(dummyWastePoints);

    if (_selectedCategory != 'Semua') {
      result = result.where((place) {
        return place.acceptedWaste
            .contains(_selectedCategory);
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result.where((place) {
        final name = place.name.toLowerCase();
        final address = place.address.toLowerCase();
        final waste =
            place.acceptedWaste.join(' ').toLowerCase();

        return name.contains(_searchQuery) ||
            address.contains(_searchQuery) ||
            waste.contains(_searchQuery);
      }).toList();
    }

    if (_locationReady) {
      result.sort((a, b) {
        final distanceA =
            Geolocator.distanceBetween(
          _currentLocation.latitude,
          _currentLocation.longitude,
          a.latitude,
          a.longitude,
        );

        final distanceB =
            Geolocator.distanceBetween(
          _currentLocation.latitude,
          _currentLocation.longitude,
          b.latitude,
          b.longitude,
        );

        return distanceA.compareTo(distanceB);
      });
    }

    return result;
  }

  // ============================================================
  // DISTANCE
  // ============================================================

  String _getDistance(WastePointDummy place) {
    if (!_locationReady) {
      return 'Lokasi belum tersedia';
    }

    final distance =
        Geolocator.distanceBetween(
      _currentLocation.latitude,
      _currentLocation.longitude,
      place.latitude,
      place.longitude,
    );

    if (distance < 1000) {
      return '${distance.round()} m';
    }

    return '${(distance / 1000).toStringAsFixed(1)} km';
  }

  // ============================================================
  // OPEN MAP / ROUTE
  // ============================================================

  Future<void> _openRoute(
    WastePointDummy place,
  ) async {
    final destination =
        '${place.latitude},${place.longitude}';

    final Uri uri;

    if (_locationReady) {
      uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&origin=${_currentLocation.latitude},${_currentLocation.longitude}'
        '&destination=$destination'
        '&travelmode=driving',
      );
    } else {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1'
        '&query=$destination',
      );
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showLocationMessage(
          'Tidak dapat membuka aplikasi Maps.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      _showLocationMessage(
        'Terjadi masalah saat membuka Maps.',
      );
    }
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final places = _filteredPlaces;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            SliverToBoxAdapter(
              child: _buildSearch(),
            ),
            SliverToBoxAdapter(
              child: _buildCategoryFilter(),
            ),
            SliverToBoxAdapter(
              child: _buildMap(places),
            ),
            SliverToBoxAdapter(
              child: _buildNearbyHeader(
                places.length,
              ),
            ),
            if (places.isEmpty)
              SliverToBoxAdapter(
                child: _buildEmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  28,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final place = places[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 14,
                        ),
                        child: _buildPlaceCard(place),
                      );
                    },
                    childCount: places.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFE7F5EA),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.eco_rounded,
                            size: 14,
                            color: Color(0xFF2E7D32),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Pilah lebih baik',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.w700,
                              color:
                                  Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Pilah Sampah',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF17231A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Temukan lokasi pengelolaan sampah di sekitar kamu.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _getCurrentLocation,
              icon: _isLoadingLocation
                  ? const SizedBox(
                      width: 19,
                      height: 19,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.my_location_rounded,
                      size: 20,
                    ),
              color: const Color(0xFF2E7D32),
              tooltip: 'Gunakan lokasi saya',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        14,
      ),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFFE7ECE8),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.035),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          textInputAction:
              TextInputAction.search,
          decoration: InputDecoration(
            hintText:
                'Cari lokasi atau jenis sampah...',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF5B6B5D),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          8,
        ),
        scrollDirection: Axis.horizontal,
        physics:
            const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final category =
              _categories[index];
          final selected =
              _selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 200,
              ),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF2E7D32)
                    : Colors.white,
                borderRadius:
                    BorderRadius.circular(24),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFE1E7E2),
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                    color: selected
                        ? Colors.white
                        : const Color(0xFF536056),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMap(
    List<WastePointDummy> places,
  ) {
    final markers = <Marker>[];

    // Marker lokasi pengguna.
    if (_locationReady) {
      markers.add(
        Marker(
          point: _currentLocation,
          width: 48,
          height: 48,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2E7D32)
                  .withOpacity(0.16),
            ),
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color(0xFF2E7D32)
                              .withOpacity(0.35),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Marker lokasi pengelolaan.
    for (final place in places) {
      markers.add(
        Marker(
          point: LatLng(
            place.latitude,
            place.longitude,
          ),
          width: 44,
          height: 52,
          child: GestureDetector(
            onTap: () {
              _showPlaceDetail(place);
            },
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration:
                      BoxDecoration(
                    color:
                        const Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.2),
                        blurRadius: 8,
                        offset:
                            const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    place.icon,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
                Container(
                  width: 0,
                  height: 0,
                  decoration:
                      const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color:
                            Colors.transparent,
                        width: 5,
                      ),
                      right: BorderSide(
                        color:
                            Colors.transparent,
                        width: 5,
                      ),
                      top: BorderSide(
                        color:
                            Color(0xFF2E7D32),
                        width: 7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        22,
      ),
      child: Container(
        height: 290,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFE4E9E5),
          borderRadius:
              BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter:
                    _currentLocation,
                initialZoom: 13.5,
                minZoom: 4,
                maxZoom: 19,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.example.pilara',
                ),
                MarkerLayer(
                  markers: markers,
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                    ),
                  ],
                ),
              ],
            ),

            // Label data demo.
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.94),
                  borderRadius:
                      BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.08),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.layers_rounded,
                      size: 14,
                      color:
                          Color(0xFF2E7D32),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Titik pengelolaan',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            Color(0xFF344238),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading GPS.
            if (_isLoadingLocation)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.94),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 13,
                        height: 13,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Mencari lokasi...',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Tombol center location.
            Positioned(
              right: 12,
              bottom: 12,
              child: Material(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(14),
                elevation: 3,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(14),
                  onTap:
                      _centerToCurrentLocation,
                  child: const SizedBox(
                    width: 46,
                    height: 46,
                    child: Icon(
                      Icons.my_location_rounded,
                      color:
                          Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        13,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Lokasi terdekat',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        Color(0xFF17231A),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Pilih lokasi sesuai jenis sampahmu.',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        Color(0xFF758078),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFEAF5EC),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Text(
              '$count lokasi',
              style: const TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w700,
                color:
                    Color(0xFF2E7D32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(
    WastePointDummy place,
  ) {
    return GestureDetector(
      onTap: () {
        _showPlaceDetail(place);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color:
                const Color(0xFFE8EDE9),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.035),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color:
                    const Color(0xFFEAF5EC),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Icon(
                place.icon,
                color:
                    const Color(0xFF2E7D32),
                size: 25,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.name,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w800,
                            color:
                                Color(0xFF1B261D),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons
                            .chevron_right_rounded,
                        size: 20,
                        color:
                            Color(0xFF9AA39C),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    place.address,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color:
                          Color(0xFF7B857D),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      _smallTag(
                        Icons.near_me_rounded,
                        _getDistance(place),
                      ),
                      _smallTag(
                        Icons.star_rounded,
                        place.rating
                            .toStringAsFixed(1),
                      ),
                      ...place.acceptedWaste
                          .map(
                        (waste) =>
                            _wasteTag(waste),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallTag(
    IconData icon,
    String text,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color:
            const Color(0xFFF4F6F4),
        borderRadius:
            BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color:
                const Color(0xFF647066),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight:
                  FontWeight.w700,
              color:
                  Color(0xFF647066),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wasteTag(String waste) {
    Color background;
    Color foreground;

    switch (waste) {
      case 'Organik':
        background =
            const Color(0xFFE8F5E9);
        foreground =
            const Color(0xFF2E7D32);
        break;

      case 'Anorganik':
        background =
            const Color(0xFFE8F0FE);
        foreground =
            const Color(0xFF315FA8);
        break;

      case 'B3':
        background =
            const Color(0xFFFFF2DD);
        foreground =
            const Color(0xFFAA6A00);
        break;

      default:
        background =
            const Color(0xFFF0ECF8);
        foreground =
            const Color(0xFF7156A3);
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(8),
      ),
      child: Text(
        waste,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight:
              FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        30,
      ),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(22),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Color(0xFF9BA49D),
            ),
            SizedBox(height: 12),
            Text(
              'Lokasi tidak ditemukan',
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w800,
                color:
                    Color(0xFF263128),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Coba gunakan kata kunci atau kategori lainnya.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color:
                    Color(0xFF7B857D),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DETAIL BOTTOM SHEET
  // ============================================================

  void _showPlaceDetail(
    WastePointDummy place,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent,
      builder: (context) {
        return Container(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            25,
          ),
          decoration:
              const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration:
                        BoxDecoration(
                      color: const Color(
                          0xFFD7DDD8),
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration:
                          BoxDecoration(
                        color: const Color(
                            0xFFEAF5EC),
                        borderRadius:
                            BorderRadius.circular(
                          17,
                        ),
                      ),
                      child: Icon(
                        place.icon,
                        color: const Color(
                            0xFF2E7D32),
                        size: 29,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style:
                                const TextStyle(
                              fontSize: 19,
                              fontWeight:
                                  FontWeight.w800,
                              color: Color(
                                  0xFF17231A),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            place.address,
                            style:
                                const TextStyle(
                              fontSize: 12,
                              color: Color(
                                  0xFF788279),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _detailInfo(
                        Icons.near_me_rounded,
                        'Jarak',
                        _getDistance(place),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _detailInfo(
                        Icons.star_rounded,
                        'Rating',
                        place.rating
                            .toStringAsFixed(1),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _detailInfo(
                        Icons.access_time_rounded,
                        'Jam',
                        place.openTime,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                const Text(
                  'Menerima sampah',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        Color(0xFF273228),
                  ),
                ),

                const SizedBox(height: 9),

                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: place
                      .acceptedWaste
                      .map(
                        (waste) =>
                            _largeWasteTag(waste),
                      )
                      .toList(),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Tentang lokasi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        Color(0xFF273228),
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  place.description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color:
                        Color(0xFF737D75),
                  ),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 53,
                  child:
                      ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _openRoute(place);
                    },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                              0xFF2E7D32),
                      foregroundColor:
                          Colors.white,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.directions_rounded,
                      size: 21,
                    ),
                    label: const Text(
                      'Buka Rute',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 9),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child:
                      OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      _mapController.move(
                        LatLng(
                          place.latitude,
                          place.longitude,
                        ),
                        16,
                      );
                    },
                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(
                              0xFF2E7D32),
                      side:
                          const BorderSide(
                        color: Color(
                            0xFFB9D2BC),
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Lihat di Peta',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color:
            const Color(0xFFF5F7F5),
        borderRadius:
            BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 18,
            color:
                const Color(0xFF2E7D32),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              color:
                  Color(0xFF89928B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight:
                  FontWeight.w800,
              color:
                  Color(0xFF354037),
            ),
          ),
        ],
      ),
    );
  }

  Widget _largeWasteTag(
    String waste,
  ) {
    Color background;
    Color foreground;

    switch (waste) {
      case 'Organik':
        background =
            const Color(0xFFE8F5E9);
        foreground =
            const Color(0xFF2E7D32);
        break;

      case 'Anorganik':
        background =
            const Color(0xFFE8F0FE);
        foreground =
            const Color(0xFF315FA8);
        break;

      case 'B3':
        background =
            const Color(0xFFFFF2DD);
        foreground =
            const Color(0xFFAA6A00);
        break;

      default:
        background =
            const Color(0xFFF0ECF8);
        foreground =
            const Color(0xFF7156A3);
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Text(
        waste,
        style: TextStyle(
          fontSize: 11,
          fontWeight:
              FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showLocationMessage(
    String message, {
    String? actionLabel,
    Future<void> Function()? onAction,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.w600,
          ),
        ),
        behavior:
            SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                onPressed: () {
                  if (onAction != null) {
                    unawaited(onAction());
                  }
                },
              )
            : null,
      ),
    );
  }
}