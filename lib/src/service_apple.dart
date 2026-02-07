import 'package:static_map_service/src/service.dart';
import 'package:static_map_service/src/shared.dart';

/// Apple Maps Web Snapshots API entity
///
/// see [https://developer.apple.com/documentation/snapshots]
final class AppleMapService extends MapService {
  const AppleMapService({
    required this.teamId,
    required this.keyId,
    required this.signatureFunction,
    required this.center,
    this.zoom = 12,
    this.span,
    this.size = AppleMapSize.auto,
    this.scale = 1,
    this.mapType = AppleMapType.standard,
    this.colorScheme = AppleMapColorScheme.light,
    this.poi = true,
    this.lang = 'en-US',
    this.annotations = const {},
    this.overlays = const {},
    this.images = const {},
    this.referer,
    this.expires,
  }) : assert(scale >= 1 && scale <= 3);

  const AppleMapService.auto({
    required this.teamId,
    required this.keyId,
    required this.signatureFunction,
    required this.annotations,
    this.zoom = 12,
    this.span,
    this.size = AppleMapSize.auto,
    this.scale = 1,
    this.mapType = AppleMapType.standard,
    this.colorScheme = AppleMapColorScheme.light,
    this.poi = true,
    this.lang = 'en-US',
    this.overlays = const {},
    this.images = const {},
    this.referer,
    this.expires,
  }) : center = const MapAddress('auto');

  /// Apple Developer Team ID
  final String teamId;

  /// The Key ID for a key with the MapKit JS service enabled
  final String keyId;

  /// Function to sign [pathAndParams]
  ///
  /// see [https://developer.apple.com/documentation/snapshots/generating_a_url_and_signature_to_create_a_maps_web_snapshot]
  final SignatureFunction signatureFunction;

  /// The center point of the map image
  final MapLocation center;

  /// The zoom level of the map
  final int zoom;

  /// A comma-separated coordinate span that indicates how much of
  /// the map Web Map Snapshots API displays around the map’s center
  final MapLatLng? span;

  /// The size of the map image
  /// Default is 600x400
  final AppleMapSize size;

  /// The scale factor for the map image
  final int scale;

  /// The color scheme of the map (light or dark)
  final AppleMapColorScheme colorScheme;

  /// A Boolean value that indicates whether to show points of interest on the map
  /// Default is true
  final bool poi;

  /// The language that Maps Web Snapshots API uses for labels on the map
  final String lang;

  /// The annotations to display on the map
  final Set<AppleMapAnnotation> annotations;

  /// The type of map to display
  ///
  /// see [AppleMapType]
  final AppleMapType mapType;

  /// The referer string value to match against the request’s Referer header value
  final String? referer;

  /// The time in seconds from epoch at which the request expires
  final int? expires;

  /// The overlays to display on the map
  final Set<AppleMapOverlay> overlays;

  /// The images to display on the map
  final Set<AppleMapImage> images;

  Map<String, String> get _params => {
    'center': center.query,
    'teamId': teamId,
    'keyId': keyId,
    if (zoom != 12) 'zoom': '$zoom',
    if (span != null) 'span': span!.query,
    if (size != AppleMapSize.auto) 'size': size.query,
    if (scale != 1) 'scale': '$scale',
    if (colorScheme != AppleMapColorScheme.light)
      'colorScheme': colorScheme.name,
    if (!poi) 'poi': '0',
    if (lang != 'en-US') 'lang': lang,
    if (annotations.isNotEmpty)
      'annotations':
          '[${annotations.map((annotation) => annotation.query).join(',')}]',
    if (overlays.isNotEmpty)
      'overlays': '[${overlays.map((overlay) => overlay.query).join(',')}]',
    if (images.isNotEmpty)
      'images': '[${images.map((image) => image.query).join(',')}]',
    if (mapType != AppleMapType.standard) 't': mapType.name,
    'referer': ?referer,
    if (expires != null) 'expires': '$expires',
  };

  String get pathAndParams =>
      Uri(path: unencodedPath, queryParameters: _params).toString();

  @override
  String get authority => 'snapshot.apple-mapkit.com';

  @override
  String get unencodedPath => '/api/v1/snapshot';

  @override
  Map<String, String> get queryParameters {
    final signature = signatureFunction(pathAndParams);
    return {..._params, if (signature.isNotEmpty) 'signature': signature};
  }
}

