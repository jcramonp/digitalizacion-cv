class cv {
  final String? nombre;
  final String? correo;
  final String? telefono;
  final String? direccion;
  final String? experiencia;
  final String? educacion;
  final String? habilidades;

  cv({
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
}
