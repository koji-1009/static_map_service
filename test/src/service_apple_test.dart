import 'package:static_map_service/src/service_apple.dart';
import 'package:static_map_service/src/shared.dart';
import 'package:test/test.dart';

void main() {
  group('A group of center', () {
    const teamId = 'team_id';
    const keyId = 'key_id';
    final tokyoStation = MapLatLng(
      latitude: 35.6812,
      longitude: 139.7671,
    );

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
            '"points": "[[139.7,35.6],[139.8,35.7]]","strokeColor": "red","lineWidth": 2.0'),
      );
      expect(
        params['images'],
        contains(
            '"url": "http://example.com/image.png","height": 32,"width": 32'),
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
            '"points": "points_data","strokeColor": "blue","lineWidth": 3.0,"lineDashPhase": 1.0,"lineDashPattern": [2.0,3.0],"fillColor": "green"'),
      );
    });
  });
}
