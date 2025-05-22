import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/login_page.dart';
import 'pages/menu_page.dart';
import 'pages/register_page.dart';
import 'pages/welcome_page.dart'; // nueva pantalla de bienvenida

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Smart CV',
      initialRoute: '/', // ruta inicial es welcome
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MenuPage(),
      },
    );
  }
}
