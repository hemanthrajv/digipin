# digipin

A pure Dart implementation of Indian Post DigiPin encoding and decoding.

For more information about DigiPin, visit the official page: https://www.indiapost.gov.in/VAS/Pages/digipin.aspx

## Overview

This package provides functionality to encode and decode DigiPins, a secure method used by the Indian Post for authentication and transactions.

## Background

This Dart package is a port of the original DigiPin implementation in JavaScript found here: https://github.com/CEPT-VZG/digipin/blob/main/src/digipin.js

The goal is to provide the same functionality in a pure Dart environment for use in Dart and Flutter applications.

## Usage

Here is an example of encoding and decoding a DigiPin:

```dart
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
```
## Features

- Encode DigiPin
- Decode DigiPin

## Installation

Add this package as a dependency in your Dart or Flutter project's `pubspec.yaml` file.

## Contributing

Contributions are welcome. Please open issues or submit pull requests.

## License

Specify the license here.
