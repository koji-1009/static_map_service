/// A type-safe Dart package for generating static map image URLs.
///
/// Currently supports:
/// * Google Maps Static API
/// * Apple Maps Web Snapshots
/// * Mapbox Static Images API
///
/// Example:
/// ```dart
/// import 'package:static_map_service/static_map_service.dart';
///
/// final url = GoogleMapService.center(
///   key: 'YOUR_API_KEY',
///   center: MapLatLng(latitude: 35.6812, longitude: 139.7671),
///   zoom: 12,
///   size: GoogleMapSize(width: 400, height: 400),
/// ).url;
/// ```
library;

export 'src/service.dart';
export 'src/service_apple.dart';
export 'src/service_google.dart';
export 'src/service_mapbox.dart';
export 'src/shared.dart';
