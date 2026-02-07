import 'package:static_map_service/src/service.dart';
import 'package:static_map_service/src/shared.dart';
import 'package:static_map_service/src/utils.dart';

/// Mapbox Static Images API entity
///
/// see [https://docs.mapbox.com/api/maps/static-images/]
final class MapboxMapService extends MapService {
  const MapboxMapService({
    required this.accessToken,
    this.username = 'mapbox',
    this.styleId = 'streets-v11',
    this.overlays = const [],
    required MapLatLng center,
    required double zoom,
    this.bearing = 0,
    this.pitch = 0,
    required this.size,
    this.retina = false,
    this.logo = true,
    this.attribution = true,
    this.padding,
    this.beforeLayer,
  }) : _center = center,
       _zoom = zoom,
       _auto = false;

  const MapboxMapService.auto({
    required this.accessToken,
    this.username = 'mapbox',
    this.styleId = 'streets-v11',
    required this.overlays,
    this.bearing = 0,
    this.pitch = 0,
    required this.size,
    this.retina = false,
    this.logo = true,
    this.attribution = true,
    this.padding,
    this.beforeLayer,
  }) : _center = null,
       _zoom = null,
       _auto = true;

  /// Mapbox Access Token
  final String accessToken;

  /// The username of the style owner
  /// Default is 'mapbox'
  final String username;

  /// The style ID
  /// Default is 'streets-v11'
  final String styleId;

  /// The overlays to display on the map
  final List<MapboxMapOverlay> overlays;

  /// The center point of the map image
  final MapLatLng? _center;

  /// The zoom level of the map
  final double? _zoom;

  /// The bearing of the map
  /// Default is 0
  final double bearing;

  /// The pitch of the map
  /// Default is 0
  final double pitch;

  /// If true, the map's position is automatically determined based on the overlays
  final bool _auto;

  /// The size of the map image
  final MapboxMapSize size;

  /// If true, returns a retina image (@2x)
  final bool retina;

  /// If true, includes the Mapbox logo
  /// Default is true
  final bool logo;

  /// If true, includes the attribution
  /// Default is true
  final bool attribution;

  /// Padding around the auto-scaled map
  final String? padding;

  /// The ID of the layer to insert the overlay before
  final String? beforeLayer;

  @override
  String get authority => 'api.mapbox.com';

  @override
  String get unencodedPath {
    final buffer = StringBuffer('/styles/v1/$username/$styleId/static');

    if (overlays.isNotEmpty) {
      buffer.write('/${overlays.map((e) => e.query).join(',')}');
    }

    if (_auto) {
      buffer.write('/auto');
    }

    if (_center != null && _zoom != null) {
      buffer.write('/${_center.longitude},${_center.latitude}');
      buffer.write(',$_zoom,$bearing,$pitch');
    }

    buffer.write('/${size.query}');

    if (retina) {
      buffer.write('@2x');
    }

    return buffer.toString();
  }

  @override
  Map<String, String> get queryParameters => {
    'access_token': accessToken,
    if (!logo) 'logo': 'false',
    if (!attribution) 'attribution': 'false',
    'padding': ?padding,
    'before_layer': ?beforeLayer,
  };
}

extension type const MapboxMapSize._(String query) {
  factory MapboxMapSize({required int width, required int height}) {
    assert(width >= 1 && width <= 1280);
    assert(height >= 1 && height <= 1280);
    return MapboxMapSize._('${width}x$height');
  }
}

/// Base class for Mapbox overlays
extension type const MapboxMapOverlay(String query) {}

/// Marker overlay
/// pin-s-label+color(lon,lat) or url-url(lon,lat)
extension type const MapboxMarker._(String query) implements MapboxMapOverlay {
  factory MapboxMarker({
    required MapLatLng location,
    String? label,
    String? color,
    MapboxMarkerSize size = MapboxMarkerSize.small,
    String? url,
  }) {
    final lon = location.longitude;
    final lat = location.latitude;

    if (url != null) {
      // url-{url}(lon,lat)
      return MapboxMarker._('url-${Uri.encodeComponent(url)}($lon,$lat)');
    }

    // pin-{size}-label+color(lon,lat)
    final sb = StringBuffer('pin-${size.value}');
    if (label != null) sb.write('-$label');
    if (color != null) sb.write('+$color');
    sb.write('($lon,$lat)');
    return MapboxMarker._(sb.toString());
  }
}

enum MapboxMarkerSize {
  small('s'),
  medium('m'),
  large('l');

  final String value;
  const MapboxMarkerSize(this.value);
}

/// Path overlay
/// path-{strokeWidth}+{strokeColor}-{strokeOpacity}({polyline})
extension type const MapboxPath._(String query) implements MapboxMapOverlay {
  factory MapboxPath({
    required List<MapLatLng> locations,
    double strokeWidth = 1.0,
    String strokeColor = '0000FF',
    double strokeOpacity = 1.0,
    String? fillColor,
    double fillOpacity = 0.0,
  }) {
    final polyline = Uri.encodeComponent(encodePolyline(locations));
    final sb = StringBuffer('path-$strokeWidth+$strokeColor-$strokeOpacity');
    if (fillColor != null) {
      sb.write('+$fillColor-$fillOpacity');
    }
    sb.write('($polyline)');
    return MapboxPath._(sb.toString());
  }
}

/// GeoJSON overlay
/// geojson({geojson})
extension type const MapboxGeoJson._(String query) implements MapboxMapOverlay {
  factory MapboxGeoJson({required String geoJson}) {
    return MapboxGeoJson._('geojson(${Uri.encodeComponent(geoJson)})');
  }
}
