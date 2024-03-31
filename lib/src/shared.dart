/// The base class for map location
extension type MapLocation._(String query) {}

extension type MapLatLng._(String query) implements MapLocation {
  factory MapLatLng({
    required double latitude,
    required double longitude,
  }) {
    assert(latitude >= -90 && latitude <= 90);
    assert(longitude >= -180 && longitude <= 180);
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
}

/// The address of the map location
extension type MapAddress._(String query) implements MapLocation {
  factory MapAddress({
    required String address,
  }) =>
      MapAddress._(address);
}

/// Create digital signature function
typedef SignatureFunction = String Function(String pathAndParams);
