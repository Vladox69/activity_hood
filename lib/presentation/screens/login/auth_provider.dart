import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _role; // Almacena el rol del usuario
  bool _isAuthenticated = false; // Estado de autenticación

  bool get isAuthenticated => _isAuthenticated;
  String? get role => _role;

  void login(String email, String password) {
    // Simulación de login
    if (email == "admin@test.com" && password == "123456") {
      _isAuthenticated = true;
      _role = "admin";
    } else if (email == "user@test.com" && password == "123456") {
      _isAuthenticated = true;
      _role = "user";
    } else {
      _isAuthenticated = false;
      _role = null;
    }
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _role = null;
    notifyListeners();
  }
}
