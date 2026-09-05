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
/// The coordinates are formatted with up to 6 decimal places in the [query]
/// string, which is the maximum precision the supported APIs make use of.
extension type const MapLatLng._(String query) implements MapLocation {
  /// Creates a [MapLatLng] with the given [latitude] and [longitude].
  ///
  /// The values are automatically clipped to their respective valid ranges.
  /// `NaN` is treated as `0`.
  ///
  /// Trailing zeros are omitted, so `35.6812` stays `35.6812` rather than
  /// becoming `35.681200`.
  factory MapLatLng({required double latitude, required double longitude}) {
    final lat = _clamp(latitude, -90, 90);
    final lng = _clamp(longitude, -180, 180);

    return MapLatLng._('${_format(lat)},${_format(lng)}');
  }

  /// The maximum number of decimal places used when formatting coordinates.
  static const _precision = 6;

  static double _clamp(double value, double min, double max) {
    if (value.isNaN) {
      return 0;
    }

    return value < min
        ? min
        : value > max
        ? max
        : value;
  }

  static String _format(double value) {
    final fixed = value.toStringAsFixed(_precision);
    final trimmed = fixed.replaceFirst(RegExp(r'0+$'), '');

    return trimmed.endsWith('.')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;
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
