import 'package:static_map_service/static_map_service.dart';
import 'package:test/test.dart';

void main() {
  group('MapboxMapService', () {
    const accessToken = 'pk.eyJ1Ijoi...';
    final center = MapLatLng(latitude: 35.6812, longitude: 139.7671);
    final size = MapboxMapSize(width: 400, height: 300);

    test('simple map', () {
      final service = MapboxMapService(
        accessToken: accessToken,
        center: center,
        zoom: 12.5,
        size: size,
      );

      expect(service.authority, 'api.mapbox.com');
      expect(
        service.unencodedPath,
        '/styles/v1/mapbox/streets-v11/static/139.7671,35.6812,12.5,0.0,0.0/400x300',
      );
      expect(service.queryParameters['access_token'], accessToken);
      expect(
        service.url,
        'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/139.7671,35.6812,12.5,0.0,0.0/400x300?access_token=$accessToken',
      );
    });

    test('auto viewport with markers', () {
      final marker = MapboxMarker(location: center, label: 'a', color: 'f00');

      final service = MapboxMapService.auto(
        accessToken: accessToken,
        overlays: [marker],
        size: size,
      );

      // pin-s-a+f00(139.7671,35.6812)
      expect(
        service.unencodedPath,
        '/styles/v1/mapbox/streets-v11/static/pin-s-a+f00(139.7671,35.6812)/auto/400x300',
      );
    });

    test('path overlay', () {
      final path = MapboxPath(
        locations: [
          MapLatLng(latitude: 35.6812, longitude: 139.7671),
          MapLatLng(latitude: 35.6895, longitude: 139.6917),
        ],
        strokeWidth: 5,
        strokeColor: 'f00',
      );

      final service = MapboxMapService.auto(
        accessToken: accessToken,
        overlays: [path],
        size: size,
      );

      // Verify path exists in url
      expect(service.unencodedPath, contains('path-5.0+f00-1.0('));
    });

    test('optional parameters', () {
      final service = MapboxMapService(
        accessToken: accessToken,
        center: center,
        zoom: 10,
        size: size,
        retina: true,
        logo: false,
        attribution: false,
        padding: '10,10,10,10',
        beforeLayer: 'water',
      );

      expect(service.unencodedPath, endsWith('@2x'));
      expect(service.queryParameters['logo'], 'false');
      expect(service.queryParameters['attribution'], 'false');
      expect(service.queryParameters['padding'], '10,10,10,10');
      expect(service.queryParameters['before_layer'], 'water');
    });

    test('map with bearing and pitch', () {
      final service = MapboxMapService(
        accessToken: accessToken,
        center: center,
        zoom: 10,
        bearing: 45,
        pitch: 60,
        size: size,
      );
      expect(service.unencodedPath, contains(',10.0,45.0,60.0/'));
    });

    test('combined overlays', () {
      final marker = MapboxMarker(location: center);
      final path = MapboxPath(locations: [center]);
      final service = MapboxMapService.auto(
        accessToken: accessToken,
        overlays: [marker, path],
        size: size,
      );
      expect(
        service.unencodedPath,
        contains('pin-s(139.7671,35.6812),path-1.0+0000FF-1.0('),
      );
    });

    test('MapboxMarker with custom url', () {
      final marker = MapboxMarker(
        location: center,
        url: 'http://example.com/icon.png',
      );
      expect(marker.query, contains('url-http%3A%2F%2Fexample.com%2Ficon.png'));
    });

    test('MapboxMarker variations', () {
      expect(MapboxMarker(location: center).query, 'pin-s(139.7671,35.6812)');
      expect(
        MapboxMarker(
          location: center,
          label: 'a',
          size: MapboxMarkerSize.large,
        ).query,
        'pin-l-a(139.7671,35.6812)',
      );
      expect(
        MapboxMarker(location: center, color: 'f00').query,
        'pin-s+f00(139.7671,35.6812)',
      );
    });

    test('MapboxPath with fillColor', () {
      final path = MapboxPath(
        locations: [center],
        fillColor: '00f',
        fillOpacity: 0.5,
      );
      expect(path.query, contains('+00f-0.5('));
    });

    test('MapboxGeoJson', () {
      final geojson = MapboxGeoJson(geoJson: '{"type":"Point"}');
      expect(
        geojson.query,
        contains('geojson(%7B%22type%22%3A%22Point%22%7D)'),
      );
    });

    test('Assertion and Argument errors', () {
      expect(
        () => MapboxMapSize(width: 0, height: 300),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
