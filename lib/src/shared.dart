/// The base class for map location
extension type const MapLocation(String query) {}

extension type const MapLatLng._(String query) implements MapLocation {
  factory MapLatLng({required double latitude, required double longitude}) {
    final lat = latitude < -90
        ? -90
        : latitude > 90
        ? 90
        : latitude;
    final lng = longitude < -180
        ? -180
        : longitude > 180
        ? 180
        : longitude;

    return MapLatLng._('${lat.toStringAsFixed(4)},${lng.toStringAsFixed(4)}');
  }

  /// Get the latitude from the query string
  double get latitude => double.parse(query.split(',')[0]);

  /// Get the longitude from the query string
  double get longitude => double.parse(query.split(',')[1]);
}

/// The address of the map location
extension type const MapAddress(String address) implements MapLocation {
  String get query => address;
}

/// Create digital signature function
typedef SignatureFunction = String Function(String pathAndParams);
