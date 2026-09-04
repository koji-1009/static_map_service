import 'package:static_map_service/src/shared.dart';
import 'package:test/test.dart';

void main() {
  group('A group of MapLatLng', () {
    test('success case', () {
      expect(
        MapLatLng(latitude: 35.6812, longitude: 139.7671).query,
        '35.6812,139.7671',
      );
    });

    test('clipping case', () {
      expect(MapLatLng(latitude: 100, longitude: 200).query, '90,180');
      expect(MapLatLng(latitude: -100, longitude: -200).query, '-90,-180');
    });

    test('NaN is treated as zero', () {
      expect(
        MapLatLng(latitude: double.nan, longitude: double.nan).query,
        '0,0',
      );
    });

    test('infinity is clipped', () {
      expect(
        MapLatLng(
          latitude: double.infinity,
          longitude: double.negativeInfinity,
        ).query,
        '90,-180',
      );
    });

    test('keeps 6 decimal places', () {
      expect(
        MapLatLng(latitude: 35.68123456, longitude: 139.76712345).query,
        '35.681235,139.767123',
      );
    });

    test('omits trailing zeros', () {
      expect(MapLatLng(latitude: 1, longitude: -2.5).query, '1,-2.5');
      expect(
        MapLatLng(latitude: 35.681200, longitude: 139.767100).query,
        '35.6812,139.7671',
      );
    });

    test('getters', () {
      final latLng = MapLatLng(latitude: 35.6812, longitude: 139.7671);
      expect(latLng.latitude, 35.6812);
      expect(latLng.longitude, 139.7671);
    });

    test('getters round-trip clipped, negative and rounded values', () {
      final clipped = MapLatLng(latitude: 100, longitude: -200);
      expect(clipped.latitude, 90);
      expect(clipped.longitude, -180);

      final rounded = MapLatLng(latitude: -35.68123456, longitude: 139.7671);
      expect(rounded.latitude, -35.681235);
      expect(rounded.longitude, 139.7671);
    });
  });

  group('A group of MapLocation', () {
    test('query', () {
      expect(const MapLocation('test').query, 'test');
    });
  });

  group('A group of MapAddress', () {
    test('success case', () {
      expect(const MapAddress('Tokyo Station').query, 'Tokyo Station');
    });
  });
}
