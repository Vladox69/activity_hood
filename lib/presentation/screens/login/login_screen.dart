import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  /*loginProvider.login(
                    emailController.text,
                    passwordController.text,
                  );*/
                },
                child: const Text('Iniciar Sesión'),
              ),
              /*if (loginProvider.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    loginProvider.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),*/
            ],
          ),
        ),
      ),
    );
  }
}

class LoginProvider extends ChangeNotifier {
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void login(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Los campos no pueden estar vacíos';
    } else {
      _errorMessage = '';
    }
    notifyListeners();
  }
}
