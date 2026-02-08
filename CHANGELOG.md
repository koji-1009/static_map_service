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
