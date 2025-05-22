import 'package:flutter/material.dart';
import 'package:smart_cv/pages/cv_display.dart';
import 'package:smart_cv/pages/ocr_page.dart';
import 'package:smart_cv/pages/voice_page.dart';
import 'package:smart_cv/services/api_services.dart';
import 'package:smart_cv/models/cv.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Smart CV',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
            colors: [Colors.grey[100]!, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.8, end: 1.0),
                    duration: Duration(seconds: 1),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(
                                  255,
                                  145,
                                  66,
                                  255,
                                ).withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: Image.asset(
                              'assets/images/Logo.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50),

                  // Botones con efecto de elevación y animación
                  _buildAnimatedButton(
                    context,
                    'Foto',
                    Icons.camera_alt_rounded,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OCRPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  _buildAnimatedButton(context, 'Voz', Icons.mic_rounded, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VoicePage()),
                    );
                  }),
                  const SizedBox(height: 24),

                  _buildAnimatedButton(
                    context,
                    'Perfil',
                    Icons.person_rounded,
                    () async {
                      CV? cv = await ApiService.loadCV(context);
                      if (cv != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CVDisplayPage(cv: cv),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 145, 66, 255).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Ink(
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
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
