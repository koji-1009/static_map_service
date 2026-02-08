import 'package:static_map_service/src/service.dart';
import 'package:static_map_service/src/shared.dart';
import 'package:static_map_service/src/utils.dart';

/// Google Maps Static API service.
///
/// This service generates URLs for Google Maps static images.
/// It supports various usage patterns via its factory constructors.
///
/// See: [Google Maps Static API](https://developers.google.com/maps/documentation/maps-static/start)
final class GoogleMapService extends MapService {
  /// Creates a [GoogleMapService] centered on a specific [center] point.
  ///
  /// Requires [key], [center], [zoom], and [size].
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
    Set<GoogleMapStyle>? styles,
  }) : _center = center,
       _zoom = zoom,
       _markers = markers ?? const {},
       _path = path ?? GoogleMapPath._empty,
       _viewports = viewports ?? GoogleMapViewports._empty,
       _styles = styles ?? const {},
       assert(zoom >= 0 && zoom <= 21),
       assert(scale == 1 || scale == 2);

  /// Creates a [GoogleMapService] that automatically fits the map to the
  /// provided [markers].
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
    Set<GoogleMapStyle>? styles,
  }) : _markers = markers,
       _center = center,
       _zoom = zoom,
       _path = path ?? GoogleMapPath._empty,
       _viewports = viewports ?? GoogleMapViewports._empty,
       _styles = styles ?? const {},
       assert(zoom == null || (zoom >= 0 && zoom <= 21)),
       assert(scale == 1 || scale == 2);

  /// Creates a [GoogleMapService] that automatically fits the map to the
  /// provided [path].
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
    Set<GoogleMapStyle>? styles,
  }) : _path = path,
       _markers = markers ?? const {},
       _center = center,
       _zoom = zoom,
       _viewports = viewports ?? GoogleMapViewports._empty,
       _styles = styles ?? const {},
       assert(zoom == null || (zoom >= 0 && zoom <= 21)),
       assert(scale == 1 || scale == 2);

  /// Google Maps Static API key.
  ///
  /// See: [Get an API Key](https://developers.google.com/maps/documentation/maps-static/get-api-key)
  final String key;

  /// Function to sign the request.
  ///
  /// Required if you have enabled digital signatures for your API key.
  /// See: [Digital Signatures](https://developers.google.com/maps/documentation/maps-static/digital-signature)
  final SignatureFunction? signatureFunction;

  /// The center point of the map image.
  final MapLocation? _center;

  /// The zoom level of the map (0-21).
  final int? _zoom;

  /// The size of the map image.
  final GoogleMapSize size;

  /// The scale factor for the map image (1 or 2).
  final int scale;

  /// The format of the resulting image.
  final GoogleMapFormat format;

  /// The type of map to display.
  final GoogleMapType maptype;

  /// The language to display the map in (e.g., 'ja').
  final String? language;

  /// The region code (two-character ccTLD value).
  final String? region;

  /// The Map ID for advanced styling.
  final String? mapId;

  /// The markers to display on the map.
  final Set<GoogleMapMarkers> _markers;

  /// The path to display on the map.
  final GoogleMapPath _path;

  /// The area to display on the map.
  final GoogleMapViewports _viewports;

  /// Custom styling rules for the map.
  final Set<GoogleMapStyle> _styles;

  /// Builds the query parameters for the request.
  Map<String, dynamic> get _params => {
    if (_center != null) 'center': _center!.query,
    if (_zoom != null) 'zoom': '$_zoom',
    'size': size.query,
    if (scale != 1) 'scale': '$scale',
    if (format != GoogleMapFormat.png) 'format': format.value,
    if (maptype != GoogleMapType.roadmap) 'maptype': maptype.name,
    'language': ?language,
    'region': ?region,
    'map_id': ?mapId,
    if (_markers.isNotEmpty) 'markers': _markers.map((e) => e.query),
    if (_path.isNotEmpty) 'path': _path.query,
    if (_viewports.isNotEmpty) 'visible': _viewports.query,
    if (_styles.isNotEmpty) 'style': _styles.map((e) => e.query),
    'key': key,
  };

  /// The portion of the URL used for signature generation.
  String get pathAndParams {
    final uri = Uri(path: unencodedPath, queryParameters: _params);
    return uri.toString();
  }

  @override
  String get authority => 'maps.googleapis.com';

  @override
  String get unencodedPath => '/maps/api/staticmap';

  @override
  Map<String, dynamic> get queryParameters {
    final signature = signatureFunction?.call(pathAndParams);
    return {..._params, 'signature': ?signature};
  }
}

