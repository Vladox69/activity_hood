import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:activity_hood/presentation/widgets/location_modal_widget.dart';

class CurrentMarkerProvider extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => {..._markers.values};
  final initialCameraPosition = const CameraPosition(
    target: LatLng(-1.288644, -78.606316),
    zoom: 15,
  );
  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  final Map<MarkerId, Map<String, String>> _markerDetails = {};
  Marker? _currentMarker;
  Marker? selectedMarker;

  void onTap(LatLng position) {
    const uuid = Uuid();
    final id = uuid.v4();
    final markerId = MarkerId(id);
    final marker = Marker(
        markerId: markerId,
        position: position,
        onTap: () {
          _markersController.sink.add(id);
        });
    _markers[markerId] = marker;
    notifyListeners();
  }

  void saveMarker(BuildContext context, String title, String description,
      String date, String startTime, String endTime) {
    if (_currentMarker != null) {
      final savedMarkerId = MarkerId(DateTime.now().toString()); // ID único

      _markers[savedMarkerId] = Marker(
          markerId: savedMarkerId,
          position: _currentMarker!.position,
          icon: BitmapDescriptor.defaultMarker);

      _markerDetails[savedMarkerId] = {
        'title': title,
        'description': description,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
      };

      _currentMarker = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _markersController.close();
    super.dispose();
  }

  void clearMarkers() {
    _markers.clear();
    _markerDetails.clear();
    notifyListeners();
  }

  void clearSelectedMarker() {
    selectedMarker = null;
    notifyListeners();
  }

  void onMarkerTapped(BuildContext context, MarkerId markerId) {
    selectedMarker = _markers[markerId];
    notifyListeners();
  }
}
