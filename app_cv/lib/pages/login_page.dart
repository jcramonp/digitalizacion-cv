import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_cv/services/api_services.dart';

// Función para guardar el token
Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

Future<void> login(
  String username,
  String password,
  BuildContext context,
) async {
  final url = Uri.parse('${ApiService.getBaseUrl()}/api/login/');

  print('Enviando solicitud de login a: $url');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'username': username, 'password': password}),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final token = responseData['token'];

    await saveToken(token);
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login fallido. Intenta de nuevo.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 145, 66, 255),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 30),
              // Logo o imagen
              Container(
                alignment: Alignment.center,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 145, 66, 255).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Color.fromARGB(255, 145, 66, 255),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Título
              Text(
                'Bienvenido de nuevo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 145, 66, 255),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Campos de texto
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de usuario',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 145, 66, 255),
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Color.fromARGB(255, 145, 66, 255),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 145, 66, 255),
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Color.fromARGB(255, 145, 66, 255),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Botón de login
              ElevatedButton(
                onPressed: () {
                  final username = usernameController.text;
                  final password = passwordController.text;
                  login(username, password, context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 145, 66, 255),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'INICIAR SESIÓN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Enlace a registro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No tienes una cuenta? ',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text(
                      'Regístrate',
                      style: TextStyle(
                        color: Color.fromARGB(255, 145, 66, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
