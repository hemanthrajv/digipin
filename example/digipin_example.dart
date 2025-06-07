import 'package:digipin/digipin.dart';

void main() {
  final latitude = 28.6139;
  final longitude = 77.2090;

  try {
    // Encode latitude & longitude to DigiPin
    final digiPin = DigiPin.getDigiPin(latitude, longitude);
    print('DigiPin for ($latitude, $longitude): $digiPin');

    // Decode DigiPin back to approximate latitude & longitude
    final decoded = DigiPin.getLatLngFromDigiPin(digiPin);
    print('Decoded latitude: ${decoded['latitude']}');
    print('Decoded longitude: ${decoded['longitude']}');
  } catch (e) {
    print('Error: $e');
  }
}