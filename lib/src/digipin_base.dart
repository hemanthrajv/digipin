class DigiPin {
  static const List<List<String>> _digipinGrid = [
    ['F', 'C', '9', '8'],
    ['J', '3', '2', '7'],
    ['K', '4', '5', '6'],
    ['L', 'M', 'P', 'T'],
  ];

  static const double _minLat = 2.5;
  static const double _maxLat = 38.5;
  static const double _minLon = 63.5;
  static const double _maxLon = 99.5;

  /// Encodes latitude & longitude into a 10-digit alphanumeric DIGIPIN.
  static String getDigiPin(double lat, double lon) {
    if (lat < _minLat || lat > _maxLat) {
      throw ArgumentError('Latitude out of range');
    }
    if (lon < _minLon || lon > _maxLon) {
      throw ArgumentError('Longitude out of range');
    }

    double minLat = _minLat;
    double maxLat = _maxLat;
    double minLon = _minLon;
    double maxLon = _maxLon;
    final StringBuffer digiPin = StringBuffer();

    for (int level = 1; level <= 10; level++) {
      final latDiv = (maxLat - minLat) / 4;
      final lonDiv = (maxLon - minLon) / 4;

      // REVERSED row logic (to match original)
      int row = 3 - ((lat - minLat) / latDiv).floor();
      int col = ((lon - minLon) / lonDiv).floor();

      row = row.clamp(0, 3);
      col = col.clamp(0, 3);

      digiPin.write(_digipinGrid[row][col]);

      if (level == 3 || level == 6) digiPin.write('-');

      // Update bounds (reverse logic for row)
      maxLat = minLat + latDiv * (4 - row);
      minLat = minLat + latDiv * (3 - row);
      minLon = minLon + lonDiv * col;
      maxLon = minLon + lonDiv;
    }

    return digiPin.toString();
  }

  /// Decodes a DIGIPIN back into its central latitude & longitude
  static Map<String, String> getLatLngFromDigiPin(String digiPin) {
    final pin = digiPin.replaceAll('-', '');

    if (pin.length != 10) {
      throw ArgumentError('Invalid DIGIPIN length');
    }

    double minLat = _minLat;
    double maxLat = _maxLat;
    double minLon = _minLon;
    double maxLon = _maxLon;

    for (final char in pin.split('')) {
      int ri = -1, ci = -1;
      bool found = false;

      // Locate character in DIGIPIN grid
      for (int r = 0; r < 4; r++) {
        for (int c = 0; c < 4; c++) {
          if (_digipinGrid[r][c] == char) {
            ri = r;
            ci = c;
            found = true;
            break;
          }
        }
        if (found) break;
      }

      if (!found) {
        throw ArgumentError('Invalid character in DIGIPIN');
      }

      final latDiv = (maxLat - minLat) / 4;
      final lonDiv = (maxLon - minLon) / 4;

      final lat1 = maxLat - latDiv * (ri + 1);
      final lat2 = maxLat - latDiv * ri;
      final lon1 = minLon + lonDiv * ci;
      final lon2 = minLon + lonDiv * (ci + 1);

      // Update bounding box for next level
      minLat = lat1;
      maxLat = lat2;
      minLon = lon1;
      maxLon = lon2;
    }

    final centerLat = (minLat + maxLat) / 2;
    final centerLon = (minLon + maxLon) / 2;

    return {
      'latitude': centerLat.toStringAsFixed(6),
      'longitude': centerLon.toStringAsFixed(6),
    };
  }
}
