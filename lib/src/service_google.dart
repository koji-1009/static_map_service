import 'package:equatable/equatable.dart';
import 'package:static_map_service/static_map_service.dart';

/// Google Maps Static API entity
///
/// see [https://developers.google.com/maps/documentation/maps-static/start]
final class GoogleMapService extends MapService {
  const GoogleMapService.center({
    required this.key,
    this.signatureFunction,
    required MapLocation center,
    required int zoom,
    required this.size,
    this.scale = 1,
    this.format = GoogleMapFormat.png,
    this.maptype = GoogleMapType.roadmap,
    this.language,
    this.region,
    this.mapId,
    Set<GoogleMapMarkers>? markers,
    GoogleMapPath? path,
    GoogleMapViewports? viewports,
  })  : _center = center,
        _zoom = zoom,
        _markers = markers ?? const {},
        _path = path ?? const GoogleMapPath._empty(),
        _viewports = viewports ?? const GoogleMapViewports._empty(),
        assert(zoom >= 0 && zoom <= 21),
        assert(scale == 1 || scale == 2);

  const GoogleMapService.markers({
    required this.key,
    this.signatureFunction,
    required Set<GoogleMapMarkers> markers,
    required this.size,
    this.scale = 1,
    this.format = GoogleMapFormat.png,
    this.maptype = GoogleMapType.roadmap,
    this.language,
    this.region,
    this.mapId,
    MapLocation? center,
    int? zoom,
    GoogleMapPath? path,
    GoogleMapViewports? viewports,
  })  : _markers = markers,
        _center = center,
        _zoom = zoom,
        _path = path ?? const GoogleMapPath._empty(),
        _viewports = viewports ?? const GoogleMapViewports._empty(),
        assert(zoom == null || (zoom >= 0 && zoom <= 21)),
        assert(scale == 1 || scale == 2);

  const GoogleMapService.path({
    required this.key,
    this.signatureFunction,
    required GoogleMapPath path,
    required this.size,
    this.scale = 1,
    this.format = GoogleMapFormat.png,
    this.maptype = GoogleMapType.roadmap,
    this.language,
    this.region,
    this.mapId,
    MapLocation? center,
    int? zoom,
    Set<GoogleMapMarkers>? markers,
    GoogleMapViewports? viewports,
  })  : _path = path,
        _markers = markers ?? const {},
        _center = center,
        _zoom = zoom,
        _viewports = viewports ?? const GoogleMapViewports._empty(),
        assert(zoom == null || (zoom >= 0 && zoom <= 21)),
        assert(scale == 1 || scale == 2);

  /// Google Maps Static API key
  ///
  /// see [https://developers.google.com/maps/documentation/maps-static/get-api-key]
  final String key;

  /// Function to sign [pathAndParams]
  ///
  /// see [https://developers.google.com/maps/documentation/maps-static/digital-signature]
  final SignatureFunction? signatureFunction;

  /// The center point of the map image
  final MapLocation? _center;

  /// The zoom level of the map
  ///
  /// see [https://developers.google.com/maps/documentation/maps-static/start#Zoomlevels]
  final int? _zoom;

  /// The size of the map image
  final GoogleMapSize size;

  /// The scale factor for the map image
  /// Default is 1, only 1 or 2
  ///
  /// see [https://developers.google.com/maps/documentation/maps-static/start#scale_values]
  final int scale;

  /// The format of the resulting image
  /// Default is [GoogleMapFormat.png]
  final GoogleMapFormat format;

  /// The type of map to display
  /// Default is [GoogleMapType.roadmap]
  final GoogleMapType maptype;

  /// The language to display the map in
  final String? language;

  /// The region code, specified as a ccTLD ("top-level domain") two-character value
  final String? region;

  /// The Map ID associates a map with a particular style or feature,
  /// and must belong to the same project as the API key used to initialize the map
  ///
  /// see [https://developers.google.com/maps/documentation/get-map-id]
  final String? mapId;

  /// The markers to display on the map
  final Set<GoogleMapMarkers> _markers;

  /// The path to display on the map
  final GoogleMapPath _path;

  /// The area to display on the map
  final GoogleMapViewports _viewports;

  /// TODO: implement style
  /// see [https://developers.google.com/maps/documentation/maps-static/styling]

  /// The path and parameters for [signatureFunction]
  String get pathAndParams {
    final uri = Uri(
      path: unencodedPath,
      queryParameters: {
        if (_center != null) 'center': _center!.query,
        if (_zoom != null) 'zoom': '$_zoom',
        'size': size.query,
        if (scale != 1) 'scale': '$scale',
        if (format != GoogleMapFormat.png) 'format': format.value,
        if (maptype != GoogleMapType.roadmap) 'maptype': maptype.name,
        if (language != null) 'language': language!,
        if (region != null) 'region': region!,
        if (mapId != null) 'map_id': mapId!,
        if (_markers.isNotEmpty)
          for (final marker in _markers) 'markers': marker.query,
        if (_path.isNotEmpty) 'path': _path.query,
        if (_viewports.isNotEmpty) 'visible': _viewports.query,
        'key': key,
      },
    );

    return uri.toString();
  }

  @override
  String get authority => 'maps.googleapis.com';

  @override
  String get unencodedPath => '/maps/api/staticmap';

