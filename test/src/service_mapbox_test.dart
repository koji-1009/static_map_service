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
      final service = MapboxMapService.auto(
        accessToken: accessToken,
        overlays: [MapboxMarker(location: center)],
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
      expect(
        () => MapboxMapSize(width: 1281, height: 300),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => MapboxMapSize(width: 400, height: 0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => MapboxMapSize(width: 400, height: 1281),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('MapboxMapService url encoding', () {
    const accessToken = 'token';
    final center = MapLatLng(latitude: 35.6812, longitude: 139.7671);
    final size = MapboxMapSize(width: 400, height: 300);

    test('encoded polyline is percent-encoded exactly once', () {
      final service = MapboxMapService.auto(
        accessToken: accessToken,
        overlays: [
          MapboxPath(
            locations: [
              MapLatLng(latitude: 38.5, longitude: -120.2),
              MapLatLng(latitude: 40.7, longitude: -120.95),
              MapLatLng(latitude: 43.252, longitude: -126.453),
            ],
          ),
        ],
        size: size,
      );

      expect(
        service.url,
        'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/'
        'path-1.0+0000FF-1.0(_p~iF~ps%7CU_ulLnnqC_mqNvxq%60%40)'
        '/auto/400x300?access_token=token',
      );
      expect(service.url, isNot(contains('%25')));
    });

    test('GeoJSON overlay is percent-encoded exactly once', () {
      final service = MapboxMapService.auto(
        accessToken: accessToken,
        overlays: [MapboxGeoJson(geoJson: '{"type":"Point"}')],
        size: size,
      );

      expect(
        service.url,
        'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/'
        'geojson(%7B%22type%22%3A%22Point%22%7D)'
        '/auto/400x300?access_token=token',
      );
      expect(service.url, isNot(contains('%25')));
    });

    test('custom marker url is percent-encoded exactly once', () {
      final service = MapboxMapService.auto(
        accessToken: accessToken,
        overlays: [
          MapboxMarker(location: center, url: 'http://example.com/icon.png'),
        ],
        size: size,
      );

      expect(
        service.url,
        'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/'
        'url-http%3A%2F%2Fexample.com%2Ficon.png(139.7671,35.6812)'
        '/auto/400x300?access_token=token',
      );
      expect(service.url, isNot(contains('%25')));
    });

    test('uri round-trips through Uri.parse without altering the path', () {
      final service = MapboxMapService.auto(
        accessToken: accessToken,
        overlays: [MapboxGeoJson(geoJson: '{"type":"Point"}')],
        size: size,
        retina: true,
      );

      expect(service.uri.path, service.unencodedPath);
      expect(Uri.parse(service.url), service.uri);
    });

    test('query parameters are still encoded', () {
      final service = MapboxMapService(
        accessToken: 'a b+c',
        center: center,
        zoom: 10,
        size: size,
      );

      expect(service.url, endsWith('?access_token=a+b%2Bc'));
    });
  });

  group('MapboxMapService specification compliance', () {
    const accessToken = 'token';
    final center = MapLatLng(latitude: 35.6812, longitude: 139.7671);
    final size = MapboxMapSize(width: 400, height: 300);

    test('padding is rejected outside the auto constructor', () {
      // `padding` can only be used with `auto` or `bbox`.
      expect(
        () => MapboxMapService(
          accessToken: accessToken,
          center: center,
          zoom: 10,
          size: size,
          padding: '10',
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('padding is allowed on the auto constructor', () {
      final service = MapboxMapService.auto(
        accessToken: accessToken,
        overlays: [MapboxMarker(location: center)],
        size: size,
        padding: '10',
      );

      expect(service.queryParameters['padding'], '10');
    });

    test('documented marker sizes are pin-s and pin-l', () {
      expect(MapboxMarkerSize.small.value, 's');
      expect(MapboxMarkerSize.large.value, 'l');
    });
  });
}
