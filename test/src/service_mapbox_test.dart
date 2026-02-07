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

      final service = MapboxMapService(
        accessToken: accessToken,
        auto: true,
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

      final service = MapboxMapService(
        accessToken: accessToken,
        auto: true,
        overlays: [path],
        size: size,
      );

      // Verify path exists in url
      expect(service.unencodedPath, contains('path-5.0+f00-1.0('));
    });
  });
}