/// The format of the resulting image.
enum GoogleMapFormat {
  png('png'),
  png32('png32'),
  gif('gif'),
  jpg('jpg'),
  jpgBaseLine('jpg-baseline');

  const GoogleMapFormat(this.value);

  /// The string value expected by the API.
  final String value;
}

/// The type of map to display.
enum GoogleMapType { roadmap, satellite, hybrid, terrain }

/// The size of the map image in pixels.
extension type const GoogleMapSize._(String query) {
  /// Creates a standard [GoogleMapSize]. Max size is 640x640.
  factory GoogleMapSize({required int width, required int height}) {
    assert(width > 0 && width <= 640);
    assert(height > 0 && height <= 640);

    return GoogleMapSize._('${width}x$height');
  }

  /// Creates a large [GoogleMapSize] (for Premium Plan or higher). Max size is 2048x2048.
  factory GoogleMapSize.large({required int width, required int height}) {
    assert(width > 0 && width <= 2048);
    assert(height > 0 && height <= 2048);

    return GoogleMapSize._('${width}x$height');
  }
}

/// A set of markers to display on the map.
///
/// See: [Google Maps Markers](https://developers.google.com/maps/documentation/maps-static/start#Markers)
extension type const GoogleMapMarkers._(String query) {
  /// Creates a set of [GoogleMapMarkers] with a shared style.
  factory GoogleMapMarkers({
    required Set<MapLocation> locations,
    GoogleMapMarkerSize? size,
    GoogleMapColor? color,
    String? label,
  }) => GoogleMapMarkers._(
    [
      if (size != null) 'size:${size.name}',
      if (color != null) 'color:${color.name}',
      if (label != null) 'label:$label',
      ...locations.map((e) => e.query),
    ].join('|'),
  );
}

/// A path (polyline or polygon) to display on the map.
///
/// See: [Google Maps Paths](https://developers.google.com/maps/documentation/maps-static/start#Paths)
extension type const GoogleMapPath._(String query) {
  /// Creates a [GoogleMapPath] from a list of locations.
  factory GoogleMapPath({
    required List<MapLocation> locations,
    int? weight,
    GoogleMapColor? color,
    GoogleMapColor? fillColor,
    bool geodesic = false,
  }) => GoogleMapPath._(
    [
      if (weight != null) 'weight:$weight',
      if (color != null) 'color:${color.name}',
      if (fillColor != null) 'fillcolor:${fillColor.name}',
      if (geodesic) 'geodesic:true',
      ...locations.map((e) => e.query),
    ].join('|'),
  );

  /// Creates a [GoogleMapPath] using an encoded polyline string.
  factory GoogleMapPath.encoded({
    required List<MapLatLng> locations,
    int? weight,
    GoogleMapColor? color,
    GoogleMapColor? fillColor,
    bool geodesic = false,
  }) {
    final List<String> parts = [
      if (weight != null) 'weight:$weight',
      if (color != null) 'color:${color.name}',
      if (fillColor != null) 'fillcolor:${fillColor.name}',
      if (geodesic) 'geodesic:true',
      'enc:${encodePolyline(locations)}',
    ];
    return GoogleMapPath._(parts.join('|'));
  }

  static const _empty = GoogleMapPath._('');

  /// Whether the path is not empty.
  bool get isNotEmpty => query.isNotEmpty;
}

