import 'package:activity_hood/presentation/providers/current_marker_provider.dart';
import 'package:activity_hood/presentation/screens/add_place/add_place_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationModal extends StatelessWidget {
  const LocationModal({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CurrentMarkerProvider>();
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ubicación seleccionada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(
                  'Latitud: ${state.currentMarker?.position.latitude}\nLongitud: ${state.currentMarker?.position.longitude}',
                  style: const TextStyle(fontSize: 14),
                )),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Antes de navegar, asegúrate de que el CurrentMarkerProvider está disponible
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                      value: Provider.of<CurrentMarkerProvider>(context,
                          listen: false),
                      child: const AddPlaceScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar lugar'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(icon),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
