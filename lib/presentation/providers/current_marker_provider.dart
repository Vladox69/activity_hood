import 'dart:async';
import 'package:activity_hood/constants/Category.dart';
import 'package:activity_hood/models/direction_model.dart';
import 'package:activity_hood/models/marker_model.dart';
import 'package:activity_hood/presentation/helpers/asset_to_bytes.dart';
import 'package:activity_hood/services/direction_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class CurrentMarkerProvider extends ChangeNotifier {
  final List<MarkerModel> _markersList = []; // Lista de marcadores guardados
  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet(); // Se genera dinámicamente
  final List<MarkerModel> _filteredMarkersList = []; // Lista auxiliar filtrada
  Marker? get currentMarker => _currentMarker;
  MarkerModel? get selectedMarker => _selectedMarker;
  Marker? _currentMarker; // Marcador temporal
  MarkerModel? _selectedMarker;
  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;
  bool _loading = true;
  bool get loading => _loading;
  late bool _gpsEnabled;
  bool get gpsEnabled => _gpsEnabled;
  StreamSubscription? _gpsSubscription, _positionSubscription;

  Position? _initialPosition;
  CameraPosition get initialCameraPosition => CameraPosition(
      target: LatLng(_initialPosition!.latitude, _initialPosition!.longitude),
      zoom: 15);
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  DirectionModel? _route;
  DirectionModel? get route => _route;
  String get selectedCategory => _selectedCategory;
  String _selectedCategory = "";

  // Getter para el marcador temporal
  Set<Marker> _generateMarkers() {
    final Set<Marker> allMarkers = {
      ...(_filteredMarkersList.isNotEmpty ? _filteredMarkersList : _markersList)
          .map((m) => Marker(
                markerId: MarkerId(m.id),
                position: LatLng(m.latitude, m.longitude),
                infoWindow: InfoWindow(title: m.title, snippet: m.description),
                onTap: () => _markersController.sink.add(m.id),
              ))
    };

    if (_currentMarker != null) {
      allMarkers.add(_currentMarker!);
    }

    return allMarkers;
  }

  CurrentMarkerProvider() {
    _init();
  }

  Future<void> _init() async {
    _gpsEnabled = await Geolocator.isLocationServiceEnabled();
    _gpsSubscription =
        Geolocator.getServiceStatusStream().listen((status) async {
      _gpsEnabled = status == ServiceStatus.enabled;
      if (_gpsEnabled) {
        _initialLocationUpdates();
      }
    });
    _loading = false;
    _initialLocationUpdates();
  }

  void _setInitialPosition(Position position) async {
    if (_gpsEnabled && _initialPosition == null) {
      _initialPosition = position;
    }
  }

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();

  Future<void> _initialLocationUpdates() async {
    bool initialized = false;
    await _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream().listen((position) {
      _currentPosition = position;
      if (!initialized) {
        _setInitialPosition(position);
        initialized = true;
        notifyListeners();
      }
      /*if (_selectedMarker != null) {
        setRoute(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          LatLng(_selectedMarker!.latitude, _selectedMarker!.longitude),
        );
      }*/
    }, onError: (e) {
      if (e is LocationServiceDisabledException) {
        _gpsEnabled = false;
        notifyListeners();
      }
    });
  }

  void setTemporaryMarker(LatLng position) {
    const id = MarkerId("current"); // ID fijo para el marcador temporal
    _currentMarker = Marker(
      markerId: id,
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue), // Color diferente
    );
    _markers[id] = _currentMarker!;
    _selectedMarker = null;
    notifyListeners();
  }

  void setSelectedMarker(String id) {
    _selectedMarker = _markersList.firstWhere((marker) => marker.id == id);
    notifyListeners();
  }

  Future<void> saveMarker(String title, String description, String startDate,
      String endDate, String startTime, String endTime, String category) async {
    if (_currentMarker != null) {
      final savedMarkerId = const Uuid().v4(); // ID único
      /*final newMarker = MarkerModel(
          id: savedMarkerId,
          latitude: _currentMarker!.position.latitude,
          longitude: _currentMarker!.position.longitude,
          title: title,
          description: description,
          startDate: startDate,
          endDate: endDate,
          startTime: startTime,
          endTime: endTime,
          iconName: category);

      _markersList.add(newMarker);*/
      final id = MarkerId(savedMarkerId);
      final icon = await _getCategoryIcon(category);
      _markers[id] =
          Marker(markerId: id, position: _currentMarker!.position, icon: icon);
      _currentMarker = null; // Eliminar el marcador temporal
      notifyListeners();
    }
  }

  Future<void> setRoute(LatLng origin, LatLng destination) async {
    if (selectedMarker != null) {
      _route = await DirectionService()
          .getDirections(origin: origin, destination: destination);
      notifyListeners();
    }
  }

  void filterMarkers(String category) {
    _filteredMarkersList.clear();
    if (_selectedCategory == category) {
      _filteredMarkersList
          .addAll(_markersList); // Restaurar todos los marcadores
      _selectedCategory = "";
    } else {
      _filteredMarkersList
          .addAll(_markersList.where((marker) => marker.iconName == category));
      _selectedCategory = category;
    }
    notifyListeners();
  }

  void clearFilters() {
    _filteredMarkersList.clear(); // Vaciar la lista filtrada
    notifyListeners();
  }

  Future<BitmapDescriptor> _getCategoryIcon(String category) async {
    String assetPath;
    double bitmapDescriptor;
    switch (category) {
      case Category.FOOD:
        assetPath = "assets/electric-guitar.png";
        bitmapDescriptor = BitmapDescriptor.hueCyan;
        break;
      case Category.CONCERT:
        assetPath = "assets/red-carpet.png";
        bitmapDescriptor = BitmapDescriptor.hueGreen;
        break;
      case Category.PARK:
        assetPath = "assets/restaurant.png";
        bitmapDescriptor = BitmapDescriptor.hueMagenta;
        break;
      case Category.GARAGE_SALE:
        assetPath = "assets/ticket.png";
        bitmapDescriptor = BitmapDescriptor.hueViolet;
        break;
      default:
        assetPath = "assets/ticket.png";
        bitmapDescriptor = BitmapDescriptor.hueOrange;
        break;
    }

    return BitmapDescriptor.bytes(await assetToByte(assetPath));
    //return BitmapDescriptor.defaultMarkerWithHue(bitmapDescriptor);
  }

  void shareLocation(double latitude, double longitude) {
    final String googleMapsUrl =
        "https://www.google.com/maps?q=$latitude,$longitude";

    Share.share("¡Mira esta ubicación! 📍\n$googleMapsUrl");
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearMarkers() {
    _markersList.clear();
    _currentMarker = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();
    _markersController.close();
    super.dispose();
  }
}
