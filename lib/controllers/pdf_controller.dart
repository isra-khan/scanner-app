import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class PdfController extends GetxController {
  final List<String> imagePaths;
  final bool isIdCard;
  PdfController(this.imagePaths, {this.isIdCard = false});

  var isGenerating = true.obs;
  String? pdfPath;

  @override
  void onInit() {
    super.onInit();
    generatePdf();
  }

  Future<void> generatePdf() async {
    try {
      final pdf = pw.Document();

      if (isIdCard && imagePaths.length == 2) {
        // ID Card Mode: Both images on one page
        final frontImage = pw.MemoryImage(
          File(imagePaths[0]).readAsBytesSync(),
        );
        final backImage = pw.MemoryImage(File(imagePaths[1]).readAsBytesSync());

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      "Front Side",
                      style: const pw.TextStyle(fontSize: 20),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Image(frontImage, height: 250, fit: pw.BoxFit.contain),
                    pw.SizedBox(height: 40),
                    pw.Text(
                      "Back Side",
                      style: const pw.TextStyle(fontSize: 20),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Image(backImage, height: 250, fit: pw.BoxFit.contain),
                  ],
                ),
              );
            },
          ),
        );
      } else {
        // Normal Mode: One image per page
        for (var path in imagePaths) {
          final image = pw.MemoryImage(File(path).readAsBytesSync());

          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.Center(
                  child: pw.Image(image, fit: pw.BoxFit.contain),
                );
              },
            ),
          );
        }
      }

      final output = await getTemporaryDirectory();
      final file = File(
        "${output.path}/scanned_document_${DateTime.now().millisecondsSinceEpoch}.pdf",
      );
      await file.writeAsBytes(await pdf.save());

      pdfPath = file.path;
      isGenerating.value = false;
    } catch (e) {
      Get.snackbar("Error", "Failed to generate PDF: $e");
    }
  }

  Future<void> sharePdf() async {
    if (pdfPath != null) {
      await Share.shareXFiles([
        XFile(pdfPath!),
      ], text: 'Here is my scanned document.');
    }
  }
}
