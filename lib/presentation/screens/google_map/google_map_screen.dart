import 'package:activity_hood/presentation/providers/current_marker_provider.dart';
import 'package:activity_hood/presentation/widgets/app_bar_widget.dart';
import 'package:activity_hood/presentation/widgets/bottom_bar_widget.dart';
import 'package:activity_hood/presentation/widgets/location_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapScreen extends StatelessWidget {
  const GoogleMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CurrentMarkerProvider>(
      create: (_) {
        final controller = CurrentMarkerProvider();
        controller.onMarkerTap.listen((String id) {
          Future.microtask(() {
            if (context.mounted) {
              _showDescriptionModal(context);
            }
          });
        });
        return controller;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBarWidget(),
        ),
        body: Consumer<CurrentMarkerProvider>(
          builder: (_, controller, __) => GoogleMap(
            initialCameraPosition: controller.initialCameraPosition,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            markers: controller.markers,
            onTap: (position) {
              controller.onTap(position);
              _showLocationModal(
                  context, position.latitude, position.longitude);
            },
          ),
        ),
        bottomNavigationBar: const BottomBarWidget(),
      ),
    );
  }

  void _showLocationModal(
      BuildContext context, double latitude, double longitude) {
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

  void _showDescriptionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const Text("siii"),
    );
  }
}
