import 'package:static_map_service/src/service.dart';
import 'package:static_map_service/src/shared.dart';

/// Apple Maps Web Snapshots API service.
///
/// This service generates URLs for Apple Maps static snapshots.
/// It requires a [teamId], [keyId], and a [signatureFunction] for authentication.
///
/// See: [Apple Maps Web Snapshots API](https://developer.apple.com/documentation/snapshots)
final class AppleMapService extends MapService {
  /// Creates an [AppleMapService] with a specific [center] point.
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

  /// Creates an [AppleMapService] where the map's position is automatically
  /// determined based on the provided [annotations].
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

  /// Apple Developer Team ID.
  final String teamId;

  /// The Key ID for a key with the MapKit JS service enabled.
  final String keyId;

  /// Function to sign the request.
  ///
  /// See: [Generating a URL and Signature](https://developer.apple.com/documentation/snapshots/generating_a_url_and_signature_to_create_a_maps_web_snapshot)
  final SignatureFunction signatureFunction;

  /// The center point of the map image.
  ///
  /// Set to `'auto'` when using [AppleMapService.auto].
  final MapLocation center;

  /// The zoom level of the map (typically 0-20).
  final int zoom;

  /// A coordinate span that indicates how much of the map to display around the center.
  final MapLatLng? span;

  /// The size of the map image. Defaults to [AppleMapSize.auto] (600x400).
  final AppleMapSize size;

  /// The scale factor for the map image (1, 2, or 3).
  final int scale;

  /// The color scheme of the map.
  final AppleMapColorScheme colorScheme;

  /// Whether to show points of interest on the map.
  final bool poi;

  /// The language used for labels on the map (e.g., 'ja-JP').
  final String lang;

  /// The annotations to display on the map.
  final Set<AppleMapAnnotation> annotations;

  /// The type of map to display.
  final AppleMapType mapType;

  /// The referer string value to match against the request’s Referer header value.
  final String? referer;

  /// The time in seconds from epoch at which the request expires.
  final int? expires;

  /// The overlays (polylines/polygons) to display on the map.
  final Set<AppleMapOverlay> overlays;

  /// The custom images to display on the map.
  final Set<AppleMapImage> images;

  /// Builds the base query parameters for the request.
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

  /// The portion of the URL used for signature generation.
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

/// The color scheme of the map.
enum AppleMapColorScheme { light, dark }

/// The type of map to display.
enum AppleMapType { standard, satellite, hybrid }

/// Helper constant for the 'center' location.
const centerLocation = MapAddress('center');

/// The size of the map image in pixels.
extension type const AppleMapSize._(String query) {
  /// Creates a custom [AppleMapSize] with [width] and [height].
  ///
  /// Min size is 50x50, max is 640x640.
  factory AppleMapSize({required int width, required int height}) {
    assert(width >= 50 && width <= 640);
    assert(height >= 50 && height <= 640);

    return AppleMapSize._('$width,$height');
  }

  /// The default size (600x400).
  static const auto = AppleMapSize._('600x400');
}

/// An annotation to display on the map.
///
/// See: [Apple Maps Annotation](https://developer.apple.com/documentation/snapshots/annotation)
extension type const AppleMapAnnotation._(String query) {
  /// Creates an [AppleMapAnnotation].
  factory AppleMapAnnotation({
    /// The style of the annotation. Defaults to [AppleMapAnnotationStyle.balloon].
    AppleMapAnnotationStyle markerStyle = AppleMapAnnotationStyle.balloon,

    /// The location of the annotation.
    required MapLocation point,

    /// The color of the annotation (e.g., 'red', '#ff0000').
    AppleMapAnnotationColor? color,

    /// The tint color of the glyph.
    AppleMapAnnotationColor? glyphColor,

    /// The zero-based index of the glyph image.
    int? glyphImgIdx,

    /// A single alphanumeric character displayed inside the annotation.
    String? glyphText,

    /// The zero-based index of the image (required if markerStyle is img).
    int? imgIdx,

    /// An optional offset in scale independent pixels from the bottom center.
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

/// The style of the annotation.
enum AppleMapAnnotationStyle { dot, balloon, large, img }

/// A color representation for Apple Map annotations.
///
/// Supports HTML color names and hex color codes.
extension type const AppleMapAnnotationColor(String color) {}

/// An offset in scale independent pixels from the bottom center.
extension type const AppleMapAnnotationOffset._(String query) {
  /// Creates an [AppleMapAnnotationOffset] with [x] and [y] values.
  factory AppleMapAnnotationOffset({required int x, required int y}) =>
      AppleMapAnnotationOffset._('$x,$y');
}

/// An overlay (polyline or polygon) to display on the map.
///
/// See: [Apple Maps Overlay](https://developer.apple.com/documentation/snapshots/overlay)
extension type const AppleMapOverlay._(String query) {
  /// Creates an [AppleMapOverlay].
  ///
  /// [points] is a string representation of coordinate points.
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

/// An image to display on the map.
///
/// See: [Apple Maps Image](https://developer.apple.com/documentation/snapshots/image)
extension type const AppleMapImage._(String query) {
  /// Creates an [AppleMapImage].
  factory AppleMapImage({required String url, int? height, int? width}) {
    final parts = [
      '"url": "$url"',
      if (height != null) '"height": $height',
      if (width != null) '"width": $width',
    ];

    return AppleMapImage._('{${parts.join(',')}}');
  }
}
