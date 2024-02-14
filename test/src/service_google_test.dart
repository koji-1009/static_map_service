import 'package:static_map_service/src/service_google.dart';
import 'package:static_map_service/src/shared.dart';
import 'package:test/test.dart';

void main() {
  const key = 'static_map_service_key';
  const zoom = 10;
  const mapSize = GoogleMapSize(
    width: 400,
    height: 400,
  );
  const tokyoStationLatLng = MapLatLng(
    latitude: 35.6812,
    longitude: 139.7671,
  );

  group('A group of center', () {
    test('required parameters', () {
      const service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?center=35.6812%2C139.7671&zoom=10&size=400x400&key=static_map_service_key',
      );
    });

    test('path_and_params', () {
      const service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
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
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
        signatureFunction: (inputUrl) => 'signature',
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?center=35.6812%2C139.7671&zoom=10&size=400x400&key=static_map_service_key&signature=signature',
      );
    });

    test('scale (1)', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
        scale: 1,
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?center=35.6812%2C139.7671&zoom=10&size=400x400&key=static_map_service_key',
      );
    });

    test('scale (2)', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
        scale: 2,
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?center=35.6812%2C139.7671&zoom=10&size=400x400&scale=2&key=static_map_service_key',
      );
    });

    test('format (png)', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
        format: GoogleMapFormat.png,
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?center=35.6812%2C139.7671&zoom=10&size=400x400&key=static_map_service_key',
      );
    });

    test('format (jpg)', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
        format: GoogleMapFormat.jpg,
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?center=35.6812%2C139.7671&zoom=10&size=400x400&format=jpg&key=static_map_service_key',
      );
    });
  });

  final tokyoStationMarker = GoogleMapMarkers(
    locations: {
      tokyoStationLatLng,
    },
  );

  group('A group of markers', () {
    test('required parameters', () {
      final service = GoogleMapService.markers(
        key: key,
        markers: {
          tokyoStationMarker,
        },
        zoom: zoom,
        size: mapSize,
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?zoom=10&size=400x400&markers=35.6812%2C139.7671&key=static_map_service_key',
      );
    });

    test('path_and_params', () {
      final service = GoogleMapService.markers(
        key: key,
        markers: {
          tokyoStationMarker,
        },
        zoom: zoom,
        size: mapSize,
      );

      expect(
        service.pathAndParams,
        '/maps/api/staticmap?zoom=10&size=400x400&markers=35.6812%2C139.7671&key=static_map_service_key',
      );
    });

    test('signature', () {
      final service = GoogleMapService.markers(
        key: key,
        markers: {
          tokyoStationMarker,
        },
        zoom: zoom,
        size: mapSize,
        signatureFunction: (inputUrl) => 'signature',
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?zoom=10&size=400x400&markers=35.6812%2C139.7671&key=static_map_service_key&signature=signature',
      );
    });

    test('scale (1)', () {
      final service = GoogleMapService.markers(
        key: key,
        markers: {
          tokyoStationMarker,
        },
        zoom: zoom,
        size: mapSize,
        scale: 1,
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?zoom=10&size=400x400&markers=35.6812%2C139.7671&key=static_map_service_key',
      );
    });

    test('scale (2)', () {
      final service = GoogleMapService.markers(
        key: key,
        markers: {
          tokyoStationMarker,
        },
        zoom: zoom,
        size: mapSize,
        scale: 2,
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?zoom=10&size=400x400&scale=2&markers=35.6812%2C139.7671&key=static_map_service_key',
      );
    });
  });
}
