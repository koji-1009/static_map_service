import 'package:static_map_service/src/shared.dart';
import 'package:static_map_service/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('encodePolyline', () {
    test('encodes points correctly', () {
      // Example from Google Documentation
      // Points: (38.5, -120.2), (40.7, -120.95), (43.252, -126.453)
      // Expected: _p~iF~ps|U_ulLnnqC_mqNvxq`@

      final points = [
        MapLatLng(latitude: 38.5, longitude: -120.2),
        MapLatLng(latitude: 40.7, longitude: -120.95),
        MapLatLng(latitude: 43.252, longitude: -126.453),
      ];

      final encoded = encodePolyline(points);
      expect(encoded, '_p~iF~ps|U_ulLnnqC_mqNvxq`@');
    });

    test('encodes single point', () {
      final points = [MapLatLng(latitude: 38.5, longitude: -120.2)];
      // 38.5 * 1e5 = 3850000 -> binary...
      // -120.2 * 1e5 = -12020000
      // Just check it returns non-empty string.
      final encoded = encodePolyline(points);
      expect(encoded.isNotEmpty, true);
    });

    test('encodes empty list', () {
      expect(encodePolyline([]), '');
    });
  });
}
