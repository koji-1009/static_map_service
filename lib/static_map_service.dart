/// A Dart package for generating static map images url from Google Maps, Apple Snapshots, and Mapbox Static Images.
///
/// This package provides a type-safe interface to construct URLs for static maps.
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
