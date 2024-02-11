import 'package:static_map_service/src/shared.dart';
import 'package:test/test.dart';

void main() {
  group('A group of MapLatLng', () {
    test('success case', () {
      expect(
        const MapLatLng(
          latitude: 35.6812,
          longitude: 139.7671,
        ).query,
        '35.6812,139.7671',
      );
    });

    test('failure case', () {
      expect(
        () => MapLatLng(
          latitude: 91,
          longitude: 0,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => MapLatLng(
          latitude: -91,
          longitude: 0,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => MapLatLng(
          latitude: 0,
          longitude: 181,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => MapLatLng(
          latitude: 0,
          longitude: -181,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('A group of MapAddress', () {
    test('success case', () {
      expect(
        const MapAddress(
          address: 'Tokyo Station',
        ).query,
        'Tokyo Station',
      );
    });
  });
}
