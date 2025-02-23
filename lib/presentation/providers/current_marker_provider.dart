import 'dart:async';
import 'package:activity_hood/models/marker_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class CurrentMarkerProvider extends ChangeNotifier {
  final List<MarkerModel> _markersList = []; // Lista de marcadores guardados
  Set<Marker> get markers => _generateMarkers(); // Se genera dinámicamente
  Marker? get currentMarker => _currentMarker;
  Marker? _currentMarker; // Marcador temporal
  Marker? selectedMarker;
  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  final initialCameraPosition = const CameraPosition(
    target: LatLng(-1.288644, -78.606316),
    zoom: 15,
  );

  // Getter para el marcador temporal
  Set<Marker> _generateMarkers() {
    final Set<Marker> allMarkers = {
      ..._markersList.map((m) => Marker(
            markerId: MarkerId(m.id),
            position: LatLng(m.latitude, m.longitude),
            infoWindow: InfoWindow(title: m.title, snippet: m.description),
            onTap: () => _markersController.sink.add(m.id),
          )),
    };

    if (_currentMarker != null) {
      allMarkers.add(_currentMarker!);
    }

    return allMarkers;
  }

  void setTemporaryMarker(LatLng position) {
    const id = "current-marker"; // ID fijo para el marcador temporal
    _currentMarker = Marker(
      markerId: const MarkerId(id),
      position: position,
      onTap: () {
        _markersController.sink.add(id);
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue), // Color diferente
    );
    notifyListeners();
  }

  void saveMarker(String title, String description, String date,
      String startTime, String endTime) {
    if (_currentMarker != null) {
      print(_currentMarker);
      final savedMarkerId = const Uuid().v4(); // ID único
      final newMarker = MarkerModel(
        id: savedMarkerId,
        latitude: _currentMarker!.position.latitude,
        longitude: _currentMarker!.position.longitude,
        title: title,
        description: description,
        date: date,
        startTime: startTime,
        endTime: endTime,
      );

      _markersList.add(newMarker);
      _currentMarker = null; // Eliminar el marcador temporal
      notifyListeners();
    } else {
      print(_currentMarker);
    }
  }

  void clearMarkers() {
    _markersList.clear();
    _currentMarker = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _markersController.close();
    super.dispose();
  }
}
