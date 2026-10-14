import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  Interpreter? _interpreter;

  List<String> _labels = [];

  bool _isInitializing = true;
  bool _isProcessing = false;

  String? _imagePath;
  String? _prediction;
  double? _confidence;

  // Urutan class model
  // 0 = anorganik
  // 1 = b3
  // 2 = lainnya
  // 3 = organik
  final List<String> _fallbackLabels = [
    'anorganik',
    'b3',
    'lainnya',
    'organik',
  ];

  @override
  void initState() {
    super.initState();
    _initializeCameraAndModel();
  }

  // =============================================================
  // INITIALIZE CAMERA + MODEL
  // =============================================================

  Future<void> _initializeCameraAndModel() async {
    try {
      // =========================================================
      // LOAD CAMERA
      // =========================================================

      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception('Kamera tidak ditemukan.');
      }

      final camera = cameras.firstWhere(
        (camera) =>
            camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();

      // =========================================================
      // LOAD MODEL TFLITE
      // =========================================================

      final interpreter = await Interpreter.fromAsset(
        'assets/models/model.tflite',
      );

      // =========================================================
      // LOAD LABELS
      // =========================================================

      List<String> labels;

      try {
        final labelsText = await rootBundle.loadString(
          'assets/models/labels.txt',
        );

        labels = labelsText
            .split('\n')
            .map((label) => label.trim())
            .where((label) => label.isNotEmpty)
            .toList();
      } catch (_) {
        labels = _fallbackLabels;
      }

      // Kalau jumlah label tidak sesuai model,
      // gunakan fallback.
      if (labels.length != 4) {
        labels = _fallbackLabels;
      }

      if (!mounted) {
        controller.dispose();
        interpreter.close();
        return;
      }

      setState(() {
        _cameraController = controller;
        _interpreter = interpreter;
        _labels = labels;
        _isInitializing = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isInitializing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyiapkan kamera: $e',
          ),
        ),
      );
    }
  }

  // =============================================================
  // AMBIL FOTO
  // =============================================================

  Future<void> _takePicture() async {
    final controller = _cameraController;

    if (controller == null ||
        !controller.value.isInitialized ||
        _isProcessing) {
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
      });

      final XFile photo = await controller.takePicture();

      if (!mounted) return;

      setState(() {
        _imagePath = photo.path;
        _prediction = null;
        _confidence = null;
      });

      await _classifyImage(photo.path);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengambil foto: $e',
          ),
        ),
      );
    }
  }

  // =============================================================
  // CLASSIFICATION
  // =============================================================

  Future<void> _classifyImage(String path) async {
    final interpreter = _interpreter;

    if (interpreter == null) {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Model belum berhasil dimuat.',
          ),
        ),
      );

      return;
    }

    try {
      // =========================================================
      // READ IMAGE
      // =========================================================

      final Uint8List imageBytes =
          await File(path).readAsBytes();

      final img.Image? decodedImage =
          img.decodeImage(imageBytes);

      if (decodedImage == null) {
        throw Exception(
          'Foto tidak dapat diproses.',
        );
      }

      // =========================================================
      // RESIZE IMAGE
      // Model menggunakan input [1, 224, 224, 3]
      // =========================================================

      final img.Image resizedImage = img.copyResize(
        decodedImage,
        width: 224,
        height: 224,
      );

      // =========================================================
      // CONVERT IMAGE TO MODEL INPUT
      // =========================================================

      final input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(
            224,
            (x) {
              final pixel = resizedImage.getPixel(
                x,
                y,
              );

              return [
                (pixel.r - 127.5) / 127.5,
                (pixel.g - 127.5) / 127.5,
                (pixel.b - 127.5) / 127.5,
              ];
            },
          ),
        ),
      );

      // =========================================================
      // MODEL OUTPUT
      // =========================================================

      final output = [
        List<double>.filled(
          4,
          0,
        ),
      ];

      interpreter.run(
        input,
        output,
      );

      final scores = output[0];

      // =========================================================
      // CARI SCORE TERBESAR
      // =========================================================

      int bestIndex = 0;
      double bestScore = scores[0];

      for (int i = 1; i < scores.length; i++) {
        if (scores[i] > bestScore) {
          bestScore = scores[i];
          bestIndex = i;
        }
      }

      // Pastikan index aman
      if (bestIndex >= _labels.length) {
        throw Exception(
          'Label tidak sesuai dengan output model.',
        );
      }

      final label = _labels[bestIndex];

      if (!mounted) return;

      setState(() {
        _prediction = _formatLabel(label);
        _confidence = bestScore;
        _isProcessing = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengenali sampah: $e',
          ),
        ),
      );
    }
  }

  // =============================================================
  // FORMAT LABEL
  // =============================================================

  String _formatLabel(String label) {
    switch (label.toLowerCase()) {
      case 'b3':
        return 'B3';

      case 'anorganik':
        return 'Anorganik';

      case 'organik':
        return 'Organik';

      case 'lainnya':
        return 'Lainnya';

      default:
        return label;
    }
  }

  // =============================================================
  // RESET FOTO
  // =============================================================

  void _retakePicture() {
    setState(() {
      _imagePath = null;
      _prediction = null;
      _confidence = null;
    });
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();

    super.dispose();
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isInitializing
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : _cameraController == null
              ? _buildCameraError()
              : _buildCameraContent(),
    );
  }

  // =============================================================
  // CAMERA CONTENT
  // =============================================================

  Widget _buildCameraContent() {
    final controller = _cameraController!;

    return Stack(
      fit: StackFit.expand,
      children: [
        // =======================================================
        // CAMERA PREVIEW / HASIL FOTO
        // =======================================================

        if (_imagePath == null)
          CameraPreview(controller)
        else
          Image.file(
            File(_imagePath!),
            fit: BoxFit.cover,
          ),

        // =======================================================
        // DARK OVERLAY
        // =======================================================

        if (_imagePath == null)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(
                        alpha: 0.45,
                      ),
                      Colors.transparent,
                      Colors.black.withValues(
                        alpha: 0.55,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // =======================================================
        // HEADER
        // =======================================================

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(
                      alpha: 0.35,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                const Expanded(
                  child: Text(
                    'Identifikasi Sampah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // =======================================================
        // CAMERA GUIDE
        // =======================================================

        if (_imagePath == null)
          Center(
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: 0.85,
                  ),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  'Posisikan sampah di sini',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

        // =======================================================
        // RESULT
        // =======================================================

        if (_prediction != null)
          Positioned(
            left: 20,
            right: 20,
            bottom: 150,
            child: _buildResultCard(),
          ),

        // =======================================================
        // BOTTOM CAMERA CONTROL
        // =======================================================

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
                left: 20,
                right: 20,
              ),
              child: _imagePath == null
                  ? _buildCaptureButton()
                  : _buildRetakeButton(),
            ),
          ),
        ),

        // =======================================================
        // PROCESSING
        // =======================================================

        if (_isProcessing)
          Container(
            color: Colors.black.withValues(
              alpha: 0.55,
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  SizedBox(height: 18),
                  Text(
                    'Mengenali sampah...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // =============================================================
  // CAPTURE BUTTON
  // =============================================================

  Widget _buildCaptureButton() {
    return Center(
      child: GestureDetector(
        onTap: _takePicture,
        child: Container(
          width: 76,
          height: 76,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Color(0xFF3F7040),
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // RETAKE BUTTON
  // =============================================================

  Widget _buildRetakeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed:
            _isProcessing ? null : _retakePicture,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF3F7040),
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(
          Icons.camera_alt,
        ),
        label: const Text(
          'Ambil Foto Lagi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // RESULT CARD
  // =============================================================

  Widget _buildResultCard() {
    final confidence = ((_confidence ?? 0) * 100).clamp(
      0,
      100,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.2,
            ),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F3E4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.recycling,
              color: Color(0xFF3F7040),
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hasil Identifikasi',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  _prediction ?? '-',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263329),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Keyakinan '
                  '${confidence.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Color(0xFF3F7040),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // CAMERA ERROR
  // =============================================================

  Widget _buildCameraError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 70,
            ),

            const SizedBox(height: 20),

            const Text(
              'Kamera tidak dapat digunakan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Pastikan izin kamera sudah diberikan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isInitializing = true;
                });

                _initializeCameraAndModel();
              },
              child: const Text(
                'Coba Lagi',
              ),
            ),
          ],
        ),
      ),
    );
  }
}