/// A set of locations to be visible on the map.
extension type const GoogleMapViewports._(String query) {
  /// Creates a [GoogleMapViewports] that ensures all [locations] are visible.
  factory GoogleMapViewports({Set<MapLocation> locations = const {}}) =>
      GoogleMapViewports._(locations.map((e) => e.query).join('|'));

  static const _empty = GoogleMapViewports._('');

  /// Whether the viewport set is not empty.
  bool get isNotEmpty => query.isNotEmpty;
}

/// Custom styling rule for a map element.
///
/// See: [Google Maps Styling](https://developers.google.com/maps/documentation/maps-static/styling)
extension type const GoogleMapStyle._(String query) {
  /// Creates a [GoogleMapStyle] rule.
  factory GoogleMapStyle({
    GoogleMapFeature? feature,
    GoogleMapElement? element,
    GoogleMapStyleRule? rule,
  }) => GoogleMapStyle._(
    [
      if (feature != null) feature.query,
      if (element != null) element.query,
      if (rule != null) rule.query,
    ].join('|'),
  );
}

/// Features to style on the map.
extension type const GoogleMapFeature._(String query) {
  /// Selects all features.
  factory GoogleMapFeature.all() => const GoogleMapFeature._('feature:all');

  /// Selects administrative features.
  factory GoogleMapFeature.administrative(
    GoogleMapFeatureAdministrative type,
  ) => GoogleMapFeature._('feature:${type.value}');

  /// Selects landscape features.
  factory GoogleMapFeature.landscape(GoogleMapFeatureLandscape type) =>
      GoogleMapFeature._('feature:${type.value}');

  /// Selects points of interest.
  factory GoogleMapFeature.poi(GoogleMapFeaturePoi type) =>
      GoogleMapFeature._('feature:${type.value}');

  /// Selects road features.
  factory GoogleMapFeature.road(GoogleMapFeatureRoad type) =>
      GoogleMapFeature._('feature:${type.value}');

  /// Selects transit features.
  factory GoogleMapFeature.transit(GoogleMapFeatureTransit type) =>
      GoogleMapFeature._('feature:${type.value}');

  /// Selects water features.
  factory GoogleMapFeature.water() => const GoogleMapFeature._('feature:water');
}

/// Administrative feature types.
enum GoogleMapFeatureAdministrative {
  none('administrative'),
  country('administrative.country'),
  landParcel('administrative.land_parcel'),
  locality('administrative.locality'),
  neighborhood('administrative.neighborhood'),
  province('administrative.province');

  const GoogleMapFeatureAdministrative(this.value);
  final String value;
}

/// Landscape feature types.
enum GoogleMapFeatureLandscape {
  none('landscape'),
  manMade('landscape:man_made'),
  natural('landscape:natural'),
  naturalLandcover('landscape:natural.landcover'),
  naturalTerrain('landscape:natural.terrain');

  const GoogleMapFeatureLandscape(this.value);
  final String value;
}

/// Point of interest feature types.
enum GoogleMapFeaturePoi {
  none('poi'),
  attraction('poi.attraction'),
  business('poi.business'),
  government('poi.government'),
  medical('poi.medical'),
  park('poi.park'),
  placeOfWorship('poi.place_of_worship'),
  school('poi.school'),
  sportsComplex('poi.sports_complex');

  const GoogleMapFeaturePoi(this.value);
  final String value;
}

/// Road feature types.
enum GoogleMapFeatureRoad {
  none('road'),
  arterialRoad('road.arterial'),
  highway('road.highway'),
  highwayControlledAccess('road.highway.controlled_access'),
  localRoad('road.local');

  const GoogleMapFeatureRoad(this.value);
  final String value;
}

/// Transit feature types.
enum GoogleMapFeatureTransit {
  none('transit'),
  line('transit.line'),
  station('transit.station'),
  stationAirport('transit.station.airport'),
  stationBus('transit.station.bus'),
  stationRail('transit.station.rail');

  const GoogleMapFeatureTransit(this.value);
  final String value;
}

