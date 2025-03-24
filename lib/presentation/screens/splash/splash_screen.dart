import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<SplashController>(context, listen: false)
            .checkStatus(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashController>(
      builder: (context, splashController, child) {
        if (splashController.routeName != null && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacementNamed(
                  context, splashController.routeName!);
            }
          });
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
