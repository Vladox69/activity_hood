import 'package:activity_hood/presentation/providers/current_marker_provider.dart';
import 'package:activity_hood/presentation/widgets/app_bar_widget.dart';
import 'package:activity_hood/presentation/widgets/bottom_bar_widget.dart';
import 'package:activity_hood/presentation/widgets/category_buttons_widget.dart';
import 'package:activity_hood/presentation/widgets/description_modal_widget.dart';
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
  @override
  void initState() {
    super.initState();
    final markerProvider =
        Provider.of<CurrentMarkerProvider>(context, listen: false);
    markerProvider.onMarkerTap.listen((String id) {
      if (mounted) {
        markerProvider.setSelectedMarker(id);
        _showDescriptionModal(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBarWidget(),
      ),
      body: Stack(
        children: [
          Selector<CurrentMarkerProvider, bool>(
            builder: (context, loading, loadingWidget) {
              if (loading) {
                return loadingWidget!;
              }
              return Consumer<CurrentMarkerProvider>(
                builder: (_, controller, __) {
                  if (!controller.gpsEnabled) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "To use our app we need access to your location,\nso you must enable the GPS",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              final controller =
                                  context.read<CurrentMarkerProvider>();
                              controller.turnOnGPS();
                            },
                            child: const Text("Turn on GPS"),
                          )
                        ],
                      ),
                    );
                  }

                  return GoogleMap(
                    initialCameraPosition: controller.initialCameraPosition,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    markers: controller.markers,
                    onTap: (position) {
                      controller.setTemporaryMarker(position);
                      _showLocationModal(context);
                    },
                    polylines: {
                      if (controller.route != null)
                        Polyline(
                          polylineId: const PolylineId("overview_polyline"),
                          color: Colors.red,
                          width: 5,
                          points: controller.route!.polylinePoints
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList(),
                        ),
                    },
                  );
                },
              );
            },
            child: const Center(
              child: CircularProgressIndicator(),
            ),
            selector: (_, controller) => controller.loading,
          ),

          /// 🔹 Botones estilo Google Maps
          const CategoryButtonsWidget(),
        ],
      ),
      bottomNavigationBar: const BottomBarWidget(),
    );
  }

  void _showLocationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LocationModal(),
    );
  }

  void _showDescriptionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const DescriptionModal(),
    );
  }
}
