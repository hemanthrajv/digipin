import 'package:test/test.dart';
import 'package:digipin/src/digipin_base.dart';

void main() {
  group('DigiPinGrid', () {
    test('getDigiPin throws on out of bounds latitude', () {
      expect(() => DigiPin.getDigiPin(0.0, 70.0), throwsArgumentError);
      expect(() => DigiPin.getDigiPin(40.0, 70.0), throwsArgumentError);
    });

    test('getDigiPin throws on out of bounds longitude', () {
      expect(() => DigiPin.getDigiPin(10.0, 60.0), throwsArgumentError);
      expect(() => DigiPin.getDigiPin(10.0, 120.0), throwsArgumentError);
    });

    test('getDigiPin returns correct format', () {
      final pin = DigiPin.getDigiPin(28.6139, 77.209);
      expect(pin.length, 12); // 10 chars + 2 hyphens
      expect(pin[3], '-'); // expect hyphen at 4th position
      expect(pin[7], '-'); // expect hyphen at 8th position
      final validChars = RegExp(r'^[A-Z0-9-]+$');
      expect(validChars.hasMatch(pin), isTrue);
    });

    test('encode then decode approximates original lat/lon', () {
      final lat = 28.6139;
      final lon = 77.209;
      final pin = DigiPin.getDigiPin(lat, lon);
      final decoded = DigiPin.getLatLngFromDigiPin(pin);

      final decodedLat = double.parse(decoded['latitude']!);
      final decodedLon = double.parse(decoded['longitude']!);

      expect((decodedLat - lat).abs() < 0.1, isTrue);
      expect((decodedLon - lon).abs() < 0.1, isTrue);
    });

    test('getLatLngFromDigiPin throws on invalid length', () {
      expect(() => DigiPin.getLatLngFromDigiPin('ABCDE'), throwsArgumentError);
    });

    test('getLatLngFromDigiPin throws on invalid character', () {
      expect(
        () => DigiPin.getLatLngFromDigiPin('AAAAAAAAAA'),
        throwsArgumentError,
      );
    });
  });
}
