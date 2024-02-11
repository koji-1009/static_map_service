/// The base class for map location
sealed class MapLocation {
  const MapLocation();

  String get query;
}

/// The latitude and longitude of the map location
class MapLatLng extends MapLocation {
  const MapLatLng({
    required double latitude,
    required double longitude,
  })  : assert(latitude >= -90 && latitude <= 90),
        assert(longitude >= -180 && longitude <= 180),
        _lng = latitude < -90
            ? -90
            : latitude > 90
                ? 90
                : longitude,
        _lat = longitude < -180
            ? -180
            : longitude > 180
                ? 180
                : latitude;

  final double _lat;
  final double _lng;

  @override
  String get query => '${_lat.toStringAsFixed(4)},${_lng.toStringAsFixed(4)}';

  @override
  int get hashCode => Object.hash(runtimeType, _lat, _lng);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MapLatLng &&
            (identical(other._lat, _lat) || other._lat == _lat) &&
            (identical(other._lng, _lng) || other._lng == _lng));
  }
}

/// The address of the map location
class MapAddress extends MapLocation {
  const MapAddress({
    required this.address,
  });

  final String address;

  @override
  String get query => address;

  @override
  int get hashCode => Object.hash(runtimeType, address);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MapAddress &&
            (identical(other.address, address) || other.address == address));
  }
}

/// Create digital signature function
typedef SignatureFunction = String Function(String pathAndParams);
