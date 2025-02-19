import 'package:activity_hood/presentation/providers/current_marker_provider.dart';
import 'package:activity_hood/presentation/widgets/app_bar_widget.dart';
import 'package:activity_hood/presentation/widgets/bottom_bar_widget.dart';
import 'package:activity_hood/presentation/widgets/location_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(-1.288644, -78.606316),
    zoom: 15,
  );

  late GoogleMapController _mapController; // Controlador del mapa

  @override
  Widget build(BuildContext context) {
    final currentMarkerProvider = context.watch<CurrentMarkerProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBarWidget(),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        markers: currentMarkerProvider.markers,
        onMapCreated: (controller) {
          _mapController = controller; // Guardar el controlador
        },
        onTap: (position) {
          currentMarkerProvider.onTap(position);
          _showLocationModal(context, position.latitude, position.longitude);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: _initialCameraPosition.target, zoom: 15),
          ));
        },
        child: const Icon(
          Icons.my_location,
          size: 20,
        ),
      ),
      bottomNavigationBar: const BottomBarWidget(),
    );
  }

  void _showLocationModal(BuildContext context, double latitude, double longitude) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => LocationModal(
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }
}