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

class _RequestPermisionScreenState extends State<RequestPermisionScreen> {
  final _controller = RequestPermisionController(Permission.locationWhenInUse);
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _controller.onStatusChanged.listen((status) {
      if (status == PermissionStatus.granted) {
        Navigator.pushReplacementNamed(context, Routes.HOME);
      }
    });
  }

  @override
  void dispose() {
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
