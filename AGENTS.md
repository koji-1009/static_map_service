# AI Agent Guide for static_map_service

This document provides context and guidelines for AI agents working on the `static_map_service` project.

## Project Overview

`static_map_service` is a Dart package designed to generate URLs for static map images from various providers, currently supporting:

* Google Maps Static API
* Apple Maps Web Snapshots
* Mapbox Static Images API

The goal is to provide a type-safe, easy-to-use interface for constructing these URLs, handling parameters like center location, zoom level, map size, markers, paths, and overlays.

## Architecture

The project follows a simple architecture:

* **`MapService` (Abstract Base Class):** Defines the common interface for all map services (`authority`, `unencodedPath`, `queryParameters`, `url`).
* **`GoogleMapService`:** Implements `MapService` for Google Maps. It uses factory constructors (`.center`, `.markers`, `.path`) to handle different usage patterns enforced by the API. Supports Encoded Polyline for efficient path representation.
* **`AppleMapService`:** Implements `MapService` for Apple Maps.
* **`MapboxMapService`:** Implements `MapService` for Mapbox, supporting styles, markers, paths, and GeoJSON overlays.
* **`Shared Objects`:** Common value objects like `MapLatLng`, `MapAddress`, etc., are defined in `src/shared.dart`.
* **`Utils`:** Utility functions like Encoded Polyline Algorithm implementation in `src/utils.dart`.

## Directory Structure

* `lib/`: Source code.
  * `static_map_service.dart`: Main entry point.
  * `src/`: Internal implementation.
    * `service.dart`: Base class.
    * `service_google.dart`: Google Maps impl.
    * `service_apple.dart`: Apple Maps impl.
    * `service_mapbox.dart`: Mapbox impl.
    * `shared.dart`: Shared types.
    * `utils.dart`: Utilities.
* `test/`: Tests.

## Development Guidelines

1. **Type Safety:** Use Dart's type system to enforce valid parameters.
2. **Immutability:** All service classes and value objects should be immutable.
3. **Testing:** Every feature must be tested. Maintain 100% test coverage.
4. **Linting:** Follow `analysis_options.yaml`.
5. **Documentation:** Document public APIs clearly.

## Current Status

* **Test Coverage:** 100% (Line coverage).
* **API Compliance:** Verified against Google Maps, Apple Maps, and Mapbox official specifications.
* **Version:** 1.0.0 (Stable Release).

## Future Considerations

1. Support additional map providers (e.g., Bing Maps, Here Maps).
2. Add more complex GeoJSON support for Mapbox.
3. Improve example project with interactive UI.
