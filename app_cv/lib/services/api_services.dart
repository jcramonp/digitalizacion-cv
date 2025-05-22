import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_cv/models/cv.dart';
import 'package:smart_cv/pages/cv_display.dart';
import 'package:smart_cv/main.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart'; // <-

class ApiService {
  //static const String _baseUrl = 'http://10.0.2.2:8000/api/cv/parse/'; // URL para la ruta de parseo
  static String get _baseUrl => '${getBaseUrl()}/api/cv/parse/';

  static Future<void> sendTextToBackend(String texto) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'texto': texto}), // Enviar solo el texto al endpoint
    );

    if (response.statusCode == 200) {
      print('Texto enviado correctamente');
      receiveProcessedCV(response.body); //Agregado manualmente
    } else {
      print('Error al enviar texto: ${response.body}');
    }
  }

  static Future<void> receiveProcessedCV(String responseBody) async {
    final Map<String, dynamic> data = jsonDecode(responseBody);

    // Construye el objeto CV directamente
    final cv = CV(
      nombre: data['nombre'] ?? 'No disponible',
      correo: data['correo'] ?? 'No disponible',
      telefono: data['teléfono'] ?? 'No disponible',
      direccion: data['dirección'] ?? 'No disponible',
      experiencia:
          (data['experiencia'] as List<dynamic>?)
              ?.map((e) => '${e['año']}: ${e['puesto']}\n${e['descripción']}')
              .join('\n\n') ??
          'No disponible',
      educacion:
          (data['educación'] as List<dynamic>?)
              ?.map((e) => '${e['año']}: ${e['titulo']}\n${e['institución']}')
              .join('\n\n') ??
          'No disponible',
      habilidades:
          (data['habilidades'] as List<dynamic>?)?.join(', ') ??
          'No disponible',
    );

    // Debug
    print('CV creado: ${cv.toString()}');

    // Usa la nueva versión de handleProcessedCV
    await handleProcessedCV(cv);
  }

  static Future<void> handleProcessedCV(CV cv) async {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => CVDisplayPage(cv: cv)),
    );
  }

  static String getBaseUrl() {
    // Puedes agregar más condiciones según el entorno o IP del dispositivo
    // Esto es solo un ejemplo, puedes ajustarlo a lo que necesites
    const bool runningOnEmulator =
        false; // cambia a false si estás en celular real

    if (runningOnEmulator) {
      return 'http://10.0.2.2:8000'; // Emulator (conecta al host)
    } else {
      return 'http://192.168.69.64:8000'; // <- IP WIFI, IP WIFI2  192.168.1.8:8000 , IP DE NOSE http://192.168.70.64:8000, 192.168.231.64:8000
    }
  }

  static Future<void> saveCV2(CV cv, BuildContext context) async {
    //<- Original y funcional
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    //Debug para verificar el token y los datos
    print('Token usado: $token');
    print('Datos del CV a enviar: ${cv.toJson()}'); // ← Nuevo print para debug

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token no encontrado. Por favor, inicia sesión.'),
        ),
      );
      return;
    }

    final url = Uri.parse('${ApiService.getBaseUrl()}/api/save_cv/');

    //Cambio clave: Elimina el anidamiento en 'data'
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token', // <- "Token" con T mayúscula
      },
      body: json.encode(cv.toJson()), // <- Envía directamente el objeto CV
    );

    // Manejo mejorado de respuestas
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CV guardado exitosamente')));
    } else {
      // Debug detallado del error
      print('Error del servidor (${response.statusCode}): ${response.body}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.statusCode == 400
                ? 'Error en los datos: ${response.body}'
                : 'Error al guardar (${response.statusCode})',
          ),
        ),
      );
    }
  }

  static Future<CV?> loadCV2(BuildContext context) async {
    //<- original y funcional
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    // Verifica si hay token
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión primero')),
      );
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiService.getBaseUrl()}/api/load_cv/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Decodifica el JSON y convierte a objeto CV
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return CV.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No tienes ningún CV guardado')),
        );
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar CV: ${e.toString()}')),
      );
      debugPrint('Error en loadCV: $e');
    }
    return null;
  }

  //TEST

  static Future<void> saveCV(CV cv, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    print('[saveCV] Token usado: $token');
    print('[saveCV] CV a enviar (cv.toJson()): ${cv.toJson()}');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token no encontrado. Por favor, inicia sesión.'),
        ),
      );
      return;
    }

    final url = Uri.parse('${ApiService.getBaseUrl()}/api/save_cv/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: json.encode(cv.toJson()),
    );

    print(
      '[saveCV] Respuesta del servidor (${response.statusCode}): ${response.body}',
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CV guardado exitosamente')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.statusCode == 400
                ? 'Error en los datos: ${response.body}'
                : 'Error al guardar (${response.statusCode})',
          ),
        ),
      );
    }
  }

  //

  static Future<CV?> loadCV(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    print('[loadCV] Token usado: $token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión primero')),
      );
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiService.getBaseUrl()}/api/load_cv/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      print(
        '[loadCV] Respuesta del servidor (${response.statusCode}): ${response.body}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print('[loadCV] JSON decodificado: $jsonData');

        final cv = CV.fromJson(jsonData);
        print('[loadCV] Objeto CV creado: ${cv.toJson()}');

        return cv;
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No tienes ningún CV guardado')),
        );
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar CV: ${e.toString()}')),
      );
      debugPrint('[loadCV] Error: $e');
    }

    return null;
  }
}
