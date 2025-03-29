import 'package:flutter/material.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  final outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40));
  void logout() {
    // Aquí puedes agregar la lógica de cierre de sesión
    Navigator.pushReplacementNamed(
        context, "/login"); // Redirige a la pantalla de login
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar',
          disabledBorder: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          filled: true,
          fillColor: Colors.white,
          // prefixIcon: const Icon(Icons.location_on_outlined)
        ),
        readOnly: true,
        onTap: () {},
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: logout,
        ),
      ],
    );
  }
}
