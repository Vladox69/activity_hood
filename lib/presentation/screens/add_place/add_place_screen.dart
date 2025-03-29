import 'package:activity_hood/constants/Category.dart';
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
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  String? _selectedCategory; // Estado para la categoría seleccionada

  final List<String> _categories = [
    Category.FOOD,
    Category.CONCERT,
    Category.PARK,
    Category.GARAGE_SALE,
    Category.OTHER
  ];

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Lugar")),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: "Título")),
              TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Descripción")),

              // 🔹 Dropdown para seleccionar categoría
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Categoría"),
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),

              TextFormField(
                controller: _startDateController,
                decoration: const InputDecoration(labelText: "Fecha Inicio"),
                readOnly: true,
                onTap: () => _selectDate(context, _startDateController),
              ),
              TextFormField(
                controller: _endDateController,
                decoration: const InputDecoration(labelText: "Fecha Fin"),
                readOnly: true,
                onTap: () => _selectDate(context, _endDateController),
              ),
              TextFormField(
                controller: _startTimeController,
                decoration: const InputDecoration(labelText: "Hora de inicio"),
                readOnly: true,
                onTap: () => _selectTime(context, _startTimeController),
              ),
              TextFormField(
                controller: _endTimeController,
                decoration: const InputDecoration(labelText: "Hora de fin"),
                readOnly: true,
                onTap: () => _selectTime(context, _endTimeController),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<CurrentMarkerProvider>().saveMarker(
                      _titleController.text,
                      _descriptionController.text,
                      _startDateController.text,
                      _endDateController.text,
                      _startTimeController.text,
                      _endTimeController.text,
                      _selectedCategory!);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("INFORMACIÓN"),
                        content: const Text(
                            "Evento agregado correctamente. \nDebe esperar a que un administrador lo acepte."),
                        actions: [
                          TextButton(
                            onPressed: () => {Navigator.of(context).pop()},
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  ).then((_) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  });
                },
                child: const Text("Guardar Lugar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
