import 'package:activity_hood/presentation/routes/routes.dart';
import 'package:activity_hood/presentation/screens/login/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SplashController extends ChangeNotifier {
  String? _routeName;
  String? get routeName => _routeName;

  Future<void> checkStatus(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      _routeName = Routes.LOGIN;
    } else {
      final status = await Permission.locationWhenInUse.status;
      if (!status.isGranted) {
        _routeName = Routes.PERMISSIONS;
      } else {
        _routeName =
            authProvider.role == "admin" ? Routes.ADMIN_HOME : Routes.USER_HOME;
      }
    }

    notifyListeners(); // Asegura que el cambio en `_routeName` se refleje en la UI
  }
}
