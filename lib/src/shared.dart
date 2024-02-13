import 'package:equatable/equatable.dart';

/// The base class for map location
sealed class MapLocation with EquatableMixin {
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
  List<Object?> get props => [_lat, _lng];
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
  List<Object?> get props => [address];
}

/// Create digital signature function
typedef SignatureFunction = String Function(String pathAndParams);
