import 'package:activity_hood/presentation/providers/current_marker_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryButtonsWidget extends StatelessWidget {
  const CategoryButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 75, // Espacio después del buscador
      left: 10,
      right: 10,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildGoogleMapsButton(Icons.restaurant, 'Restaurantes', context),
            _buildGoogleMapsButton(Icons.hotel, 'Hoteles', context),
            _buildGoogleMapsButton(Icons.park, 'Parques', context),
            _buildGoogleMapsButton(
                Icons.local_gas_station, 'Gasolineras', context),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleMapsButton(
      IconData icon, String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton.icon(
        onPressed: () {
          final controller = context.read<CurrentMarkerProvider>();
          controller.filterMarkers(label);
        },
        icon: Icon(icon, size: 18), // Icono más pequeño
        label: Text(label,
            style: const TextStyle(fontSize: 12)), // Texto más pequeño
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
