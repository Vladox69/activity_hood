import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionModel {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  DirectionModel(
      {required this.bounds,
      required this.polylinePoints,
      required this.totalDistance,
      required this.totalDuration});

  factory DirectionModel.fromMap(Map<String, dynamic> map) {
    //if ((map['routes'] as List).isEmpty) return null;
    final data = Map<String, dynamic>.from(map['routes'][0]);
    final northeast = data['data']['northeast'];
    final southeast = data['data']['southeast'];
    final bounds = LatLngBounds(
        southwest: LatLng(southeast['lat'], southeast['lng']),
        northeast: LatLng(northeast['lat'], northeast['lng']));
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }
    return DirectionModel(
        bounds: bounds,
        polylinePoints: PolylinePoints()
            .decodePolyline(data['overview_polyline']['points']),
        totalDistance: distance,
        totalDuration: duration);
  }
}
