import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/theme/app_colors.dart';
import '../models/pilah_location.dart';
import '../services/pilara_api.dart';

// ==================================================================
// TOKEN DESAIN
// ==================================================================

const Color _ink = Color(0xFF18221C);
const Color _muted = Color(0xFF75837B);
const Color _line = Color(0xFFE9EEEA);
const Color _openColor = Color(0xFF2E9E5B);

// Keep the legacy screen's default map center until GPS or API locations load.
const LatLng _fallbackCenter = LatLng(0.5071, 101.4478);

extension _CategoryUi on PilahCategory {
  Color get color => Color(colorValue);
  Color get tint => color.withValues(alpha: 0.12);

  IconData get icon {
    switch (this) {
      case PilahCategory.organik:
        return Icons.eco_rounded;
      case PilahCategory.anorganik:
        return Icons.recycling_rounded;
      case PilahCategory.b3:
        return Icons.warning_amber_rounded;
      case PilahCategory.residu:
        return Icons.delete_outline_rounded;
    }
  }
}

const List<String> _dayNames = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

String _closedDaysLabel(List<int> days) {
  if (days.isEmpty) return 'Buka setiap hari';
  final names = ([...days]..sort()).map((d) => _dayNames[d - 1]).join(', ');
  return 'Tutup $names';
}

// ==================================================================
// SCREEN
// ==================================================================

class PilahScreen extends StatefulWidget {
  const PilahScreen({super.key});

  @override
  State<PilahScreen> createState() => _PilahScreenState();
}

class _PilahScreenState extends State<PilahScreen> {
  static const double _sheetMin = 0.14;
  static const double _sheetMid = 0.40;
  static const double _sheetMax = 0.90;

  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final ValueNotifier<double> _sheetExtent = ValueNotifier<double>(_sheetMid);

  LatLng? _user;
  bool _loadingLocation = true;
  bool _loadingPlaces = true;
  String? _placesError;
  List<PilahLocation> _locations = [];

