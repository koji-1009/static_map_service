# AI Agent Guide for static_map_service

This document provides context and guidelines for AI agents working on the `static_map_service` project.

## Project Overview

`static_map_service` is a Dart package designed to generate URLs for static map images from various providers, currently supporting:
- Google Maps Static API
- Apple Maps Web Snapshots

The goal is to provide a type-safe, easy-to-use interface for constructing these URLs, handling parameters like center location, zoom level, map size, markers, and paths.

## Architecture

The project follows a simple architecture:

- **`MapService` (Abstract Base Class):** Defines the common interface for all map services (`authority`, `unencodedPath`, `queryParameters`, `url`).
- **`GoogleMapService`:** Implements `MapService` for Google Maps. It uses factory constructors (`.center`, `.markers`, `.path`) to handle different usage patterns enforced by the API.
- **`AppleMapService`:** Implements `MapService` for Apple Maps.
- **`Shared Objects`:** Common value objects like `MapLatLng`, `MapAddress`, etc., are defined in `src/shared.dart` to ensure consistency across services.

## Directory Structure

- `lib/`: Source code.
  - `static_map_service.dart`: Main entry point, exports public APIs.
  - `src/`: Internal implementation details.
- `test/`: Tests corresponding to `lib/` files.

## Development Guidelines

1.  **Type Safety:** Use Dart's type system to enforce valid parameters (e.g., `extension type` for constrained values).
2.  **Immutability:** All service classes and value objects should be immutable.
3.  **Testing:** Every feature must be tested. Use `test` package.
4.  **Linting:** Follow `analysis_options.yaml` (recommended lints).
5.  **Documentation:** Document public APIs clearly.

## Current Tasks

1.  Review and Refactor `lib/` code.
2.  Implement missing features (check TODOs in code).
3.  Expand test coverage.
4.  Update CHANGELOG.md.
