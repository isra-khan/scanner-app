import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/pdf_controller.dart';
import '../utils/responsive_util.dart';

class PdfPreviewScreen extends StatelessWidget {
  final List<String> imagePaths;
  final bool isIdCard;

  const PdfPreviewScreen({
    super.key,
    required this.imagePaths,
    this.isIdCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final PdfController controller = Get.put(
      PdfController(imagePaths, isIdCard: isIdCard),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'PDF Preview',
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: Responsive.sp(20),
          ),
        ),
        actions: [
          Obx(
            () => controller.isGenerating.value
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: controller.sharePdf,
                    icon: const Icon(Icons.share, color: Colors.white),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(Responsive.w(16)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Responsive.w(8)),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.file(
                          File(imagePaths[index]),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.w(10),
                            vertical: Responsive.h(4),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(
                              Responsive.w(12),
                            ),
                          ),
                          child: Text(
                            "Page ${index + 1} of ${imagePaths.length}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Obx(() {
            if (controller.isGenerating.value) {
              return Padding(
                padding: EdgeInsets.all(Responsive.w(20)),
                child: const CircularProgressIndicator(color: Colors.white),
              );
            }
            return Padding(
              padding: EdgeInsets.all(Responsive.w(20)),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.sharePdf,
                  icon: const Icon(Icons.share),
                  label: Text(
                    "Share PDF",
                    style: GoogleFonts.lato(fontSize: Responsive.sp(16)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B8DEF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Responsive.w(12)),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
