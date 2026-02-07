import 'package:static_map_service/src/service_google.dart';
import 'package:static_map_service/src/shared.dart';
import 'package:test/test.dart';

void main() {
  const key = 'static_map_service_key';
  const zoom = 10;
  final mapSize = GoogleMapSize(width: 400, height: 400);
  final tokyoStationLatLng = MapLatLng(latitude: 35.6812, longitude: 139.7671);

  group('A group of center', () {
    test('required parameters', () {
      final service = GoogleMapService.center(
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
      final service = GoogleMapService.center(
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

  final tokyoStationMarker = GoogleMapMarkers(locations: {tokyoStationLatLng});

  group('A group of markers', () {
    test('required parameters', () {
      final service = GoogleMapService.markers(
        key: key,
        markers: {tokyoStationMarker},
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
        markers: {tokyoStationMarker},
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
        markers: {tokyoStationMarker},
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
        markers: {tokyoStationMarker},
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
        markers: {tokyoStationMarker},
        zoom: zoom,
        size: mapSize,
        scale: 2,
      );

      expect(
        service.url,
        'https://maps.googleapis.com/maps/api/staticmap?zoom=10&size=400x400&scale=2&markers=35.6812%2C139.7671&key=static_map_service_key',
      );
    });

    test('markers with options', () {
      final service = GoogleMapService.markers(
        key: key,
        markers: {
          GoogleMapMarkers(
            locations: {tokyoStationLatLng},
            size: GoogleMapMarkerSize.small,
            color: const GoogleMapColor.blue(),
            label: 'A',
          ),
        },
        zoom: zoom,
        size: mapSize,
      );

      expect(
        service.url,
        contains(
          'markers=size%3Asmall%7Ccolor%3Ablue%7Clabel%3AA%7C35.6812%2C139.7671',
        ),
      );
    });

    test('path encoded', () {
      final service = GoogleMapService.path(
        key: key,
        path: GoogleMapPath.encoded(
          locations: [
            MapLatLng(latitude: 38.5, longitude: -120.2),
            MapLatLng(latitude: 40.7, longitude: -120.95),
            MapLatLng(latitude: 43.252, longitude: -126.453),
          ],
          color: const GoogleMapColor.red(),
          weight: 5,
        ),
        size: mapSize,
      );

      // _p~iF~ps|U_ulLnnqC_mqNvxq`@
      expect(
        service.url,
        contains(
          'path=weight%3A5%7Ccolor%3Ared%7Cenc%3A_p~iF~ps%7CU_ulLnnqC_mqNvxq%60%40',
        ),
      );
    });
  });
}