/// Map elements to style.
extension type const GoogleMapElement._(String query) {
  /// Selects all elements.
  factory GoogleMapElement.all() => const GoogleMapElement._('element:all');

  /// Selects geometry elements.
  factory GoogleMapElement.geometry(GoogleMapElementGeometry type) =>
      GoogleMapElement._('element:${type.value}');

  /// Selects label elements.
  factory GoogleMapElement.labels(GoogleMapElementLabels type) =>
      GoogleMapElement._('element:${type.value}');
}

/// Geometry element types.
enum GoogleMapElementGeometry {
  none('geometry'),
  fill('geometry.fill'),
  stroke('geometry.stroke');

  const GoogleMapElementGeometry(this.value);
  final String value;
}

/// Label element types.
enum GoogleMapElementLabels {
  none('labels'),
  icon('labels.icon'),
  text('labels.text'),
  textFill('labels.text.fill'),
  textStroke('labels.text.stroke');

  const GoogleMapElementLabels(this.value);
  final String value;
}

/// Styling rules to apply.
extension type const GoogleMapStyleRule._(String query) {
  /// Sets the hue.
  factory GoogleMapStyleRule.hue(String rgb) =>
      GoogleMapStyleRule._('hue:#$rgb');

  /// Sets the lightness (-100 to 100).
  factory GoogleMapStyleRule.lightness(double value) {
    assert(value >= -100 && value <= 100);
    return GoogleMapStyleRule._('lightness:$value');
  }

  /// Sets the saturation (-100 to 100).
  factory GoogleMapStyleRule.saturation(double value) {
    assert(value >= -100 && value <= 100);
    return GoogleMapStyleRule._('saturation:$value');
  }

  /// Sets the gamma (0.01 to 10.0).
  factory GoogleMapStyleRule.gamma(double value) {
    assert(value >= 0.01 && value <= 10.0);
    return GoogleMapStyleRule._('gamma:$value');
  }

  /// Inverts the lightness.
  factory GoogleMapStyleRule.invertLightness() =>
      const GoogleMapStyleRule._('invert_lightness:true');

  /// Sets the visibility.
  factory GoogleMapStyleRule.visibility(GoogleMapStyleRuleVisibility type) =>
      GoogleMapStyleRule._('visibility:${type.value}');

  /// Sets the color (RGB hex).
  factory GoogleMapStyleRule.color(String rgb) =>
      GoogleMapStyleRule._('color:#$rgb');

  /// Sets the weight (>= 0).
  factory GoogleMapStyleRule.weight(int value) {
    assert(value >= 0);
    return GoogleMapStyleRule._('weight:$value');
  }
}

/// Visibility rule types.
enum GoogleMapStyleRuleVisibility {
  on('on'),
  off('off'),
  simplified('simplified');

  const GoogleMapStyleRuleVisibility(this.value);
  final String value;
}

/// Color presets and hex colors for Google Map markers and paths.
extension type const GoogleMapColor(String name) {
  /// Creates a color from a hex string (without #).
  const GoogleMapColor.hex(String hex) : name = '0x$hex';

  /// Black color.
  const GoogleMapColor.black() : name = 'black';

  /// Brown color.
  const GoogleMapColor.brown() : name = 'brown';

  /// Green color.
  const GoogleMapColor.green() : name = 'green';

  /// Purple color.
  const GoogleMapColor.purple() : name = 'purple';

  /// Yellow color.
  const GoogleMapColor.yellow() : name = 'yellow';

  /// Blue color.
  const GoogleMapColor.blue() : name = 'blue';

  /// Gray color.
  const GoogleMapColor.gray() : name = 'gray';

  /// Orange color.
  const GoogleMapColor.orange() : name = 'orange';

  /// Red color.
  const GoogleMapColor.red() : name = 'red';

  /// White color.
  const GoogleMapColor.white() : name = 'white';
}

/// Marker size presets.
enum GoogleMapMarkerSize { tiny, small, mid }
