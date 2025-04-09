import 'package:smart_cv/models/cv.dart';

class CvParser {
  CV parseCVFromText(String rawText) {
    final emailRegex = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
    final phoneRegex = RegExp(
      r'(\+?\d{1,3})?[\s.-]?\(?\d{2,4}\)?[\s.-]?\d{3,4}[\s.-]?\d{3,4}',
    );

    String? correo = emailRegex.firstMatch(rawText)?.group(0);
    String? telefono = phoneRegex.firstMatch(rawText)?.group(0);
    String? nombre = _extraerNombre(rawText);

    return CV(
      nombre: nombre,
      correo: correo,
      telefono: telefono,
      direccion: null,
      experiencia: null,
      educacion: null,
      habilidades: null,
    );
  }

  String? _extraerNombre(String texto) {
    final lineas = texto.split('\n');

    final encabezadosIgnorados = [
      'CONTACTO',
      'PERFIL',
      'EXPERIENCIA',
      'EXPERIENCIA LABORAL',
      'EDUCACIÓN',
      'HABILIDADES',
      'DATOS PERSONALES',
    ];

    for (final linea in lineas) {
      final contenido = linea.trim();

      if (contenido.isEmpty) continue;

      // Ignoramos encabezados en mayúsculas
      if (encabezadosIgnorados.contains(contenido.toUpperCase())) continue;

      // Si tiene al menos 2 palabras y empieza con mayúsculas, lo tomamos como nombre
      if (contenido.split(' ').length >= 2 &&
          RegExp(
            r'^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+\s+[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+',
          ).hasMatch(contenido)) {
        return contenido;
      }
    }

    return null;
  }
}
