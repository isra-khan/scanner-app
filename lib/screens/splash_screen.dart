import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scanner_screen.dart';
import '../utils/responsive_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.off(() => const ScannerScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B8DEF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use the asset image if available, otherwise show a placeholder icon
            Image.asset(
              'assets/splash.png',
              width: Responsive.w(150),
              height: Responsive.w(150),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: Responsive.w(150),
                  height: Responsive.w(150),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.document_scanner_rounded,
                    size: Responsive.w(80),
                    color: const Color(0xFF5B8DEF),
                  ),
                );
              },
            ),
            SizedBox(height: Responsive.h(24)),
            Text(
              'Scanner App',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: Responsive.sp(32),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Responsive.h(10)),
            Text(
              'Scan • Recognize • Enhance',
              style: GoogleFonts.lato(
                color: Colors.white.withOpacity(0.8),
                fontSize: Responsive.sp(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
