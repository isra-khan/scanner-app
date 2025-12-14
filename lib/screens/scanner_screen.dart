import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/scanner_controller.dart';
import '../utils/responsive_util.dart';
import '../widgets/camera_overlay.dart';
import '../widgets/control_bar.dart';
import '../widgets/top_bar.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScannerController controller = Get.put(ScannerController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            const TopBar(),

            // Camera Preview Area
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Obx(() {
                    if (controller.isCameraInitialized.value &&
                        controller.controller != null &&
                        controller.controller!.value.isInitialized) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(Responsive.w(24)),
                        child: CameraPreview(
                          controller.controller!,
                          key: ValueKey(controller.controller!.hashCode),
                        ),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(Responsive.w(24)),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        ),
                      );
                    }
                  }),

                  // Dark Overlay with Cutout
                  const CameraOverlay(),
                ],
              ),
            ),

            // Bottom Control Bar
            ControlBar(
              onImageSelected: controller.onImageSelected,
              onTakePicture: controller.takePicture,
              onSwitchCamera: controller.switchCamera,
            ),
          ],
        ),
      ),
    );
  }
}