  PilahCategory? _category; // null = semua
  bool _openOnly = false;
  String _query = '';
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
      if (_query.trim().isNotEmpty) _snapSheetTo(0.62);
    });
    _sheetController.addListener(() {
      if (_sheetController.isAttached) {
        _sheetExtent.value = _sheetController.size;
      }
    });
    unawaited(_loadWastePoints());
    unawaited(_getCurrentLocation());
  }

  Future<void> _loadWastePoints() async {
    if (mounted) {
      setState(() {
        _loadingPlaces = true;
        _placesError = null;
      });
    }
    try {
      final locations = await PilaraApi.instance.wastePoints();
      if (!mounted) return;
      setState(() {
        _locations = locations;
        _loadingPlaces = false;
      });
      if (_user == null && locations.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _user != null) return;
          final first = locations.first;
          _mapController.move(
            LatLng(first.latitude, first.longitude),
            12,
          );
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _placesError = error.toString();
        _loadingPlaces = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    _sheetController.dispose();
    _sheetExtent.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------
  // LOKASI
  // ----------------------------------------------------------------

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;
    setState(() => _loadingLocation = true);

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _locationFailed(
          'GPS belum aktif. Aktifkan lokasi di HP kamu.',
          actionLabel: 'Buka',
          onAction: Geolocator.openLocationSettings,
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _locationFailed('Izinkan akses lokasi untuk melihat titik terdekat.');
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        _locationFailed(
          'Izin lokasi ditolak permanen. Ubah di Pengaturan.',
          actionLabel: 'Pengaturan',
          onAction: Geolocator.openAppSettings,
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;

      final here = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _user = here;
        _loadingLocation = false;
      });
      _mapController.move(here, 14.5);
    } catch (_) {
      _locationFailed('Lokasi belum berhasil didapat. Coba lagi.');
    }
  }

  void _locationFailed(
    String message, {
    String? actionLabel,
    Future<bool> Function()? onAction,
  }) {
    if (!mounted) return;
    setState(() {
      _loadingLocation = false;
      _user = null;
    });
    _snack(message, actionLabel: actionLabel, onAction: onAction);
  }

  Future<void> _recenter() async {
    if (_loadingLocation) return;
    final here = _user;
    if (here == null) {
      await _getCurrentLocation();
    } else {
      _mapController.move(here, 15);
    }
  }

  // ----------------------------------------------------------------
  // DATA
  // ----------------------------------------------------------------

  List<PilahLocation> get _results {
    final now = DateTime.now();
    var list = searchPilah(
      locations: _locations,
      query: _query,
      category: _category,
      userLat: _user?.latitude,
      userLng: _user?.longitude,
    );
    if (_openOnly) {
      list = list.where((p) => p.isOpenAt(now)).toList();
    }
    return list;
  }

  String? _distanceOf(PilahLocation p) {
    final here = _user;
    if (here == null) return null;
    return formatDistance(p.distanceKmFrom(here.latitude, here.longitude));
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _category = null;
      _openOnly = false;
    });
  }

  // ----------------------------------------------------------------
  // AKSI
  // ----------------------------------------------------------------

  Future<void> _openRoute(PilahLocation p) async {
    final dest = '${p.latitude},${p.longitude}';
    final here = _user;
    final uri = Uri.parse(
      here != null
          ? 'https://www.google.com/maps/dir/?api=1'
              '&origin=${here.latitude},${here.longitude}'
              '&destination=$dest&travelmode=driving'
          : 'https://www.google.com/maps/search/?api=1&query=$dest',
    );
    await _launch(uri, 'Tidak bisa membuka Maps.');
  }

  Future<void> _call(PilahLocation p) async {
    final phone = p.phone;
    if (phone == null) return;
    final number = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    await _launch(
        Uri(scheme: 'tel', path: number), 'Tidak bisa melakukan panggilan.');
  }

  Future<void> _launch(Uri uri, String errorMessage) async {
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) _snack(errorMessage);
    } catch (_) {
      _snack(errorMessage);
    }
  }

  void _snapSheetTo(double target) {
    if (!_sheetController.isAttached) return;
    if (_sheetController.size < target - 0.02) {
      unawaited(_sheetController.animateTo(
        target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      ));
    }
  }

  void _focusOnMap(PilahLocation p) {
    if (_sheetController.isAttached) {
      unawaited(_sheetController.animateTo(
        _sheetMid,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ));
    }
    _mapController.move(LatLng(p.latitude, p.longitude), 16);
  }

  void _snack(
    String message, {
    String? actionLabel,
    Future<bool> Function()? onAction,
  }) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: actionLabel == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                onPressed: () {
                  if (onAction != null) unawaited(onAction());
                },
              ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final places = _results;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          return Stack(
            children: [
              Positioned.fill(child: _buildMap(places)),
              _buildFloatingControls(height),
              _buildTopBar(),
              _buildSheet(places),
            ],
          );
        },
      ),
    );
  }

  // Tombol lokasi + atribusi OSM mengikuti tinggi sheet, lalu menghilang
  // saat sheet hampir penuh.
  Widget _buildFloatingControls(double height) {
    return ValueListenableBuilder<double>(
      valueListenable: _sheetExtent,
      builder: (context, extent, _) {
        final opacity = ((0.62 - extent) / 0.18).clamp(0.0, 1.0).toDouble();
        return Positioned(
          left: 16,
          right: 16,
          bottom: extent * height + 12,
          child: IgnorePointer(
            ignoring: opacity < 0.05,
            child: Opacity(
              opacity: opacity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildAttribution(),
                  const Spacer(),
                  _buildLocateButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------------
  // TOP BAR
  // ----------------------------------------------------------------

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSearch(),
              ),
              const SizedBox(height: 10),
              _buildFilters(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: _ink,
        ),
        decoration: InputDecoration(
          hintText: 'Cari tempat atau jenis sampah',
          hintStyle: const TextStyle(
            color: _muted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: _muted),
          suffixIcon: _query.isNotEmpty
              ? IconButton(
                  onPressed: _searchController.clear,
                  icon:
                      const Icon(Icons.close_rounded, size: 20, color: _muted),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 40,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _FilterChip(
            label: 'Semua',
            selected: _category == null,
            onTap: () => setState(() => _category = null),
          ),
          for (final c in PilahCategory.values) ...[
            const SizedBox(width: 8),
            _FilterChip(
              label: c.label,
              dot: c.color,
              selected: _category == c,
              onTap: () =>
                  setState(() => _category = _category == c ? null : c),
            ),
          ],
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Buka sekarang',
            icon: Icons.schedule_rounded,
            selected: _openOnly,
            onTap: () => setState(() => _openOnly = !_openOnly),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // PETA
  // ----------------------------------------------------------------

  Widget _buildMap(List<PilahLocation> places) {
    final markers = <Marker>[];

    final here = _user;
    if (here != null) {
      markers.add(
        Marker(
          point: here,
          width: 52,
          height: 52,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen.withValues(alpha: 0.15),
            ),
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 3),
                ),
              ),
            ),
          ),
        ),
      );
    }

    for (final p in places) {
      final selected = p.id == _selectedId;
      final size = selected ? 46.0 : 36.0;
      markers.add(
        Marker(
          point: LatLng(p.latitude, p.longitude),
          width: 48,
          height: 48,
          child: GestureDetector(
            onTap: () => _showDetail(p),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: p.category.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  p.category.icon,
                  color: AppColors.white,
                  size: selected ? 22 : 17,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _user ?? _fallbackCenter,
        initialZoom: 13.5,
        minZoom: 4,
        maxZoom: 19,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.pilara',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }

  Widget _buildLocateButton() {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: const Color(0x33000000),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _recenter,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: _loadingLocation
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: AppColors.primaryGreen,
                    ),
                  )
                : Icon(
                    _user != null
                        ? Icons.my_location_rounded
                        : Icons.location_searching_rounded,
                    color: AppColors.primaryGreen,
                    size: 22,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttribution() {
    return GestureDetector(
      onTap: () => unawaited(
        launchUrl(
          Uri.parse('https://www.openstreetmap.org/copyright'),
          mode: LaunchMode.externalApplication,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          '© OpenStreetMap',
          style: TextStyle(fontSize: 10, color: _muted),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // SHEET DAFTAR
  // ----------------------------------------------------------------

  Widget _buildSheet(List<PilahLocation> places) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: _sheetMid,
      minChildSize: _sheetMin,
      maxChildSize: _sheetMax,
      snap: true,
      snapSizes: const [_sheetMin, _sheetMid, _sheetMax],
      builder: (context, scrollController) {
        final now = DateTime.now();
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 24,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: CustomScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(child: _buildSheetHeader(places.length)),
              if (_user == null && !_loadingLocation)
                SliverToBoxAdapter(child: _buildLocationPrompt()),
              if (_loadingPlaces)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (_placesError != null)
                SliverToBoxAdapter(child: _buildPlacesError())
              else if (places.isEmpty)
                SliverToBoxAdapter(child: _buildEmptyState())
              else
                SliverList.separated(
                  itemCount: places.length,
                  separatorBuilder: (_, __) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 1, thickness: 1, color: _line),
                  ),
                  itemBuilder: (context, i) => _buildPlaceTile(places[i], now),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetHeader(int count) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFD9DFDB),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user != null ? 'Terdekat dari kamu' : 'Titik pilah',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$count lokasi',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, color: _muted),
                    ),
                  ],
                ),
              ),
              if (_category != null || _openOnly || _query.isNotEmpty)
                TextButton(
                  onPressed: _resetFilters,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Reset'),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationPrompt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
        decoration: BoxDecoration(
          color: AppColors.mint,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_off_rounded,
              color: AppColors.primaryGreen,
              size: 20,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Aktifkan lokasi untuk melihat jarak dan urutan terdekat.',
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: _ink,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _ActionButton(
              label: 'Aktifkan',
              height: 34,
              fontSize: 12.5,
              radius: 17,
              onTap: _getCurrentLocation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceTile(PilahLocation p, DateTime now) {
    final distance = _distanceOf(p);
    final open = p.isOpenAt(now);

    return InkWell(
      onTap: () => _showDetail(p),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: p.category.tint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(p.category.icon, color: p.category.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${p.category.label}  ·  ${p.city}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12.5, color: _muted),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _StatusDot(open: open, label: p.statusLabel(now)),
                      if (distance != null)
                        _Meta(icon: Icons.near_me_rounded, text: distance),
                      _Meta(
                        icon: Icons.star_rounded,
                        text: p.rating.toStringAsFixed(1),
                        iconColor: const Color(0xFFF2A100),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Buka rute',
              onPressed: () => _openRoute(p),
              icon: const Icon(
                Icons.directions_rounded,
                color: AppColors.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacesError() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            _placesError!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted),
          ),
          const SizedBox(height: 8),
          _ActionButton(
            label: 'Coba lagi',
            height: 40,
            radius: 20,
            onTap: _loadWastePoints,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.mint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: AppColors.primaryGreen,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Tidak ada lokasi yang cocok',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ubah kata kunci atau hapus filter.',
            style: TextStyle(fontSize: 12.5, color: _muted),
          ),
          const SizedBox(height: 16),
          _ActionButton(
            label: 'Reset filter',
            background: AppColors.mint,
            foreground: AppColors.primaryGreen,
            height: 40,
            fontSize: 13,
            radius: 20,
            onTap: _resetFilters,
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // DETAIL
  // ----------------------------------------------------------------

  void _showDetail(PilahLocation p) {
    setState(() => _selectedId = p.id);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x40000000),
      builder: (sheetContext) {
        final now = DateTime.now();
        final open = p.isOpenAt(now);
        final distance = _distanceOf(p);
        final maxHeight = MediaQuery.of(sheetContext).size.height * 0.88;

        return Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9DFDB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kategori + status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: p.category.tint,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(p.category.icon,
                                size: 14, color: p.category.color),
                            const SizedBox(width: 5),
                            Text(
                              p.category.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: p.category.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child:
                            _StatusDot(open: open, label: p.statusLabel(now)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.description,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: _muted,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Statistik
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _Stat(
                            label: 'Jarak',
                            value: distance ?? '-',
                          ),
                        ),
                        const VerticalDivider(
                            width: 1, thickness: 1, color: _line),
                        Expanded(
                          child: _Stat(
                            label: 'Rating',
                            value: p.rating.toStringAsFixed(1),
                          ),
                        ),
                        const VerticalDivider(
                            width: 1, thickness: 1, color: _line),
                        Expanded(
                          child: _Stat(
                            label: 'Jam buka',
                            value: '${p.openHour}–${p.closeHour}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, thickness: 1, color: _line),
                  const SizedBox(height: 16),

                  // Info
                  _InfoRow(
                    icon: Icons.place_outlined,
                    text: '${p.address}, ${p.city}',
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.event_available_outlined,
                    text: _closedDaysLabel(p.closedDays),
                  ),
                  if (p.phone != null) ...[
                    const SizedBox(height: 12),
                    _InfoRow(icon: Icons.call_outlined, text: p.phone!),
                  ],

                  if (p.accepts.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Yang diterima',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final item in p.accepts)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _line),
                            ),
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: _ink,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (p.phone != null) ...[
                        Flexible(
                          child: _ActionButton(
                            label: 'Telepon',
                            icon: Icons.call_rounded,
                            background: AppColors.mint,
                            foreground: AppColors.primaryGreen,
                            height: 52,
                            radius: 26,
                            expand: true,
                            onTap: () => _call(p),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: _ActionButton(
                          label: 'Buka rute',
                          icon: Icons.directions_rounded,
                          expand: true,
                          height: 52,
                          radius: 26,
                          onTap: () {
                            Navigator.pop(sheetContext);
                            _openRoute(p);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _focusOnMap(p);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: _muted,
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Lihat di peta'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (mounted) setState(() => _selectedId = null);
    });
  }
}

// ==================================================================
// WIDGET KECIL
// ==================================================================

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? dot;
  final IconData? icon;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.dot,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.white : _ink;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dot != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: selected ? AppColors.white : dot,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            if (icon != null) ...[
              Icon(icon, size: 15, color: fg),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final bool open;
  final String label;

  const _StatusDot({required this.open, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = open ? _openColor : _muted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const _Meta({
    required this.icon,
    required this.text,
    this.iconColor = AppColors.primaryGreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _ink,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(fontSize: 11.5, color: _muted)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: _muted),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: _ink,
            ),
          ),
        ),
      ],
    );
  }
}

// Tombol sendiri (Material + InkWell) agar tidak terpengaruh
// ElevatedButtonTheme global.
class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final bool expand;
  final double height;
  final double fontSize;
  final double radius;

  const _ActionButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.background = AppColors.primaryGreen,
    this.foreground = AppColors.white,
    this.expand = false,
    this.height = 46,
    this.fontSize = 14,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      clipBehavior: Clip.antiAlias,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          width: expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: fontSize + 4, color: foreground),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
