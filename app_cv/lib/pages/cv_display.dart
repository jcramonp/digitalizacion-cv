import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_cv/models/cv.dart';
import 'package:smart_cv/services/api_services.dart';

class CVDisplayPage extends StatefulWidget {
  final CV cv;

  const CVDisplayPage({Key? key, required this.cv}) : super(key: key);

  @override
  State<CVDisplayPage> createState() => _CVDisplayPageState();
}

class EditableInfoBox extends StatefulWidget {
  final String title;
  final String? value;

  const EditableInfoBox({Key? key, required this.title, required this.value})
    : super(key: key);

  @override
  EditableInfoBoxState createState() => EditableInfoBoxState();
}

class EditableInfoBoxState extends State<EditableInfoBox> {
  late TextEditingController _controller;

  String get currentText => _controller.text;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Color.fromARGB(255, 145, 66, 255).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconForTitle(widget.title),
                size: 18,
                color: Color.fromARGB(255, 145, 66, 255),
              ),
              SizedBox(width: 8),
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 145, 66, 255),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: null,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 145, 66, 255),
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.all(12),
              filled: true,
              fillColor: Colors.grey[50],
              hintText: 'Escribe aquí...',
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'nombre':
        return Icons.person;
      case 'correo':
        return Icons.email;
      case 'teléfono':
        return Icons.phone;
      case 'habilidades':
        return Icons.psychology;
      case 'dirección':
        return Icons.location_on;
      case 'educación':
        return Icons.school;
      case 'experiencia':
        return Icons.work;
      default:
        return Icons.info;
    }
  }
}

class _CVDisplayPageState extends State<CVDisplayPage> {
  final nombreKey = GlobalKey<EditableInfoBoxState>();
  final correoKey = GlobalKey<EditableInfoBoxState>();
  final telefonoKey = GlobalKey<EditableInfoBoxState>();
  final habilidadesKey = GlobalKey<EditableInfoBoxState>();
  final direccionKey = GlobalKey<EditableInfoBoxState>();
  final educacionKey = GlobalKey<EditableInfoBoxState>();
  final experienciaKey = GlobalKey<EditableInfoBoxState>();

  File? _selectedImage;
  bool _isSaving = false;

  Widget _buildPhotoBox() {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _selectedImage = File(pickedFile.path);
          });
        }
      },
      child: Container(
        width: 160,
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 145, 66, 255).withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Color.fromARGB(255, 145, 66, 255).withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            _selectedImage == null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 60,
                        color: Color.fromARGB(255, 192, 149, 252),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Añadir foto",
                        style: TextStyle(
                          color: Color.fromARGB(255, 145, 66, 255),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
                : ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
            if (_selectedImage != null)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 145, 66, 255),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "CV",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 145, 66, 255),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 145, 66, 255).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              80,
            ), // Espacio para los botones
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Título
                  Text(
                    "Mi Currículum",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 145, 66, 255),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Edita tu información",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),

                  // Contenido en columnas
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Columna izquierda
                      Expanded(
                        child: Column(
                          children: [
                            _buildPhotoBox(),
                            EditableInfoBox(
                              key: nombreKey,
                              title: "Nombre",
                              value: widget.cv.nombre,
                            ),
                            EditableInfoBox(
                              key: correoKey,
                              title: "Correo",
                              value: widget.cv.correo,
                            ),
                            EditableInfoBox(
                              key: telefonoKey,
                              title: "Teléfono",
                              value: widget.cv.telefono,
                            ),
                            EditableInfoBox(
                              key: habilidadesKey,
                              title: "Habilidades",
                              value: widget.cv.habilidades,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Columna derecha
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: 16), // Alinear con la foto
                            EditableInfoBox(
                              key: direccionKey,
                              title: "Dirección",
                              value: widget.cv.direccion,
                            ),
                            EditableInfoBox(
                              key: educacionKey,
                              title: "Educación",
                              value: widget.cv.educacion,
                            ),
                            EditableInfoBox(
                              key: experienciaKey,
                              title: "Experiencia",
                              value: widget.cv.experiencia,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey[800],
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    _isSaving
                        ? null
                        : () async {
                          setState(() {
                            _isSaving = true;
                            widget.cv.nombre =
                                nombreKey.currentState?.currentText ?? '';
                            widget.cv.correo =
                                correoKey.currentState?.currentText ?? '';
                            widget.cv.telefono =
                                telefonoKey.currentState?.currentText ?? '';
                            widget.cv.habilidades =
                                habilidadesKey.currentState?.currentText ?? '';
                            widget.cv.direccion =
                                direccionKey.currentState?.currentText ?? '';
                            widget.cv.educacion =
                                educacionKey.currentState?.currentText ?? '';
                            widget.cv.experiencia =
                                experienciaKey.currentState?.currentText ?? '';
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text("Guardando CV..."),
                                ],
                              ),
                              backgroundColor: Color.fromARGB(
                                255,
                                145,
                                66,
                                255,
                              ),
                            ),
                          );

                          print(widget.cv.toJson());
                          await ApiService.saveCV(widget.cv, context);

                          setState(() {
                            _isSaving = false;
                          });
                        },
                icon:
                    _isSaving
                        ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.save),
                label: Text(_isSaving ? 'Guardando...' : 'Guardar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 145, 66, 255),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
