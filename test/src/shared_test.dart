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
      expect(
        MapLatLng(latitude: 100, longitude: 200).query,
        '90.0000,180.0000',
      );
      expect(
        MapLatLng(latitude: -100, longitude: -200).query,
        '-90.0000,-180.0000',
      );
    });

    test('getters', () {
      final latLng = MapLatLng(latitude: 35.6812, longitude: 139.7671);
      expect(latLng.latitude, 35.6812);
      expect(latLng.longitude, 139.7671);
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
