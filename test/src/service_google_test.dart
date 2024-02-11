import 'package:static_map_service/src/service_google.dart';
import 'package:static_map_service/src/shared.dart';
import 'package:test/test.dart';

void main() {
  group('A group of center', () {
    const key = 'static_map_service_key';
    const zoom = 10;
    const mapSize = GoogleMapSize(
      width: 400,
      height: 400,
    );
    const tokyoStation = MapLatLng(
      latitude: 35.6812,
      longitude: 139.7671,
    );

    test('required parameters', () {
      const service = GoogleMapService.center(
        key: key,
        center: tokyoStation,
        zoom: zoom,
        size: mapSize,
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?center=35.6812%2C139.7671&zoom=10&size=400x400&key=static_map_service_key',
      );
    });

    test('input_url', () {
      const service = GoogleMapService.center(
        key: key,
        center: tokyoStation,
        zoom: zoom,
        size: mapSize,
      );

      expect(
        service.pathAndParams,
        '/maps/api/staticmap?center=35.6812%2C139.7671&zoom=10&size=400x400&key=static_map_service_key',
      );
    });

    test('signature', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStation,
        zoom: zoom,
        size: mapSize,
        signatureFunction: (inputUrl) => 'signature',
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?center=35.6812%2C139.7671&zoom=10&size=400x400&key=static_map_service_key&signature=signature',
      );
    });
  });
}
