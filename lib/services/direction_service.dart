import 'package:activity_hood/models/direction_model.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:activity_hood/config/.env.dart';

class DirectionService {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  final Dio _dio;
  DirectionService({Dio? dio}) : _dio = dio ?? Dio();

  Future<DirectionModel?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(_baseUrl, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': googleAPIKey
    });
    print(response.realUri);
    if (response.statusCode == 200) {
      return DirectionModel.fromMap(response.data);
    }
    return null;
  }
}
