# static_map_service

[![pub package](https://img.shields.io/pub/v/static_map_service.svg)](https://pub.dev/packages/static_map_service)
[![analyze](https://github.com/koji-1009/static_map_service/actions/workflows/analyze.yaml/badge.svg)](https://github.com/koji-1009/static_map_service/actions/workflows/analyze.yaml)
[![codecov](https://codecov.io/gh/koji-1009/static_map_service/branch/main/graph/badge.svg)](https://codecov.io/gh/koji-1009/static_map_service)

A Dart package for generating static map images url from Google Maps, Apple Snapshots, and Mapbox Static Images.

## Features

Generate static map images url from various providers.

* [Google Static Map API](https://developers.google.com/maps/documentation/maps-static/overview)
* [Apple Maps Web Snapshots](https://developer.apple.com/documentation/snapshots)
* [Mapbox Static Images API](https://docs.mapbox.com/api/maps/static-images/)

## Usage

### Google Maps

```dart
import 'package:static_map_service/static_map_service.dart';

void main() {
  const url = GoogleMapService.center(
    key: 'your_api_key',
    center: MapLatLng(
      latitude: 37.7749,
      longitude: -122.4194,
    ),
    zoom: 12,
    size: GoogleMapSize(
      width: 400,
      height: 400,
    ),
  ).url;

  print(url);
}
```

#### Encoded Polyline

Using Encoded Polyline Algorithm can reduce the URL length significantly.

```dart
final url = GoogleMapService.path(
  key: 'your_api_key',
  path: GoogleMapPath.encoded(
    locations: [
      MapLatLng(latitude: 38.5, longitude: -120.2),
      MapLatLng(latitude: 40.7, longitude: -120.95),
      MapLatLng(latitude: 43.252, longitude: -126.453),
    ],
    color: GoogleMapColor.red(),
    weight: 5,
  ),
  size: GoogleMapSize(width: 400, height: 400),
).url;
```

#### With Digital Signature

```dart
final url = GoogleMapService.center(
  key: 'your_api_key',
  center: MapLatLng(
    latitude: 37.7749,
    longitude: -122.4194,
  ),
  zoom: 12,
  size: GoogleMapSize(
    width: 400,
    height: 400,
  ),
  signatureFunction: (pathAndParams) {
    // Implement your signature logic here
    // return compute(pathAndParams, 'your_secret');
    return 'signature';
  },
).url;
```

### Apple Maps

```dart
import 'package:static_map_service/static_map_service.dart';

void main() {
  final url = AppleMapService(
    teamId: 'your_team_id',
    keyId: 'your_key_id',
    center: MapLatLng(
      latitude: 37.7749,
      longitude: -122.4194,
    ),
    signatureFunction: (pathAndParams) {
      // Implement your signature logic here
      return 'signature';
    },
  ).url;

  print(url);
}
```

### Mapbox

```dart
import 'package:static_map_service/static_map_service.dart';

void main() {
  final url = MapboxMapService(
    accessToken: 'your_access_token',
    center: MapLatLng(
      latitude: 37.7749,
      longitude: -122.4194,
    ),
    zoom: 12.5,
    size: MapboxMapSize(width: 600, height: 400),
    styleId: 'streets-v11', // default
  ).url;

  print(url);
}
```

#### Mapbox Overlays

```dart
final url = MapboxMapService.auto(
  accessToken: 'your_access_token',
  overlays: [
    MapboxMarker(
      location: MapLatLng(latitude: 37.7749, longitude: -122.4194),
      label: 'a',
      color: 'ff0000',
    ),
    MapboxPath(
      locations: [
         MapLatLng(latitude: 37.7749, longitude: -122.4194),
         MapLatLng(latitude: 37.8, longitude: -122.45),
      ],
      strokeWidth: 3,
      strokeColor: '0000ff',
    ),
  ],
  size: MapboxMapSize(width: 600, height: 400),
).url;
```

## Additional Information

For more details, please refer to the documentation of each service.

## License

MIT License - see [LICENSE](LICENSE) for details.
