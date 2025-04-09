import 'package:flutter/material.dart';
import 'pages/ocr_page.dart'; // Importamos la pantalla

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // <- Esto es clave
      title: 'Smart CV',
      home: OCRPage(),
    );
  }
}
