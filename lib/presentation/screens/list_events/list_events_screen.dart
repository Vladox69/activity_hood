import 'package:activity_hood/models/marker_model.dart';
import 'package:activity_hood/presentation/providers/current_marker_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListEventsScreen extends StatefulWidget {
  const ListEventsScreen({super.key});

  @override
  State<ListEventsScreen> createState() => _ListEventsScreenState();
}

class _ListEventsScreenState extends State<ListEventsScreen> {
  List<MarkerModel> events = [
    MarkerModel(
        id: "1",
        latitude: 40.7128,
        longitude: -74.0060,
        title: "Concierto en el Parque",
        description: "Disfruta de una noche de música en vivo.",
        startDate: "2025-04-10",
        endDate: "2025-04-10",
        startTime: "18:00",
        endTime: "22:00",
        iconName: "music",
        isApproved: false),
    MarkerModel(
        id: "2",
        latitude: 34.0522,
        longitude: -118.2437,
        title: "Feria Gastronómica",
        description: "Prueba los mejores platillos de la región.",
        startDate: "2025-04-15",
        endDate: "2025-04-16",
        startTime: "10:00",
        endTime: "20:00",
        iconName: "food",
        isApproved: false),
  ];

  void approveEvent(String id) {
    setState(() {
      final index = events.indexWhere((event) => event.id == id);
      if (index != -1) {
        events[index] = events[index].copyWith(isApproved: true);
      }
    });
  }

  void removeEvent(String id) {
    setState(() {
      events.removeWhere((event) => event.id == id);
    });
  }

  void logout() {
    // Aquí puedes agregar la lógica de cierre de sesión
    Navigator.pushReplacementNamed(
        context, "/login"); // Redirige a la pantalla de login
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CurrentMarkerProvider>(context);
    final events = provider.markersList.where((m) => (!m.isApproved)).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Eventos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(event.isApproved ? Icons.check_circle : Icons.event,
                  color: event.isApproved ? Colors.green : Colors.blue),
              title: Text(event.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  "${event.description}\n📅 ${event.startDate} - ${event.endDate}\n⏰ ${event.startTime} - ${event.endTime}"),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => approveEvent(event.id),
                  ),
                  /*IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => removeEvent(event.id),
                  ),*/
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
