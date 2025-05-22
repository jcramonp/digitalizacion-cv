class CV {
  String? nombre;
  String? correo;
  String? telefono;
  String? direccion;
  String? experiencia;
  String? educacion;
  String? habilidades;

  CV({
    this.nombre,
    this.correo,
    this.telefono,
    this.direccion,
    this.experiencia,
    this.educacion,
    this.habilidades,
  });

  @override
  String toString() {
    return '''
    Nombre: $nombre
    Correo: $correo
    Teléfono: $telefono
    Dirección: $direccion
    Experiencia: $experiencia
    Educación: $educacion
    Habilidades: $habilidades
    ''';
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'telefono': telefono,
      'direccion': direccion,
      'experiencia': experiencia,
      'educacion': educacion,
      'habilidades': habilidades,
    };
  }

  factory CV.fromJson(Map<String, dynamic> json) {
    return CV(
      nombre: json['nombre'] as String?,
      correo: json['correo'] as String?,
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      experiencia: json['experiencia'] as String?,
      educacion: json['educacion'] as String?,
      habilidades: json['habilidades'] as String?,
    );
  }

  factory CV.fromJson2(Map<String, dynamic> json) {
    final data = json['data'];
    print("test");
    return CV(
      experiencia: (data['experiencia'] as List<dynamic>).join('\n\n'),
      educacion: (data['educacion'] as List<dynamic>).join('\n\n'),
      habilidades: (data['habilidades'] as List<dynamic>).join(', '),
    );
  }

  factory CV.fromJson3(Map<String, dynamic> data) {
    return CV(
      nombre: data['nombre'] ?? 'No disponible',
      correo: data['correo'] ?? 'No disponible',
      telefono: data['teléfono'] ?? 'No disponible',
      direccion: data['dirección'] ?? 'No disponible',
      experiencia:
          (data['experiencia'] as List<dynamic>?)
              ?.map(
                (e) =>
                    '${e['año'] ?? 'Año desconocido'}: ${e['puesto'] ?? 'Puesto desconocido'}\n${e['descripción'] ?? ''}',
              )
              .join('\n\n') ??
          'No disponible',
      educacion:
          (data['educación'] as List<dynamic>?)
              ?.map(
                (e) =>
                    '${e['año'] ?? 'Año desconocido'}: ${e['titulo'] ?? 'Título desconocido'}\n${e['institución'] ?? ''}',
              )
              .join('\n\n') ??
          'No disponible',
      habilidades:
          (data['habilidades'] as List<dynamic>?)?.join(', ') ??
          'No disponible',
    );
  }

  factory CV.fromJson4(Map<String, dynamic> data) {
    return CV(
      nombre: data['nombre'] ?? 'No disponible',
      correo: data['correo'] ?? 'No disponible',
      telefono: data['telefono'] ?? 'No disponible',
      direccion: data['direccion'] ?? 'No disponible',
      experiencia:
          (data['experiencia'] as List<dynamic>?)
              ?.map(
                (e) =>
                    '${e.toString().split(":")[0]}: ${e.toString().split(":")[1]}',
              ) // Esto separa correctamente el año del puesto
              .join('\n\n') ??
          'No disponible',
      educacion:
          (data['educacion'] as List<dynamic>?)
              ?.map(
                (e) =>
                    '${e.toString().split(":")[0]}: ${e.toString().split(":")[1]}',
              ) // Similar aquí, para dividir el año del título
              .join('\n\n') ??
          'No disponible',
      habilidades:
          (data['habilidades'] as List<dynamic>?)?.join(', ') ??
          'No disponible',
    );
  }
}
