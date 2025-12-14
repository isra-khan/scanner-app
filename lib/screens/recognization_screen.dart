import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/recognition_controller.dart';
import '../utils/responsive_util.dart';

class RecognizationScreen extends StatelessWidget {
  final XFile image;

  const RecognizationScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    // Inject the controller with the image
    final RecognitionController controller = Get.put(
      RecognitionController(image),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Recognition',
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: Responsive.sp(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Image.file(File(image.path), fit: BoxFit.contain),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Responsive.w(20)),
                  topRight: Radius.circular(Responsive.w(20)),
                ),
              ),
              padding: EdgeInsets.all(Responsive.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recognized Text",
                        style: GoogleFonts.lato(
                          fontSize: Responsive.sp(18),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.copy,
                          color: Colors.black54,
                          size: Responsive.w(24),
                        ),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: controller.result.value),
                          );
                          Get.snackbar(
                            'Copied',
                            'Text copied to clipboard',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            colorText: Colors.black,
                            margin: EdgeInsets.all(Responsive.w(16)),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.h(10)),
                  Expanded(
                    child: Obx(() {
                      if (controller.isRecognizing.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SingleChildScrollView(
                        child: Text(
                          controller.result.value.isEmpty
                              ? "No text found"
                              : controller.result.value,
                          style: GoogleFonts.lato(
                            fontSize: Responsive.sp(16),
                            color: Colors.black54,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
