import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:smart_cv/models/cv.dart';
import 'package:smart_cv/services/api_services.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({super.key});

  @override
  _VoicePageState createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage>
    with SingleTickerProviderStateMixin {
  TextEditingController _textController = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = 'Pulsa el botón y habla...';
  String voice_cv = "";

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('Status: $val'),
        onError: (val) => print('Error: $val'),
      );

      if (available) {
        setState(() => _isListening = true);
        _animationController.repeat(reverse: true);

        _speech.listen(
          onResult: (val) {
            setState(() {
              String newText = val.recognizedWords;
              _recognizedText = newText;
              _textController.text = _recognizedText;

              if (!voice_cv.endsWith(newText)) {
                voice_cv += newText + ' ';
              }

              print(_recognizedText);
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _animationController.stop();
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Reconocimiento de Voz',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 145, 66, 255),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 176, 122, 252).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // InfoBox
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 145, 66, 255),
                      Color.fromARGB(255, 165, 96, 255),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 145, 66, 255).withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Háblanos sobre ti y generaremos una hoja de vida a partir de tu Nombre, Experiencia, Habilidades, Trayectoria y otras cosas más.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  //textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              // TextField
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: 12, // Reducido de 8 a 4 líneas
                  decoration: InputDecoration(
                    hintText: 'Habla para llenar el texto...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(16), // Reducido de 20 a 16
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ),

              Spacer(),

              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isListening ? _animation.value : 1.0,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 145, 66, 255),
                            Color.fromARGB(255, 165, 96, 255),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(
                              255,
                              145,
                              66,
                              255,
                            ).withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _listen,
                          borderRadius: BorderRadius.circular(40),
                          child: Center(
                            child: Icon(
                              _isListening ? Icons.stop : Icons.mic,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 16),
              Text(
                _isListening ? 'Escuchando...' : 'Pulsa para hablar',
                style: TextStyle(
                  color: Color.fromARGB(255, 145, 66, 255),
                  fontWeight: FontWeight.w500,
                ),
              ),

              Spacer(),

              // Botón Visualizar modificado
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 20),
                  child: Container(
                    width: 120, // Ancho reducido
                    height: 48, // Altura reducida
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(
                            255,
                            145,
                            66,
                            255,
                          ).withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed:
                          _isProcessing
                              ? null
                              : () {
                                setState(() {
                                  _isProcessing = true;
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
                                        Text("Procesando texto..."),
                                      ],
                                    ),
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      145,
                                      66,
                                      255,
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                                ApiService.sendTextToBackend(voice_cv);
                                print('Finalizar presionado');

                                Future.delayed(Duration(seconds: 2), () {
                                  setState(() {
                                    _isProcessing = false;
                                  });
                                });
                              },
                      child:
                          _isProcessing
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text('Visualizar'), // Texto sin ícono
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 145, 66, 255),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
