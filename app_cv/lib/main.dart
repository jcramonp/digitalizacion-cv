import 'package:flutter/material.dart';
import 'pages/ocr_page.dart'; // Importamos la pantalla

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Smart CV', home: OCRPage());
  }
}
