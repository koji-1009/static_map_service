import 'package:static_map_service/static_map_service.dart';

void main() {
  // 1. Google Maps Static API
  final googleUrl = GoogleMapService.center(
    key: 'YOUR_GOOGLE_MAPS_KEY',
    center: MapLatLng(latitude: 35.6812, longitude: 139.7671),
    zoom: 12,
    size: GoogleMapSize(width: 600, height: 400),
  ).url;
  print('Google Maps URL: $googleUrl');

  // 2. Google Maps with Encoded Polyline
  final googlePathUrl = GoogleMapService.path(
    key: 'YOUR_GOOGLE_MAPS_KEY',
    path: GoogleMapPath.encoded(
      locations: [
        MapLatLng(latitude: 35.6812, longitude: 139.7671),
        MapLatLng(latitude: 35.6895, longitude: 139.6917),
      ],
      color: const GoogleMapColor.blue(),
      weight: 5,
    ),
    size: GoogleMapSize(width: 600, height: 400),
  ).url;
  print('Google Maps Path URL: $googlePathUrl');

  // 3. Apple Maps Web Snapshots
  final appleUrl = AppleMapService(
    teamId: 'YOUR_TEAM_ID',
    keyId: 'YOUR_KEY_ID',
    center: MapLatLng(latitude: 35.6812, longitude: 139.7671),
    signatureFunction: (pathAndParams) => 'YOUR_SIGNATURE',
  ).url;
  print('Apple Maps URL: $appleUrl');

  // 4. Mapbox Static Images API (Auto-fitting overlays)
  final mapboxUrl = MapboxMapService.auto(
    accessToken: 'YOUR_MAPBOX_ACCESS_TOKEN',
    overlays: [
      MapboxMarker(
        location: MapLatLng(latitude: 35.6812, longitude: 139.7671),
        label: 'a',
        color: 'ff0000',
      ),
      MapboxPath(
        locations: [
          MapLatLng(latitude: 35.6812, longitude: 139.7671),
          MapLatLng(latitude: 35.6895, longitude: 139.6917),
        ],
        strokeColor: '0000ff',
        strokeWidth: 3,
      ),
    ],
    size: MapboxMapSize(width: 600, height: 400),
  ).url;
  print('Mapbox URL: $mapboxUrl');
}
