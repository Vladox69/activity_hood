import 'package:activity_hood/config/theme/app_theme.dart';
import 'package:activity_hood/presentation/providers/current_marker_provider.dart';
import 'package:activity_hood/presentation/screens/google_map/google_map_screen.dart';
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
        ChangeNotifierProvider(create: (_) => CurrentMarkerProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme(selectedColor: 0).theme(),
        home: const GoogleMapScreen(),
      ),
    );
  }
}
