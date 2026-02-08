import 'package:static_map_service/src/service.dart';
import 'package:static_map_service/src/shared.dart';
import 'package:static_map_service/src/utils.dart';

/// Mapbox Static Images API service.
///
/// This service generates URLs for Mapbox static images.
/// It supports custom styles and various overlays (markers, paths, GeoJSON).
///
/// See: [Mapbox Static Images API](https://docs.mapbox.com/api/maps/static-images/)
final class MapboxMapService extends MapService {
  /// Creates a [MapboxMapService] centered on a specific [center] point.
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

  /// Creates a [MapboxMapService] that automatically fits the map to the
  /// provided [overlays].
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

  /// Mapbox Access Token.
  final String accessToken;

  /// The username of the style owner. Defaults to 'mapbox'.
  final String username;

  /// The style ID. Defaults to 'streets-v11'.
  final String styleId;

  /// The overlays (markers, paths, GeoJSON) to display on the map.
  final List<MapboxMapOverlay> overlays;

  /// The center point of the map image.
  final MapLatLng? _center;

  /// The zoom level of the map.
  final double? _zoom;

  /// The bearing of the map (0-360).
  final double bearing;

  /// The pitch of the map (0-60).
  final double pitch;

  /// If true, the map position is automatically determined by the overlays.
  final bool _auto;

  /// The size of the map image in pixels.
  final MapboxMapSize size;

  /// If true, returns a high-resolution retina image (@2x).
  final bool retina;

  /// Whether to include the Mapbox logo.
  final bool logo;

  /// Whether to include the Mapbox attribution.
  final bool attribution;

  /// Padding around the auto-scaled map (e.g., '10,10,10,10').
  final String? padding;

  /// The ID of the layer to insert the overlay before.
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

/// The size of the Mapbox map image in pixels.
extension type const MapboxMapSize._(String query) {
  /// Creates a [MapboxMapSize] with [width] and [height].
  ///
  /// Max size is 1280x1280.
  factory MapboxMapSize({required int width, required int height}) {
    assert(width >= 1 && width <= 1280);
    assert(height >= 1 && height <= 1280);
    return MapboxMapSize._('${width}x$height');
  }
}

/// Base class for all Mapbox overlays.
extension type const MapboxMapOverlay(String query) {}

/// A marker overlay for Mapbox.
extension type const MapboxMarker._(String query) implements MapboxMapOverlay {
  /// Creates a [MapboxMarker].
  ///
  /// You can provide a [label], [color] (hex), [size], or a custom [url] for the icon.
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
      return MapboxMarker._('url-${Uri.encodeComponent(url)}($lon,$lat)');
    }

    final sb = StringBuffer('pin-${size.value}');
    if (label != null) sb.write('-$label');
    if (color != null) sb.write('+$color');
    sb.write('($lon,$lat)');
    return MapboxMarker._(sb.toString());
  }
}

/// Marker size presets for Mapbox.
enum MapboxMarkerSize {
  small('s'),
  medium('m'),
  large('l');

  const MapboxMarkerSize(this.value);

  /// The string value expected by the API.
  final String value;
}

/// A path (polyline) overlay for Mapbox.
extension type const MapboxPath._(String query) implements MapboxMapOverlay {
  /// Creates a [MapboxPath].
  ///
  /// [strokeColor] and [fillColor] should be hex strings without '#'.
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

/// A GeoJSON overlay for Mapbox.
extension type const MapboxGeoJson._(String query) implements MapboxMapOverlay {
  /// Creates a [MapboxGeoJson] overlay from a GeoJSON string.
  factory MapboxGeoJson({required String geoJson}) {
    return MapboxGeoJson._('geojson(${Uri.encodeComponent(geoJson)})');
  }
}
