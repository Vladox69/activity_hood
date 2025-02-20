import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:activity_hood/presentation/providers/current_marker_provider.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Lugar")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Título")),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: "Descripción")),
            TextField(controller: _dateController, decoration: const InputDecoration(labelText: "Fecha")),
            TextField(controller: _startTimeController, decoration: const InputDecoration(labelText: "Hora de inicio")),
            TextField(controller: _endTimeController, decoration: const InputDecoration(labelText: "Hora de fin")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<CurrentMarkerProvider>().saveMarker(
                      context,
                      _titleController.text,
                      _descriptionController.text,
                      _dateController.text,
                      _startTimeController.text,
                      _endTimeController.text,
                    );
                Navigator.pop(context);
              },
              child: const Text("Guardar Lugar"),
            ),
          ],
        ),
      ),
    );
  }
}
