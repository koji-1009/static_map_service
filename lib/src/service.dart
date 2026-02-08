/// The base class for map service
abstract base class MapService {
  const MapService();

  /// The authority of the map service
  String get authority;

  /// The unencoded path of the map service
  String get unencodedPath;

  /// The query parameters of the map service
  Map<String, dynamic> get queryParameters;

  /// [Uri] of the map service
  Uri get uri => Uri.https(authority, unencodedPath, queryParameters);

  /// The url of the map service
  String get url => uri.toString();
}
