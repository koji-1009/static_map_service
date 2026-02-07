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
          fillColor: const GoogleMapColor.blue(),
          weight: 5,
          geodesic: true,
        ),
        size: mapSize,
      );

      // _p~iF~ps|U_ulLnnqC_mqNvxq`@
      expect(
        service.url,
        contains(
          'path=weight%3A5%7Ccolor%3Ared%7Cfillcolor%3Ablue%7Cgeodesic%3Atrue%7Cenc%3A_p~iF~ps%7CU_ulLnnqC_mqNvxq%60%40',
        ),
      );
    });

    test('GoogleMapService.path constructor', () {
      final service = GoogleMapService.path(
        key: key,
        path: GoogleMapPath(locations: [tokyoStationLatLng]),
        size: mapSize,
      );
      expect(service.url, contains('path=35.6812%2C139.7671'));
    });

    test('GoogleMapFormat all values', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
        format: GoogleMapFormat.jpgBaseLine,
      );
      expect(service.url, contains('format=jpg-baseline'));
      expect(GoogleMapFormat.png32.value, 'png32');
      expect(GoogleMapFormat.gif.value, 'gif');
    });

    test('GoogleMapType all values', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
        maptype: GoogleMapType.terrain,
      );
      expect(service.url, contains('maptype=terrain'));
    });

    test('GoogleMapPath with complex options', () {
      final path = GoogleMapPath(
        locations: [tokyoStationLatLng],
        weight: 5,
        color: const GoogleMapColor.black(),
        fillColor: const GoogleMapColor.white(),
        geodesic: true,
      );
      expect(path.query, contains('weight:5'));
      expect(path.query, contains('color:black'));
      expect(path.query, contains('fillcolor:white'));
      expect(path.query, contains('geodesic:true'));
    });

    test('GoogleMapMarkers with more options', () {
      final marker = GoogleMapMarkers(
        locations: {tokyoStationLatLng},
        color: const GoogleMapColor.hex('aabbcc'),
      );
      expect(marker.query, contains('color:0xaabbcc'));
    });

    test('pathAndParams with all elements', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
        markers: {tokyoStationMarker},
        path: GoogleMapPath(locations: [tokyoStationLatLng]),
        viewports: GoogleMapViewports(locations: {tokyoStationLatLng}),
        styles: {GoogleMapStyle(rule: GoogleMapStyleRule.hue('ff0000'))},
      );

      final path = service.pathAndParams;
      expect(path, contains('markers='));
      expect(path, contains('path='));
      expect(path, contains('visible='));
      expect(path, contains('style='));
    });

    test('GoogleMapService.markers constructor', () {
      final service = GoogleMapService.markers(
        key: key,
        markers: {tokyoStationMarker},
        size: mapSize,
      );
      expect(service.queryParameters['markers'], contains('35.6812,139.7671'));
    });

    test('queryParameters with all elements', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
        markers: {tokyoStationMarker},
        path: GoogleMapPath(locations: [tokyoStationLatLng]),
        viewports: GoogleMapViewports(locations: {tokyoStationLatLng}),
        styles: {GoogleMapStyle(rule: GoogleMapStyleRule.hue('ff0000'))},
        signatureFunction: (p) => 'sig',
      );

      final params = service.queryParameters;
      expect(params['markers'], isNotNull);
      expect(params['path'], isNotNull);
      expect(params['visible'], isNotNull);
      expect(params['style'], isNotNull);
      expect(params['signature'], 'sig');
    });

    test('queryParameters without signature', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
      );
      expect(service.queryParameters['signature'], isNull);
    });

    test('GoogleMapMarkers minimal', () {
      final marker = GoogleMapMarkers(locations: {tokyoStationLatLng});
      expect(marker.query, '35.6812,139.7671');
    });

    test('complex styles and viewports', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
        language: 'ja',
        region: 'JP',
        mapId: 'test_map_id',
        viewports: GoogleMapViewports(locations: {tokyoStationLatLng}),
        styles: {
          GoogleMapStyle(
            feature: GoogleMapFeature.administrative(
              GoogleMapFeatureAdministrative.country,
            ),
            element: GoogleMapElement.geometry(GoogleMapElementGeometry.fill),
            rule: GoogleMapStyleRule.color('ff0000'),
          ),
        },
      );

      final url = Uri.decodeFull(service.url);
      expect(url, contains('language=ja'));
      expect(url, contains('region=JP'));
      expect(url, contains('map_id=test_map_id'));
      expect(url, contains('visible=35.6812,139.7671'));
      expect(
        url,
        contains(
          'style=feature:administrative.country|element:geometry.fill|color:#ff0000',
        ),
      );
    });

    test('all feature and element types', () {
      expect(GoogleMapFeature.all().query, 'feature:all');
      expect(
        GoogleMapFeature.administrative(
          GoogleMapFeatureAdministrative.locality,
        ).query,
        'feature:administrative.locality',
      );
      expect(
        GoogleMapFeature.administrative(
          GoogleMapFeatureAdministrative.landParcel,
        ).query,
        contains('land_parcel'),
      );
      expect(
        GoogleMapFeature.administrative(
          GoogleMapFeatureAdministrative.neighborhood,
        ).query,
        contains('neighborhood'),
      );
      expect(
        GoogleMapFeature.administrative(
          GoogleMapFeatureAdministrative.province,
        ).query,
        contains('province'),
      );
      expect(
        GoogleMapFeature.landscape(GoogleMapFeatureLandscape.manMade).query,
        'feature:landscape:man_made',
      );
      expect(
        GoogleMapFeature.poi(GoogleMapFeaturePoi.school).query,
        'feature:poi.school',
      );
      expect(
        GoogleMapFeature.poi(GoogleMapFeaturePoi.attraction).query,
        contains('attraction'),
      );
      expect(
        GoogleMapFeature.poi(GoogleMapFeaturePoi.business).query,
        contains('business'),
      );
      expect(
        GoogleMapFeature.poi(GoogleMapFeaturePoi.government).query,
        contains('government'),
      );
      expect(
        GoogleMapFeature.poi(GoogleMapFeaturePoi.medical).query,
        contains('medical'),
      );
      expect(
        GoogleMapFeature.poi(GoogleMapFeaturePoi.park).query,
        contains('park'),
      );
      expect(
        GoogleMapFeature.poi(GoogleMapFeaturePoi.placeOfWorship).query,
        contains('place_of_worship'),
      );
      expect(
        GoogleMapFeature.poi(GoogleMapFeaturePoi.sportsComplex).query,
        contains('sports_complex'),
      );
      expect(
        GoogleMapFeature.road(GoogleMapFeatureRoad.highway).query,
        'feature:road.highway',
      );
      expect(
        GoogleMapFeature.road(GoogleMapFeatureRoad.arterialRoad).query,
        contains('arterial'),
      );
      expect(
        GoogleMapFeature.road(
          GoogleMapFeatureRoad.highwayControlledAccess,
        ).query,
        contains('controlled_access'),
      );
      expect(
        GoogleMapFeature.road(GoogleMapFeatureRoad.localRoad).query,
        contains('local'),
      );
      expect(
        GoogleMapFeature.transit(GoogleMapFeatureTransit.stationRail).query,
        'feature:transit.station.rail',
      );
      expect(
        GoogleMapFeature.transit(GoogleMapFeatureTransit.line).query,
        contains('line'),
      );
      expect(
        GoogleMapFeature.transit(GoogleMapFeatureTransit.station).query,
        contains('station'),
      );
      expect(
        GoogleMapFeature.transit(GoogleMapFeatureTransit.stationAirport).query,
        contains('airport'),
      );
      expect(
        GoogleMapFeature.transit(GoogleMapFeatureTransit.stationBus).query,
        contains('bus'),
      );
      expect(GoogleMapFeature.water().query, 'feature:water');

      expect(GoogleMapElement.all().query, 'element:all');
      expect(
        GoogleMapElement.geometry(GoogleMapElementGeometry.stroke).query,
        'element:geometry.stroke',
      );
      expect(
        GoogleMapElement.labels(GoogleMapElementLabels.icon).query,
        'element:labels.icon',
      );
      expect(
        GoogleMapElement.labels(GoogleMapElementLabels.text).query,
        contains('labels.text'),
      );
      expect(
        GoogleMapElement.labels(GoogleMapElementLabels.textFill).query,
        contains('text.fill'),
      );
      expect(
        GoogleMapElement.labels(GoogleMapElementLabels.textStroke).query,
        contains('text.stroke'),
      );
    });

    test('all style rules', () {
      expect(GoogleMapStyleRule.hue('00ff00').query, 'hue:#00ff00');
      expect(GoogleMapStyleRule.lightness(50).query, 'lightness:50.0');
      expect(GoogleMapStyleRule.saturation(-50).query, 'saturation:-50.0');
      expect(GoogleMapStyleRule.gamma(2.0).query, 'gamma:2.0');
      expect(
        GoogleMapStyleRule.invertLightness().query,
        'invert_lightness:true',
      );
      expect(
        GoogleMapStyleRule.visibility(
          GoogleMapStyleRuleVisibility.simplified,
        ).query,
        'visibility:simplified',
      );
      expect(GoogleMapStyleRule.color('aabbcc').query, 'color:#aabbcc');
      expect(GoogleMapStyleRule.weight(2).query, 'weight:2');
    });

    test('GoogleMapStyle combinations', () {
      expect(
        GoogleMapStyle(feature: GoogleMapFeature.all()).query,
        'feature:all',
      );
      expect(
        GoogleMapStyle(element: GoogleMapElement.all()).query,
        'element:all',
      );
      expect(
        GoogleMapStyle(rule: GoogleMapStyleRule.hue('f00')).query,
        'hue:#f00',
      );
    });

    test('GoogleMapColor presets', () {
      expect(const GoogleMapColor.brown().name, 'brown');
      expect(const GoogleMapColor.green().name, 'green');
      expect(const GoogleMapColor.purple().name, 'purple');
      expect(const GoogleMapColor.yellow().name, 'yellow');
      expect(const GoogleMapColor.gray().name, 'gray');
      expect(const GoogleMapColor.orange().name, 'orange');
    });

    test('default values are omitted from url', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
        // scale: 1, format: png, maptype: roadmap are defaults
      );
      final url = service.url;
      expect(url, isNot(contains('scale=')));
      expect(url, isNot(contains('format=')));
      expect(url, isNot(contains('maptype=')));
    });

    test('GoogleMapSize types', () {
      expect(GoogleMapSize(width: 640, height: 640).query, '640x640');
      expect(GoogleMapSize.large(width: 2048, height: 2048).query, '2048x2048');
    });

    test('queryParameters with multiple markers and styles', () {
      final service = GoogleMapService.center(
        key: key,
        center: tokyoStationLatLng,
        zoom: zoom,
        size: mapSize,
        markers: {
          GoogleMapMarkers(locations: {tokyoStationLatLng}, label: '1'),
          GoogleMapMarkers(locations: {tokyoStationLatLng}, label: '2'),
        },
        styles: {
          GoogleMapStyle(feature: GoogleMapFeature.water()),
          GoogleMapStyle(
            feature: GoogleMapFeature.road(GoogleMapFeatureRoad.highway),
          ),
        },
      );

      final params = service.queryParameters;
      expect(params['markers'], contains('|'));
      expect(params['style'], contains('|'));
    });

    test('Assertion errors', () {
      expect(
        () => GoogleMapSize(width: 0, height: 400),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => GoogleMapSize.large(width: 2049, height: 2048),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => GoogleMapStyleRule.lightness(101),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => GoogleMapStyleRule.saturation(-101),
        throwsA(isA<AssertionError>()),
      );
      expect(() => GoogleMapStyleRule.gamma(0), throwsA(isA<AssertionError>()));
      expect(
        () => GoogleMapStyleRule.weight(-1),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
