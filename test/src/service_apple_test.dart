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
  });
}
