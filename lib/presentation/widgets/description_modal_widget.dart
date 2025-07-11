import 'package:activity_hood/presentation/providers/current_marker_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DescriptionModal extends StatelessWidget {
  const DescriptionModal({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CurrentMarkerProvider>();
    final marker = state.selectedMarker;
    final current = state.currentPosition;
    if (marker == null) {
      return const SizedBox
          .shrink(); // Evita mostrar el modal si no hay marcador seleccionado
    }

    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del modal
            Text(
              marker.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Ubicación y descripción
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    marker.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Fecha del evento
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Fecha inicio: ${marker.startDate}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Fecha inicio: ${marker.startDate}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Horario del evento
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Hora: ${marker.startTime} - ${marker.endTime}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _actionButton(
                icon: Icons.directions,
                label: 'Cómo llegar',
                onPressed: () async {
                  if (current != null) {
                    final origin = LatLng(current.latitude, current.longitude);
                    final destination =
                        LatLng(marker.latitude, marker.longitude);
                    await state.setRoute(origin, destination);
                  }
                },
              ),
              _actionButton(
                icon: Icons.share,
                label: 'Compartir',
                onPressed: () {
                  state.shareLocation(marker.latitude, marker.longitude);
                },
              ),
            ]),
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
