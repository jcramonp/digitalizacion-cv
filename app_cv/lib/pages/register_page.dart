import 'package:flutter/material.dart';
import 'package:smart_cv/services/api_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _registerUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    // Aquí luego se conectará al backend
    print('Registrando usuario: $username con contraseña: $password');

    final url = Uri.parse(
      '${ApiService.getBaseUrl()}/api/register/',
    ); // Usa la URL base con '/api/login/'

    print('Enviando solicitud de login a: $url');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 201) {
      // Registro exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuario registrado con éxito'),
          backgroundColor: Color.fromARGB(255, 145, 66, 255),
        ),
      );
      Navigator.pushReplacementNamed(context, '/login'); // Redirige al login
    } else {
      // Algo falló
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar. Intenta de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Registrarse',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 145, 66, 255),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
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
                    Icons.person_add_rounded,
                    size: 60,
                    color: Color.fromARGB(255, 145, 66, 255),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Título
              Text(
                'Crea tu cuenta',
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
                      controller: _usernameController,
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
                      controller: _passwordController,
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
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Botón de registro
              ElevatedButton(
                onPressed: _registerUser,
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
                  'REGISTRARSE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Enlace a login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes una cuenta? ',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'Iniciar sesión',
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
