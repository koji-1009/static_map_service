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
    this.center,
    this.zoom,
    this.bearing = 0,
    this.pitch = 0,
    this.auto = false,
    required this.size,
    this.retina = false,
    this.logo = true,
    this.attribution = true,
    this.padding,
    this.beforeLayer,
  }) : assert(
         (auto && center == null && zoom == null) ||
             (!auto && center != null && zoom != null),
         'If auto is true, center and zoom must be null. If auto is false, center and zoom must be provided.',
       );

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
  final MapLocation? center;

  /// The zoom level of the map
  final double? zoom;

  /// The bearing of the map
  /// Default is 0
  final double bearing;

  /// The pitch of the map
  /// Default is 0
  final double pitch;

  /// If true, the map's position is automatically determined based on the overlays
  final bool auto;

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

    if (auto) {
      buffer.write('/auto');
    } else {
      // Mapbox uses lon,lat order
      if (center is MapLatLng) {
        final latLng = center as MapLatLng;
        buffer.write('/${latLng.longitude},${latLng.latitude}');
      } else {
        throw ArgumentError('Center must be MapLatLng for Mapbox service');
      }
      buffer.write(',$zoom,$bearing,$pitch');
    }

    buffer.write('/${size.query}');

    if (retina) {
      buffer.write('@2x');
    }

    return buffer.toString();
  }

  @override
  Map<String, String> get queryParameters {
    return {
      'access_token': accessToken,
      if (!logo) 'logo': 'false',
      if (!attribution) 'attribution': 'false',
      'padding': ?padding,
      'before_layer': ?beforeLayer,
    };
  }
}

extension type const MapboxMapSize._(String query) {
  factory MapboxMapSize({required int width, required int height}) {
    assert(width >= 1 && width <= 1280);
    assert(height >= 1 && height <= 1280);
    return MapboxMapSize._('${width}x$height');
  }
}

/// Base class for Mapbox overlays
abstract class MapboxMapOverlay {
  String get query;
}

/// Marker overlay
/// pin-s-label+color(lon,lat) or url-url(lon,lat)
class MapboxMarker implements MapboxMapOverlay {
  const MapboxMarker({
    required this.location,
    this.label,
    this.color,
    this.size = MapboxMarkerSize.small,
    this.url,
  });

  final MapLatLng location;
  final String? label; // symbol name or single character
  final String? color; // hex code without #
  final MapboxMarkerSize size;
  final String? url;

  @override
  String get query {
    final lon = location.longitude;
    final lat = location.latitude;

    if (url != null) {
      // url-{url}(lon,lat)
      return 'url-${Uri.encodeComponent(url!)}($lon,$lat)';
    } else {
      // pin-{size}-{label}+{color}(lon,lat)
      final sb = StringBuffer('pin-${size.value}');
      if (label != null) sb.write('-$label');
      if (color != null) sb.write('+$color');
      sb.write('($lon,$lat)');
      return sb.toString();
    }
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
class MapboxPath implements MapboxMapOverlay {
  const MapboxPath({
    required this.locations,
    this.strokeWidth = 1.0,
    this.strokeColor = '0000FF',
    this.strokeOpacity = 1.0,
    this.fillColor,
    this.fillOpacity = 0.0,
  });

  final List<MapLatLng> locations;
  final double strokeWidth;
  final String strokeColor; // hex without #
  final double strokeOpacity;
  final String? fillColor;
  final double fillOpacity;

  @override
  String get query {
    final polyline = Uri.encodeComponent(encodePolyline(locations));
    final sb = StringBuffer('path-$strokeWidth+$strokeColor-$strokeOpacity');
    if (fillColor != null) {
      sb.write('+$fillColor-$fillOpacity');
    }
    sb.write('($polyline)');
    return sb.toString();
  }
}

/// GeoJSON overlay
/// geojson({geojson})
class MapboxGeoJson implements MapboxMapOverlay {
  const MapboxGeoJson({required this.geoJson});

  final String geoJson;

  @override
  String get query {
    return 'geojson(${Uri.encodeComponent(geoJson)})';
  }
}
