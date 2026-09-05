// The types below are `extension type const` wrappers. Elsewhere in the test
// suite they are invoked as `const`, so the compiler evaluates them and their
// bodies never run. This file invokes each of them without `const` to keep them
// covered.
// ignore_for_file: prefer_const_constructors

import 'package:static_map_service/static_map_service.dart';
import 'package:test/test.dart';

void main() {
  group('MapLocation', () {
    test('wraps the given query', () {
      expect(MapLocation('Tokyo Station').query, 'Tokyo Station');
    });
  });

  group('MapAddress', () {
    test('wraps the given address', () {
      final address = MapAddress('Tokyo Station');

      expect(address.address, 'Tokyo Station');
      expect(address.query, 'Tokyo Station');
    });
  });

  group('GoogleMapColor', () {
    test('presets', () {
      expect(GoogleMapColor.black().name, 'black');
      expect(GoogleMapColor.brown().name, 'brown');
      expect(GoogleMapColor.green().name, 'green');
      expect(GoogleMapColor.purple().name, 'purple');
      expect(GoogleMapColor.yellow().name, 'yellow');
      expect(GoogleMapColor.blue().name, 'blue');
      expect(GoogleMapColor.gray().name, 'gray');
      expect(GoogleMapColor.orange().name, 'orange');
      expect(GoogleMapColor.red().name, 'red');
      expect(GoogleMapColor.white().name, 'white');
    });

    test('hex prefixes the value with 0x', () {
      expect(GoogleMapColor.hex('aabbcc').name, '0xaabbcc');
    });

    test('unnamed constructor keeps the value as is', () {
      expect(GoogleMapColor('0xaabbccdd').name, '0xaabbccdd');
    });
  });

  group('AppleMapAnnotationColor', () {
    test('wraps the given color', () {
      expect(AppleMapAnnotationColor('#ff0000').color, '#ff0000');
    });
  });

  group('MapboxMapOverlay', () {
    test('wraps the given query', () {
      expect(MapboxMapOverlay('pin-s(1,2)').query, 'pin-s(1,2)');
    });
  });
}
