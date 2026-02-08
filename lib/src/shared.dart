/// The base class for map location representation.
///
/// This is an extension type that wraps the query string representation
/// of a location as expected by various map APIs.
extension type const MapLocation(String query) {}

/// A representation of geographic coordinates (latitude and longitude).
///
/// This extension type ensures that coordinates are within valid ranges:
/// - Latitude: clipped to [-90.0, 90.0]
/// - Longitude: clipped to [-180.0, 180.0]
///
/// The coordinates are formatted to 4 decimal places in the [query] string.
extension type const MapLatLng._(String query) implements MapLocation {
  /// Creates a [MapLatLng] with the given [latitude] and [longitude].
  ///
  /// The values are automatically clipped to their respective valid ranges.
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

  /// The latitude part of the coordinates.
  double get latitude => double.parse(query.split(',')[0]);

  /// The longitude part of the coordinates.
  double get longitude => double.parse(query.split(',')[1]);
}

/// A representation of a location defined by a physical address or place name.
extension type const MapAddress(String address) implements MapLocation {
  /// The query string representation of the address.
  String get query => address;
}

/// A function type used to generate a digital signature for a given URL path and parameters.
///
/// Many map services require a digital signature (HMAC-SHA1 or similar)
/// to verify the authenticity of the request.
///
/// [pathAndParams] is the portion of the URL starting from the path (e.g., `/api/v1/snapshot?center=...`).
typedef SignatureFunction = String Function(String pathAndParams);
