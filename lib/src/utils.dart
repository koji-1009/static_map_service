import 'dart:math' as math;
import 'package:static_map_service/src/shared.dart';

/// Encodes a list of [MapLatLng] into an encoded path string.
///
/// Implements the Encoded Polyline Algorithm Format.
/// https://developers.google.com/maps/documentation/utilities/polylinealgorithm
String encodePolyline(List<MapLatLng> locations) {
  final result = StringBuffer();

  int lastLat = 0;
  int lastLng = 0;

  for (final location in locations) {
    // Parsing back from the query string is inefficient but keeps MapLatLng opaque.
    // However, MapLatLng uses fixed precision strings internally.
    // To properly support encoding, we might need access to raw values or parse them.
    // Since MapLatLng stores 'lat,lng' string, we parse it.
    final parts = location.query.split(',');
    final lat = double.parse(parts[0]);
    final lng = double.parse(parts[1]);

    final int latE5 = (lat * 1e5).round();
    final int lngE5 = (lng * 1e5).round();

    _encode(latE5 - lastLat, result);
    _encode(lngE5 - lastLng, result);

    lastLat = latE5;
    lastLng = lngE5;
  }

  return result.toString();
}

void _encode(int value, StringBuffer result) {
  int v = value;
  v = v < 0 ? ~(v << 1) : v << 1;
  while (v >= 0x20) {
    result.writeCharCode((0x20 | (v & 0x1f)) + 63);
    v >>= 5;
  }
  result.writeCharCode(v + 63);
}
