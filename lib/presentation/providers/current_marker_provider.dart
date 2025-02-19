import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentMarkerProvider extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  Marker? _currentMarker;
  Set<Marker> get markers =>
      {..._markers.values, if (_currentMarker != null) _currentMarker!};

  void onTap(LatLng position) {
    const markerId = MarkerId('recurrent-marker');
    _currentMarker = Marker(
      markerId: markerId,
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue), // Azul para el marcador recurrente
    );

    notifyListeners();
  }

  void saveMarker() {
    if (_currentMarker != null) {
      final savedMarkerId =
          MarkerId(DateTime.now().toString()); // ID único basado en el tiempo

      final savedMarker = Marker(
        markerId: savedMarkerId,
        position: _currentMarker!.position,
        icon: BitmapDescriptor.defaultMarker, // Rojo para marcadores guardados
      );

      _markers[savedMarkerId] = savedMarker;
      notifyListeners();
    }
  }

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }
}
