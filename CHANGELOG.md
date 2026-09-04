## 1.1.0

### Fixes

* **Apple Maps**: Rename query parameters to `z`, `spn` and `imgs` to conform to the Web Snapshots specification.
* **Apple Maps**: Fix `AppleMapSize` to separate width and height with `x`.
* **Apple Maps**: Fix `AppleMapOverlay` to emit `lineDashOffset` and `lineDash` as integers.
* **Apple Maps**: Build `annotations`, `overlays` and `imgs` with `jsonEncode` to escape special characters.
* **Google Maps**: Fix `GoogleMapFeatureLandscape` to use a dot separator for sub-types.
* **Mapbox**: Fix double percent-encoding of overlays in the generated URL.
* **Mapbox**: Reject `padding` outside `MapboxMapService.auto`.
* Fix `MapLatLng` to keep 6 decimal places and to treat `NaN` as `0`.

### Breaking Change

* **Apple Maps**: Rename `AppleMapOverlay` parameters `lineDashPhase` to `lineDashOffset` and `lineDashPattern` to `lineDash`. Both now take `int` instead of `double`.

### Deprecations

* **Mapbox**: Deprecate `MapboxMarkerSize.medium`, which is not part of the specification.

### Refactoring & Others

* Add regression tests for the generated `url` of each service.
* Fix the example in `README.md`.
* Update `AGENTS.md`.

## 1.0.0

### Features

* Support Mapbox Static Images API.
* Apple Maps: Support `overlays` and `images` parameters.
* Implement Encoded Polyline Algorithm for efficient paths.
* Add `example` project.

### Fixes

* **Google Maps**: Fix URL generation for multiple markers and styles to conform to multi-value parameter specifications.

### Refactoring & Others

* **Breaking Change**: Refactor `MapboxMapService` to use `.auto()` constructor for automatic viewport fitting.
* Internal parameter building logic refactor for better maintainability and type safety.
* Convert all Mapbox overlays to `extension type const` for better performance and consistency.
* Achieve 100% test coverage with robust assertion and boundary checks.
* Support Dart 3.8 features (null-aware collection elements).
* Setup GitHub Actions CI.
* Add topics and repository info to `pubspec.yaml`.
* Improve documentation.

## 0.0.2

* Use extension type.

## 0.0.1

* Initial version.
