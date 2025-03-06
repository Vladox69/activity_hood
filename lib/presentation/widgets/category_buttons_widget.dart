import 'package:flutter/material.dart';

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
            _buildGoogleMapsButton(Icons.restaurant, 'Restaurantes'),
            _buildGoogleMapsButton(Icons.hotel, 'Hoteles'),
            _buildGoogleMapsButton(Icons.park, 'Parques'),
            _buildGoogleMapsButton(Icons.local_gas_station, 'Gasolineras'),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleMapsButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton.icon(
        onPressed: () {},
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
