import 'package:static_map_service/src/service_apple.dart';
import 'package:static_map_service/src/shared.dart';
import 'package:test/test.dart';

void main() {
  group('A group of center', () {
    const teamId = 'team_id';
    const keyId = 'key_id';
    final tokyoStation = MapLatLng(latitude: 35.6812, longitude: 139.7671);

    test('required parameters', () {
      final service = AppleMapService(
        center: tokyoStation,
        teamId: teamId,
        keyId: keyId,
        signatureFunction: (inputUrl) => 'signature',
      );

      expect(
        service.pathAndParams,
        '/api/v1/snapshot?center=35.6812%2C139.7671&teamId=team_id&keyId=key_id',
      );

      expect(
        service.url,
        'https://snapshot.apple-mapkit.com/api/v1/snapshot?center=35.6812%2C139.7671&teamId=team_id&keyId=key_id&signature=signature',
      );
    });

    test('overlays and images', () {
      final service = AppleMapService(
        center: tokyoStation,
        teamId: teamId,
        keyId: keyId,
        signatureFunction: (inputUrl) => 'signature',
        overlays: {
          AppleMapOverlay(
            points: '[[139.7,35.6],[139.8,35.7]]',
            strokeColor: 'red',
            lineWidth: 2,
          ),
        },
        images: {
          AppleMapImage(
            url: 'http://example.com/image.png',
            width: 32,
            height: 32,
          ),
        },
      );

      final uri = Uri.parse('https://example.com${service.pathAndParams}');
      final params = uri.queryParameters;

      expect(
        params['overlays'],
        contains(
          '"points": "[[139.7,35.6],[139.8,35.7]]","strokeColor": "red","lineWidth": 2.0',
        ),
      );
      expect(
        params['images'],
        contains(
          '"url": "http://example.com/image.png","height": 32,"width": 32',
        ),
      );
    });

    test('overlays with all parameters', () {
      final service = AppleMapService(
        center: tokyoStation,
        teamId: teamId,
        keyId: keyId,
        signatureFunction: (inputUrl) => 'signature',
        overlays: {
          AppleMapOverlay(
            points: 'points_data',
            strokeColor: 'blue',
            lineWidth: 3,
            lineDashPhase: 1,
            lineDashPattern: [2, 3],
            fillColor: 'green',
          ),
        },
      );

      final uri = Uri.parse('https://example.com${service.pathAndParams}');
      final params = uri.queryParameters;

      expect(
        params['overlays'],
        contains(
          '"points": "points_data","strokeColor": "blue","lineWidth": 3.0,"lineDashPhase": 1.0,"lineDashPattern": [2.0,3.0],"fillColor": "green"',
        ),
      );
    });

    test('AppleMapAnnotation minimal', () {
      final annotation = AppleMapAnnotation(
        point: MapLatLng(latitude: 0, longitude: 0),
      );
      expect(
        annotation.query,
        '{"point": "0.0000,0.0000","markerStyle": "balloon"}',
      );
    });

    test('AppleMapOverlay minimal', () {
      final overlay = AppleMapOverlay(points: 'minimal');
      expect(overlay.query, '{"points": "minimal"}');
    });

    test('AppleMapImage minimal', () {
      final image = AppleMapImage(url: 'url');
      expect(image.query, '{"url": "url"}');
    });

    test('AppleMapService.auto all parameters', () {
      final service = AppleMapService.auto(
        teamId: 'team_id',
        keyId: 'key_id',
        signatureFunction: (inputUrl) => 'signature',
        annotations: {
          AppleMapAnnotation(point: MapLatLng(latitude: 0, longitude: 0)),
        },
        overlays: {AppleMapOverlay(points: 'p')},
        images: {AppleMapImage(url: 'u')},
        lang: 'ja',
        referer: 'r',
        expires: 1,
      );

      final uri = Uri.parse('https://example.com${service.pathAndParams}');
      expect(uri.queryParameters['annotations'], isNotNull);
      expect(uri.queryParameters['overlays'], isNotNull);
      expect(uri.queryParameters['images'], isNotNull);
      expect(uri.queryParameters['lang'], 'ja');
    });

    test('default values are omitted from url', () {
      final service = AppleMapService(
        teamId: 'team',
        keyId: 'key',
        signatureFunction: (u) => 's',
        center: tokyoStation,
        // zoom: 12, size: auto, scale: 1, poi: true, lang: en-US, mapType: standard are defaults
      );
      final url = service.url;
      expect(url, isNot(contains('zoom=')));
      expect(url, isNot(contains('size=')));
      expect(url, isNot(contains('scale=')));
      expect(url, isNot(contains('poi=')));
      expect(url, isNot(contains('lang=')));
      expect(url, isNot(contains('t=')));
    });

    test('all optional parameters', () {
      final service = AppleMapService(
        teamId: 'team_id',
        keyId: 'key_id',
        signatureFunction: (inputUrl) => 'signature',
        center: const MapAddress('San Francisco'),
        zoom: 15,
        span: MapLatLng(latitude: 0.01, longitude: 0.01),
        size: AppleMapSize(width: 500, height: 300),
        scale: 2,
        mapType: AppleMapType.satellite,
        colorScheme: AppleMapColorScheme.dark,
        poi: false,
        lang: 'ja-JP',
        referer: 'http://example.com',
        expires: 1234567890,
      );

      final uri = Uri.parse('https://example.com${service.pathAndParams}');
      final params = uri.queryParameters;

      expect(params['center'], 'San Francisco');
      expect(params['zoom'], '15');
      expect(params['span'], '0.0100,0.0100');
      expect(params['size'], '500,300');
      expect(params['scale'], '2');
      expect(params['t'], 'satellite');
      expect(params['colorScheme'], 'dark');
      expect(params['poi'], '0');
      expect(params['lang'], 'ja-JP');
      expect(params['referer'], 'http://example.com');
      expect(params['expires'], '1234567890');
    });

    test('AppleMapService.auto constructor', () {
      final service = AppleMapService.auto(
        teamId: 'team_id',
        keyId: 'key_id',
        signatureFunction: (inputUrl) => 'signature',
        annotations: {
          AppleMapAnnotation(point: MapLatLng(latitude: 0, longitude: 0)),
        },
      );

      expect(service.center.query, 'auto');
    });

    test('AppleMapAnnotation with complex options', () {
      final annotation = AppleMapAnnotation(
        point: MapLatLng(latitude: 1, longitude: 2),
        markerStyle: AppleMapAnnotationStyle.large,
        color: const AppleMapAnnotationColor('red'),
        glyphColor: const AppleMapAnnotationColor('white'),
        glyphText: 'A',
        offset: AppleMapAnnotationOffset(x: 10, y: 20),
      );

      expect(annotation.query, contains('"markerStyle": "large"'));
      expect(annotation.query, contains('"color": "red"'));
      expect(annotation.query, contains('"glyphColor": "white"'));
      expect(annotation.query, contains('"glyphText": "A"'));
      expect(annotation.query, contains('"offset": "10,20"'));
    });

    test('AppleMapAnnotation with glyphImgIdx and imgIdx', () {
      final annotation = AppleMapAnnotation(
        point: MapLatLng(latitude: 1, longitude: 2),
        glyphImgIdx: 1,
        imgIdx: 2,
      );

      expect(annotation.query, contains('"glyphImgIdx": 1'));
      expect(annotation.query, contains('"imgIdx": 2'));
    });

    test('queryParameters covers all optional fields', () {
      final service = AppleMapService(
        teamId: teamId,
        keyId: keyId,
        signatureFunction: (inputUrl) => 'signature',
        center: tokyoStation,
        colorScheme: AppleMapColorScheme.dark,
        annotations: {
          AppleMapAnnotation(point: tokyoStation),
        },
        overlays: {
          AppleMapOverlay(points: 'p'),
        },
        images: {
          AppleMapImage(url: 'u'),
        },
      );

      final params = service.queryParameters;
      expect(params['colorScheme'], 'dark');
      expect(params['annotations'], isNotNull);
      expect(params['overlays'], isNotNull);
      expect(params['images'], isNotNull);
      expect(params['signature'], 'signature');
    });
  });
}
