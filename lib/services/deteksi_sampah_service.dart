import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';

import 'pilala_firebase.dart';

class WasteDetectionResult {
  const WasteDetectionResult({
    required this.objectName,
    required this.category,
    required this.processingMethod,
  });

  final String objectName;
  final String category;
  final String processingMethod;
}

class DeteksiSampahService {
  static const _categories = {'Organik', 'Anorganik', 'B3'};

  Future<WasteDetectionResult> detectWaste({
    required Uint8List imageBytes,
    required String mimeType,
  }) async {
    await PilalaFirebase.initialize();
    PilalaFirebase.requireReady();

    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
      systemInstruction: Content.system(
        'Kamu adalah ahli pemilahan sampah. Identifikasi objek utama pada '
        'gambar, pilih satu kategori yang paling sesuai dari Organik, '
        'Anorganik, atau B3, lalu berikan cara pengolahan yang aman dan praktis.',
      ),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseJsonSchema: const {
          'type': 'object',
          'properties': {
            'objectName': {'type': 'string'},
            'category': {
              'type': 'string',
              'enum': ['Organik', 'Anorganik', 'B3'],
            },
            'processingMethod': {'type': 'string'},
          },
          'required': ['objectName', 'category', 'processingMethod'],
        },
      ),
    );

    final response = await model.generateContent([
      Content.multi([
        TextPart(
          'Periksa gambar dan kembalikan hanya JSON dengan properti '
          'objectName, category, dan processingMethod.',
        ),
        InlineDataPart(mimeType, imageBytes),
      ]),
    ]);
    final text = response.text;
    if (text == null || text.trim().isEmpty) {
      throw const FormatException('Pilala tidak menghasilkan hasil deteksi.');
    }
    return parseResponse(text);
  }

  static WasteDetectionResult parseResponse(String response) {
    final decoded = jsonDecode(response);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Format hasil deteksi tidak valid.');
    }

    final objectName = decoded['objectName'];
    final category = decoded['category'];
    final processingMethod = decoded['processingMethod'];
    if (objectName is! String ||
        objectName.trim().isEmpty ||
        category is! String ||
        !_categories.contains(category) ||
        processingMethod is! String ||
        processingMethod.trim().isEmpty) {
      throw const FormatException('Data hasil deteksi tidak lengkap.');
    }

    return WasteDetectionResult(
      objectName: objectName.trim(),
      category: category,
      processingMethod: processingMethod.trim(),
    );
  }
}
