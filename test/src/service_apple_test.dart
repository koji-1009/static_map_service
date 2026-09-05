import 'dart:convert';

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
        '[{"points":"[[139.7,35.6],[139.8,35.7]]","strokeColor":"red","lineWidth":2}]',
      );
      expect(
        params['imgs'],
        '[{"url":"http://example.com/image.png","height":32,"width":32}]',
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
            lineDashOffset: 1,
            lineDash: [2, 3],
            fillColor: 'green',
          ),
        },
      );

      final uri = Uri.parse('https://example.com${service.pathAndParams}');
      final params = uri.queryParameters;

      expect(
        params['overlays'],
        '[{"points":"points_data","strokeColor":"blue","lineWidth":3,'
        '"lineDashOffset":1,"lineDash":[2,3],"fillColor":"green"}]',
      );
    });

    test('AppleMapAnnotation minimal', () {
      final annotation = AppleMapAnnotation(
        point: MapLatLng(latitude: 0, longitude: 0),
      );
      expect(annotation.query, '{"point":"0,0","markerStyle":"balloon"}');
    });

    test('AppleMapOverlay minimal', () {
      final overlay = AppleMapOverlay(points: 'minimal');
      expect(overlay.query, '{"points":"minimal"}');
    });

    test('AppleMapImage minimal', () {
      final image = AppleMapImage(url: 'url');
      expect(image.query, '{"url":"url"}');
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
      expect(uri.queryParameters['imgs'], isNotNull);
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
      expect(url, isNot(contains('z=')));
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
      expect(params['z'], '15');
      expect(params['spn'], '0.01,0.01');
      expect(params['size'], '500x300');
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

      expect(annotation.query, contains('"markerStyle":"large"'));
      expect(annotation.query, contains('"color":"red"'));
      expect(annotation.query, contains('"glyphColor":"white"'));
      expect(annotation.query, contains('"glyphText":"A"'));
      expect(annotation.query, contains('"offset":"10,20"'));
    });

    test('Assertion errors for size and scale', () {
      expect(
        () => AppleMapSize(width: 49, height: 400),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => AppleMapSize(width: 641, height: 400),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => AppleMapSize(width: 400, height: 49),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => AppleMapSize(width: 400, height: 641),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => AppleMapService(
          teamId: 't',
          keyId: 'k',
          signatureFunction: (u) => 's',
          center: tokyoStation,
          scale: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => AppleMapService(
          teamId: 't',
          keyId: 'k',
          signatureFunction: (u) => 's',
          center: tokyoStation,
          scale: 4,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('null referer and expires are omitted', () {
      final service = AppleMapService(
        teamId: 't',
        keyId: 'k',
        signatureFunction: (u) => 's',
        center: tokyoStation,
        referer: null,
        expires: null,
      );

      final url = service.url;
      expect(url, isNot(contains('referer=')));
      expect(url, isNot(contains('expires=')));
    });

    test('AppleMapAnnotation with glyphImgIdx and imgIdx', () {
      final annotation = AppleMapAnnotation(
        point: MapLatLng(latitude: 1, longitude: 2),
        glyphImgIdx: 1,
        imgIdx: 2,
      );

      expect(annotation.query, contains('"glyphImgIdx":1'));
      expect(annotation.query, contains('"imgIdx":2'));
    });

    test('queryParameters covers all optional fields', () {
      final service = AppleMapService(
        teamId: teamId,
        keyId: keyId,
        signatureFunction: (inputUrl) => 'signature',
        center: tokyoStation,
        colorScheme: AppleMapColorScheme.dark,
        annotations: {AppleMapAnnotation(point: tokyoStation)},
        overlays: {AppleMapOverlay(points: 'p')},
        images: {AppleMapImage(url: 'u')},
      );

      final params = service.queryParameters;
      expect(params['colorScheme'], 'dark');
      expect(params['annotations'], isNotNull);
      expect(params['overlays'], isNotNull);
      expect(params['imgs'], isNotNull);
      expect(params['signature'], 'signature');
    });
  });

  group('A group of specification compliance', () {
    const teamId = 'team_id';
    const keyId = 'key_id';
    final tokyoStation = MapLatLng(latitude: 35.6812, longitude: 139.7671);

    test('zoom uses the "z" parameter name', () {
      final service = AppleMapService(
        teamId: teamId,
        keyId: keyId,
        signatureFunction: (u) => 's',
        center: tokyoStation,
        zoom: 15,
      );

      expect(service.queryParameters, containsPair('z', '15'));
      expect(service.queryParameters.containsKey('zoom'), isFalse);
    });

    test('span uses the "spn" parameter name', () {
      final service = AppleMapService(
        teamId: teamId,
        keyId: keyId,
        signatureFunction: (u) => 's',
        center: tokyoStation,
        span: MapLatLng(latitude: 0.5, longitude: 0.25),
      );

      expect(service.queryParameters, containsPair('spn', '0.5,0.25'));
      expect(service.queryParameters.containsKey('span'), isFalse);
    });

    test('images use the "imgs" parameter name', () {
      final service = AppleMapService(
        teamId: teamId,
        keyId: keyId,
        signatureFunction: (u) => 's',
        center: tokyoStation,
        images: {AppleMapImage(url: 'http://example.com/i.png')},
      );

      expect(service.queryParameters.containsKey('imgs'), isTrue);
      expect(service.queryParameters.containsKey('images'), isFalse);
    });

    test('size separates width and height with "x"', () {
      expect(AppleMapSize(width: 500, height: 300).query, '500x300');
      expect(AppleMapSize.auto.query, '600x400');
    });

    test('annotations are valid JSON when values contain quotes', () {
      final service = AppleMapService(
        teamId: teamId,
        keyId: keyId,
        signatureFunction: (u) => 's',
        center: tokyoStation,
        annotations: {
          AppleMapAnnotation(
            point: const MapAddress('Joe"s Diner'),
            glyphText: r'"}, "injected": "1',
          ),
        },
      );

      final decoded =
          jsonDecode(service.queryParameters['annotations']!) as List<dynamic>;

      expect(decoded, hasLength(1));
      final annotation = decoded.single as Map<String, dynamic>;
      expect(annotation['point'], 'Joe"s Diner');
      expect(annotation['glyphText'], r'"}, "injected": "1');
      expect(annotation.containsKey('injected'), isFalse);
    });

    test('overlays are valid JSON when values contain backslashes', () {
      final service = AppleMapService(
        teamId: teamId,
        keyId: keyId,
        signatureFunction: (u) => 's',
        center: tokyoStation,
        overlays: {AppleMapOverlay(points: r'a\b"c', strokeColor: r'#ff0000')},
      );

      final decoded =
          jsonDecode(service.queryParameters['overlays']!) as List<dynamic>;
      final overlay = decoded.single as Map<String, dynamic>;

      expect(overlay['points'], r'a\b"c');
      expect(overlay['strokeColor'], '#ff0000');
    });

    test('images are valid JSON when the url contains quotes', () {
      final service = AppleMapService(
        teamId: teamId,
        keyId: keyId,
        signatureFunction: (u) => 's',
        center: tokyoStation,
        images: {AppleMapImage(url: 'http://example.com/a"b.png', width: 32)},
      );

      final decoded =
          jsonDecode(service.queryParameters['imgs']!) as List<dynamic>;
      final image = decoded.single as Map<String, dynamic>;

      expect(image['url'], 'http://example.com/a"b.png');
      expect(image['width'], 32);
    });

    test('signature is the last query parameter', () {
      final service = AppleMapService(
        teamId: teamId,
        keyId: keyId,
        signatureFunction: (u) => 'sig',
        center: tokyoStation,
        expires: 1,
      );

      expect(service.url, endsWith('&signature=sig'));
    });
  });
}
