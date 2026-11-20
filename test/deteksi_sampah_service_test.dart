import 'package:flutter_test/flutter_test.dart';
import 'package:pilara/services/deteksi_sampah_service.dart';

void main() {
  group('DeteksiSampahService.parseResponse', () {
    test('parses valid waste identification JSON', () {
      final result = DeteksiSampahService.parseResponse(
        '{"objectName":"Kulit pisang","category":"Organik",'
        '"processingMethod":"Jadikan kompos."}',
      );

      expect(result.objectName, 'Kulit pisang');
      expect(result.category, 'Organik');
      expect(result.processingMethod, 'Jadikan kompos.');
    });

    test('rejects categories outside the supported waste types', () {
      expect(
        () => DeteksiSampahService.parseResponse(
          '{"objectName":"Baterai","category":"Lainnya",'
          '"processingMethod":"Bawa ke fasilitas B3."}',
        ),
        throwsFormatException,
      );
    });
  });
}
