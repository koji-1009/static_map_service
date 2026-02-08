/// The base class for all map services.
///
/// This class provides a common interface for constructing static map URLs
/// across different providers (Google, Apple, Mapbox).
abstract base class MapService {
  /// Const constructor for subclasses.
  const MapService();

  /// The authority (domain) of the map service (e.g., `maps.googleapis.com`).
  String get authority;

  /// The unencoded path of the map service (e.g., `/maps/api/staticmap`).
  String get unencodedPath;

  /// The query parameters for the map service.
  ///
  /// The values can be [String] or [Iterable<String>] for multiple parameters
  /// with the same key.
  Map<String, dynamic> get queryParameters;

  /// The full HTTPS [Uri] of the map image.
  Uri get uri => Uri.https(authority, unencodedPath, queryParameters);

  /// The full URL string of the map image.
  String get url => uri.toString();
}
