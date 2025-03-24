import 'package:activity_hood/config/theme/app_theme.dart';
import 'package:activity_hood/presentation/providers/current_marker_provider.dart';
import 'package:activity_hood/presentation/routes/routes.dart';
import 'package:activity_hood/presentation/routes/screens.dart';
import 'package:activity_hood/presentation/screens/login/auth_provider.dart';
import 'package:activity_hood/presentation/screens/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentMarkerProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SplashController()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme(selectedColor: 0).theme(),
        initialRoute: Routes.SPLASH,
        routes: appRoutes(),
      ),
    );
  }
}
