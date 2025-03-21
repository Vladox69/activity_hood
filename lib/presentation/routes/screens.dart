import 'package:activity_hood/presentation/routes/routes.dart';
import 'package:activity_hood/presentation/screens/google_map/google_map_screen.dart';
import 'package:activity_hood/presentation/screens/login/login_screen.dart';
import 'package:activity_hood/presentation/screens/request_permision/request_permision_screen.dart';
import 'package:activity_hood/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> appRoutes() {
  return {
    Routes.LOGIN: (_) => LoginScreen(),
    Routes.SPLASH: (_) => const SplashScreen(),
    Routes.PERMISSIONS: (_) => const RequestPermisionScreen(),
    Routes.HOME: (_) => const GoogleMapScreen(),
  };
}
