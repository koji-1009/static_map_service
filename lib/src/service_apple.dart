import 'package:equatable/equatable.dart';
import 'package:static_map_service/src/service.dart';
import 'package:static_map_service/src/shared.dart';

/// Apple Maps Web Snapshots API entity
///
/// see [https://developer.apple.com/documentation/snapshots]
///
/// TODO: [https://developer.apple.com/documentation/snapshots/overlay]
/// TODO: [https://developer.apple.com/documentation/snapshots/image]
final class AppleMapService extends MapService {
  const AppleMapService({
    required this.teamId,
    required this.keyId,
    required this.signatureFunction,
    required this.center,
    this.zoom = 12,
    this.span,
    this.size = const AppleMapSize.auto(),
    this.scale = 1,
    this.mapType = AppleMapType.standard,
    this.colorScheme = AppleMapColorScheme.light,
    this.poi = true,
    this.lang = 'en-US',
    this.annotations = const {},
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
    this.size = const AppleMapSize.auto(),
    this.scale = 1,
    this.mapType = AppleMapType.standard,
    this.colorScheme = AppleMapColorScheme.light,
    this.poi = true,
    this.lang = 'en-US',
    this.referer,
    this.expires,
  }) : center = const MapAddress(
          address: 'auto',
        );

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

  String get pathAndParams {
    final uri = Uri(
      path: unencodedPath,
      queryParameters: {
        'center': center.query,
        'teamId': teamId,
        'keyId': keyId,
        if (zoom != 12) 'zoom': '$zoom',
        if (span != null) 'span': span!.query,
        if (size != AppleMapSize.auto()) 'size': size.query,
        if (scale != 1) 'scale': '$scale',
        if (colorScheme != AppleMapColorScheme.light)
          'colorScheme': colorScheme.name,
        if (!poi) 'poi': '0',
        if (lang != 'en-US') 'lang': lang,
        if (annotations.isNotEmpty)
          'annotations':
              '[${annotations.map((annotation) => annotation.query).join(',')}]',
        if (mapType != AppleMapType.standard) 't': mapType.name,
        if (referer != null) 'referer': referer!,
        if (expires != null) 'expires': '$expires',
      },
    );
    return uri.toString();
  }

  @override
  String get authority => 'snapshot.apple-mapkit.com';

  @override
  String get unencodedPath => '/api/v1/snapshot';

  @override
  Map<String, String> get queryParameters {
    final signature = signatureFunction(unencodedPath);

    return {
      'center': center.query,
      'teamId': teamId,
      'keyId': keyId,
      if (zoom != 12) 'zoom': '$zoom',
      if (span != null) 'span': span!.query,
      if (size != AppleMapSize.auto()) 'size': size.query,
      if (scale != 1) 'scale': '$scale',
      if (colorScheme != AppleMapColorScheme.light)
        'colorScheme': colorScheme.name,
      if (!poi) 'poi': '0',
      if (lang != 'en-US') 'lang': lang,
      if (annotations.isNotEmpty)
        'annotations':
            '[${annotations.map((annotation) => annotation.query).join(',')}]',
      if (mapType != AppleMapType.standard) 't': mapType.name,
      if (referer != null) 'referer': referer!,
      if (expires != null) 'expires': '$expires',
      if (signature.isNotEmpty) 'signature': signature,
    };
  }
}

/// The location of the map
const centerLocation = MapAddress(
  address: 'center',
);

enum AppleMapColorScheme {
  light,
  dark,
}

enum AppleMapType {
  standard,
  satellite,
  hybrid,
}

class AppleMapSize {
  const AppleMapSize({
    required this.width,
    required this.height,
  })  : assert(width >= 50 && width <= 640),
        assert(height >= 50 && height <= 640);

  const AppleMapSize.auto()
      : width = 600,
        height = 400;

  final int width;

  final int height;

  String get query => '${width}x$height';

  @override
  int get hashCode => Object.hash(runtimeType, width, height);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppleMapSize &&
            identical(other.width, width) &&
            identical(other.height, height));
  }
}

/// The annotation to display on the map
///
/// see [https://developer.apple.com/documentation/snapshots/annotation]
class AppleMapAnnotation with EquatableMixin {
  const AppleMapAnnotation({
    this.markerStyle = AppleMapAnnotationStyle.balloon,
    required this.point,
    this.color,
    this.glyphColor,
    this.glyphImgIdx,
    this.glyphText,
    this.imgIdx,
    this.offset,
  });

  /// The style of the annotation
  final AppleMapAnnotationStyle markerStyle;

  /// The location of the annotation
  final MapLocation point;

  /// The color of the annotation
  final AppleMapAnnotationColor? color;

  /// The tint color of the glyph
  final AppleMapAnnotationColor? glyphColor;

  /// The zero-based index of the glyph image referenced in the array of
  /// images used for a specific annotation.
  ///
  /// Don’t set the [glyphText] property when using this property.
  /// If the annotation has a “dot” or “img” [markerStyle],
  /// the Maps Web Snapshots API ignores this parameter.
  final int? glyphImgIdx;

  /// A single alphanumeric character from the set {a-z, A-Z, 0-9},
  /// displayed inside the annotation.
  /// If the annotation has a “dot” or “img” [markerStyle],
  /// the Maps Web Snapshots API ignores this parameter.
  final String? glyphText;

  /// The zero-based index of the image referenced
  /// in the array of images to use for this annotation.
  /// The Maps Web Snapshots API requires this property if [markerStyle] is img.
  final int? imgIdx;

  /// An optional offset in scale independent pixels of the image from the bottom center.
  /// The Maps Web Snapshots API ignores the offset property
  /// if [markerStyle] is dot, balloon, or large.
  final AppleMapAnnotationOffset? offset;

  String get query {
    final builder = StringBuffer();
    builder.write('{');
    builder.write('"point": "${point.query}",');
    builder.write('"markerStyle": "${markerStyle.name}",');
    if (color != null) {
      builder.write('"color": "${color!.color}",');
    }
    if (glyphColor != null) {
      builder.write('"glyphColor": "${glyphColor!.color}",');
    }
    if (glyphImgIdx != null) {
      builder.write('"glyphImgIdx": $glyphImgIdx,');
    }
    if (glyphText != null) {
      builder.write('"glyphText": "$glyphText",');
    }
    if (imgIdx != null) {
      builder.write('"imgIdx": $imgIdx,');
    }
    if (offset != null) {
      builder.write('"offset": "${offset!.query}",');
    }
    builder.write('}');
    return builder.toString();
  }

  @override
  List<Object?> get props => [
        markerStyle,
        point,
        color,
        glyphColor,
        glyphImgIdx,
        glyphText,
        imgIdx,
        offset,
      ];
}

/// The style of the annotation
enum AppleMapAnnotationStyle {
  dot,
  balloon,
  large,
  img,
}

/// Support HTML color names and hex color codes
class AppleMapAnnotationColor with EquatableMixin {
  const AppleMapAnnotationColor({
    required this.color,
  });

  final String color;

  @override
  List<Object?> get props => [color];
}

/// An optional offset in scale independent pixels of the image from the bottom center
class AppleMapAnnotationOffset {
  const AppleMapAnnotationOffset({
    required this.x,
    required this.y,
  });

  final int x;
  final int y;

  String get query => '"$x,$y"';
}
