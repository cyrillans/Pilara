import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteService {
  Interpreter? _interpreter;
  List<String> _labels = [];

  Interpreter? get interpreter => _interpreter;
  List<String> get labels => _labels;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/models/model.tflite',
    );

    final labelsData = await rootBundle.loadString(
      'assets/models/labels.txt',
    );

    _labels = labelsData
        .split('\n')
        .map((label) => label.trim())
        .where((label) => label.isNotEmpty)
        .toList();
  }

  void close() {
    _interpreter?.close();
    _interpreter = null;
  }
}