class Cv {
  final String? nombre;
  final String? correo;
  final String? telefono;
  final String? direccion;
  final String? experiencia;
  final String? educacion;
  final String? habilidades;

  Cv({
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

  // Método para crear una instancia de Cv a partir de un JSON
  factory Cv.fromJson(Map<String, dynamic> json) {
    return Cv(
      nombre: json['nombre'],
      correo: json['correo'],
      telefono: json['telefono'],
      direccion: json['direccion'],
      experiencia: json['experiencia'],
      educacion: json['educacion'],
      habilidades: json['habilidades'],
    );
  }
}
