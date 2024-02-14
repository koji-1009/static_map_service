A Dart package for generating static map images url from Google Maps, Apple Snapshots.

## Features

Generate static map images url from Google Maps, Apple Snapshots.

* [Google Static Map API](https://developers.google.com/maps/documentation/maps-static/overview)
* [Apple Maps Web Snapshots](https://developer.apple.com/documentation/snapshots)

## Getting started

```dart
const url = GoogleMapService.center(
  key: 'your_api_key',
  center: MapLagLng(
    latitude: 37.7749,
    longitude: -122.4194,
  ),
  zoom: 12,
  size: GoogleMapSize(
    width: 400,
    height: 400,
  ),
).url;

print(url); // show the generated url
```

If you need url with digital signature, you can use `GoogleMapService.signedUrl` method.

```dart
final url = GoogleMapService.center(
  key: 'your_api_key',
  center: MapLagLng(
    latitude: 37.7749,
    longitude: -122.4194,
  ),
  zoom: 12,
  size: GoogleMapSize(
    width: 400,
    height: 400,
  ),
  signatureFunction: (pathAndParams) {
    final signature = compute(pathAndrParams, 'your_secret');
    return signature;
  },
).url;

print(url); // show the generated url with digital signature
```