  @override
  Map<String, String> get queryParameters {
    final signature = signatureFunction?.call(pathAndParams) ?? '';

    return {
      if (_center != null) 'center': _center!.query,
      if (_zoom != null) 'zoom': '$_zoom',
      'size': size.query,
      if (scale != 1) 'scale': '$scale',
      if (format != GoogleMapFormat.png) 'format': format.name,
      if (maptype != GoogleMapType.roadmap) 'maptype': maptype.name,
      if (language != null) 'language': language!,
      if (region != null) 'region': region!,
      if (mapId != null) 'map_id': mapId!,
      if (_markers.isNotEmpty)
        for (final marker in _markers) 'markers': marker.query,
      if (_path.isNotEmpty) 'path': _path.query,
      if (_viewports.isNotEmpty) 'visible': _viewports.query,
      'key': key,
      if (signature.isNotEmpty) 'signature': signature,
    };
  }
}

/// see [https://developers.google.com/maps/documentation/maps-static/start#ImageFormats]
enum GoogleMapFormat {
  png('png'),
  png32('png32'),
  gif('gif'),
  jpg('jpg'),
  jpgBaseLine('jpg-baseline');

  const GoogleMapFormat(this.value);

  final String value;
}

/// see [https://developers.google.com/maps/documentation/maps-static/start#MapTypes]
enum GoogleMapType {
  roadmap,
  satellite,
  hybrid,
  terrain,
}

/// see [https://developers.google.com/maps/documentation/maps-static/start#Imagesizes]
class GoogleMapSize {
  const GoogleMapSize({
    required this.width,
    required this.height,
  })  : assert(width > 0 && width <= 640),
        assert(height > 0 && height <= 640);

  final int width;

  final int height;

  String get query => '${width}x$height';
}

/// see [https://developers.google.com/maps/documentation/maps-static/start#Largerimagesizes]
class GoogleLargeMapSize extends GoogleMapSize {
  const GoogleLargeMapSize({
    required super.width,
    required super.height,
  })  : assert(width > 0 && width <= 2048),
        assert(height > 0 && height <= 2048);
}

/// see [https://developers.google.com/maps/documentation/maps-static/start#Markers]
class GoogleMapMarkers with EquatableMixin {
  const GoogleMapMarkers({
    required this.locations,
    this.size,
    this.color,
    this.label,
  });

  final Set<MapLocation> locations;

  final GoogleMapMarkerSize? size;

  final GoogleMapColor? color;

  final String? label;

  String get query => <String>[
        if (size != null) 'size:${size?.name}',
        if (color != null) 'color:${color?.name}',
        if (label != null) 'label:$label',
        ...locations.map((e) => e.query),
      ].join('|');

  @override
  List<Object?> get props => [locations, size, color, label];
}

/// see [https://developers.google.com/maps/documentation/maps-static/start#Paths]
class GoogleMapPath {
  const GoogleMapPath({
    required this.locations,
    this.weight,
    this.color,
    this.fillColor,
    this.geodesic = false,
  });

  const GoogleMapPath._empty()
      : locations = const [],
        weight = null,
        color = null,
        fillColor = null,
        geodesic = false;

  final List<MapLocation> locations;

  final int? weight;

  final GoogleMapColor? color;

  final GoogleMapColor? fillColor;

  final bool geodesic;

  bool get isNotEmpty => locations.isNotEmpty;

  String get query => <String>[
        if (weight != null) 'weight:$weight',
        if (color != null) 'color:${color?.name}',
        if (fillColor != null) 'fillcolor:${fillColor?.name}',
        if (geodesic) 'geodesic:true',
        ...locations.map((e) => e.query),
      ].join('|');
}

/// see [https://developers.google.com/maps/documentation/maps-static/start#Viewports]
class GoogleMapViewports {
  const GoogleMapViewports({
    required this.locations,
  });

  const GoogleMapViewports._empty() : locations = const {};

  final Set<MapLocation> locations;

  bool get isNotEmpty => locations.isNotEmpty;

  String get query => locations.map((e) => e.query).join('|');
}

/// see [https://developers.google.com/maps/documentation/maps-static/start#MarkerStyles]
/// see [https://developers.google.com/maps/documentation/maps-static/start#PathStyles]
sealed class GoogleMapColor with EquatableMixin {
  const GoogleMapColor();

  String get name;

  @override
  List<Object?> get props => [name];
}

class GoogleMapColorHex extends GoogleMapColor {
  const GoogleMapColorHex(this.hex);

  final String hex;

  @override
  String get name => '0x$hex';
}

class GoogleMapColorBlack extends GoogleMapColor {
  const GoogleMapColorBlack();

  @override
  String get name => 'black';
}

class GoogleMapColorBrown extends GoogleMapColor {
  const GoogleMapColorBrown();

  @override
  String get name => 'brown';
}

class GoogleMapColorGreen extends GoogleMapColor {
  const GoogleMapColorGreen();

  @override
  String get name => 'green';
}

class GoogleMapColorPurple extends GoogleMapColor {
  const GoogleMapColorPurple();

  @override
  String get name => 'purple';
}

class GoogleMapColorYellow extends GoogleMapColor {
  const GoogleMapColorYellow();

  @override
  String get name => 'yellow';
}

class GoogleMapColorBlue extends GoogleMapColor {
  const GoogleMapColorBlue();

  @override
  String get name => 'blue';
}

class GoogleMapColorGray extends GoogleMapColor {
  const GoogleMapColorGray();

  @override
  String get name => 'gray';
}

class GoogleMapColorOrange extends GoogleMapColor {
  const GoogleMapColorOrange();

  @override
  String get name => 'orange';
}

class GoogleMapColorRed extends GoogleMapColor {
  const GoogleMapColorRed();

  @override
  String get name => 'red';
}

class GoogleMapColorWhite extends GoogleMapColor {
  const GoogleMapColorWhite();

  @override
  String get name => 'white';
}

/// see [https://developers.google.com/maps/documentation/maps-static/start#MarkerStyles]
enum GoogleMapMarkerSize {
  tiny,
  small,
  mid,
}