enum AppleMapColorScheme { light, dark }

enum AppleMapType { standard, satellite, hybrid }

/// The location of the map
const centerLocation = MapAddress('center');

extension type const AppleMapSize._(String query) {
  factory AppleMapSize({required int width, required int height}) {
    assert(width >= 50 && width <= 640);
    assert(height >= 50 && height <= 640);

    return AppleMapSize._('$width,$height');
  }

  static const auto = AppleMapSize._('600x400');
}

/// The annotation to display on the map
///
/// see [https://developer.apple.com/documentation/snapshots/annotation]
extension type const AppleMapAnnotation._(String query) {
  factory AppleMapAnnotation({
    /// The style of the annotation
    AppleMapAnnotationStyle markerStyle = AppleMapAnnotationStyle.balloon,

    /// The location of the annotation
    required MapLocation point,

    /// The color of the annotation
    AppleMapAnnotationColor? color,

    /// The tint color of the glyph
    AppleMapAnnotationColor? glyphColor,

    /// The zero-based index of the glyph image referenced in the array of
    /// images used for a specific annotation.
    ///
    /// Don’t set the `glyphText` property when using this property.
    /// If the annotation has a 'dot' or 'img' `markerStyle`,
    /// the Maps Web Snapshots API ignores this parameter.
    int? glyphImgIdx,

    /// A single alphanumeric character from the set {a-z, A-Z, 0-9},
    /// displayed inside the annotation.
    /// If the annotation has a 'dot' or 'img' `markerStyle`,
    /// the Maps Web Snapshots API ignores this parameter.
    String? glyphText,

    /// The zero-based index of the image referenced
    /// in the array of images to use for this annotation.
    /// The Maps Web Snapshots API requires this property if `markerStyle` is img.
    int? imgIdx,

    /// An optional offset in scale independent pixels of the image from the bottom center.
    /// The Maps Web Snapshots API ignores the `offset` property
    /// if `markerStyle` is dot, balloon, or large.
    AppleMapAnnotationOffset? offset,
  }) {
    final parts = [
      '"point": "${point.query}"',
      '"markerStyle": "${markerStyle.name}"',
      if (color != null) '"color": "${color.color}"',
      if (glyphColor != null) '"glyphColor": "${glyphColor.color}"',
      if (glyphImgIdx != null) '"glyphImgIdx": $glyphImgIdx',
      if (glyphText != null) '"glyphText": "$glyphText"',
      if (imgIdx != null) '"imgIdx": $imgIdx',
      if (offset != null) '"offset": "${offset.query}"',
    ];

    return AppleMapAnnotation._('{${parts.join(',')}}');
  }
}

/// The style of the annotation
enum AppleMapAnnotationStyle { dot, balloon, large, img }

/// Support HTML color names and hex color codes
extension type const AppleMapAnnotationColor(String color) {}

/// An optional offset in scale independent pixels of the image from the bottom center
extension type const AppleMapAnnotationOffset._(String query) {
  factory AppleMapAnnotationOffset({required int x, required int y}) =>
      AppleMapAnnotationOffset._('$x,$y');
}

/// The overlay to display on the map
///
/// see [https://developer.apple.com/documentation/snapshots/overlay]
extension type const AppleMapOverlay._(String query) {
  factory AppleMapOverlay({
    required String points,
    String? strokeColor,
    double? lineWidth,
    double? lineDashPhase,
    List<double>? lineDashPattern,
    String? fillColor,
  }) {
    final parts = [
      '"points": "$points"',
      if (strokeColor != null) '"strokeColor": "$strokeColor"',
      if (lineWidth != null) '"lineWidth": $lineWidth',
      if (lineDashPhase != null) '"lineDashPhase": $lineDashPhase',
      if (lineDashPattern != null)
        '"lineDashPattern": [${lineDashPattern.join(',')}]',
      if (fillColor != null) '"fillColor": "$fillColor"',
    ];

    return AppleMapOverlay._('{${parts.join(',')}}');
  }
}

/// The image to display on the map
///
/// see [https://developer.apple.com/documentation/snapshots/image]
extension type const AppleMapImage._(String query) {
  factory AppleMapImage({required String url, int? height, int? width}) {
    final parts = [
      '"url": "$url"',
      if (height != null) '"height": $height',
      if (width != null) '"width": $width',
    ];

    return AppleMapImage._('{${parts.join(',')}}');
  }
}
