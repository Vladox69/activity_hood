import 'dart:async';
import 'package:activity_hood/presentation/routes/routes.dart';
import 'package:activity_hood/presentation/screens/request_permision/request_permision_controller.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestPermisionScreen extends StatefulWidget {
  const RequestPermisionScreen({super.key});

  @override
  State<RequestPermisionScreen> createState() => _RequestPermisionScreenState();
}

class _RequestPermisionScreenState extends State<RequestPermisionScreen>
    with WidgetsBindingObserver {
  final _controller = RequestPermisionController(Permission.locationWhenInUse);
  late StreamSubscription _subscription;
  bool _fromSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = _controller.onStatusChanged.listen((status) {
      if (!mounted) return; // Verifica si el widget aún está en la pantalla

      switch (status) {
        case PermissionStatus.granted:
          _goToHome();
          break;
        case PermissionStatus.permanentlyDenied:
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("INFO"),
              content: const Text(
                  "Ingresa a ajustes para dar los permisos de ubicación"),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    _fromSettings = await openAppSettings();
                    if (!mounted) return;
                  },
                  child: const Text("Ir a configuraciones"),
                ),
                TextButton(
                  onPressed: () {
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                )
              ],
            ),
          );
          break;
        default:
          break;
      }
    });
  }

  void _goToHome() {
    Navigator.pushReplacementNamed(context, Routes.HOME);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _fromSettings) {
      final status = await _controller.check();
      if (status == PermissionStatus.granted) {
        _goToHome();
      }
    }
    _fromSettings = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: ElevatedButton(
            onPressed: () {
              _controller.request();
            },
            child: const Text("Allow")),
      )),
    );
  }
}
