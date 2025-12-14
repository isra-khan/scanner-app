import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/scanner_controller.dart';
import '../utils/responsive_util.dart';

class CameraOverlay extends StatelessWidget {
  const CameraOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final ScannerController controller = Get.find<ScannerController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Obx(() {
          // Adjust dimensions based on mode
          // Default: Document (Vertical A4ish ratio)
          double width = constraints.maxWidth * 0.85;
          double height = constraints.maxHeight * 0.7;

          // ID Card Mode: Smaller and landscape-ish
          if (controller.currentMode.value == ScanMode.idCard) {
            width = constraints.maxWidth * 0.85;
            height = width * 0.63; // Approximate ID card aspect ratio (85.6mm / 54mm)
          }

          return Stack(
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color.fromRGBO(0, 0, 0, 0.4),
                  BlendMode.srcOut,
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        backgroundBlendMode: BlendMode.dstOut,
                      ),
                    ),
                    Center(
                      child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(Responsive.w(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: Responsive.w(2),
                    ),
                    borderRadius: BorderRadius.circular(Responsive.w(12)),
                  ),
                  child: Stack(
                    children: [
                      // Corner Indicators
                      _buildCorner(true, true),
                      _buildCorner(true, false),
                      _buildCorner(false, true),
                      _buildCorner(false, false),

                      // ID Card Helper Text
                      if (controller.currentMode.value == ScanMode.idCard)
                        Center(
                          child: Text(
                            controller.idCardSide.value == 0
                                ? "Scan Front Side"
                                : "Scan Back Side",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: Responsive.sp(16),
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(blurRadius: 4, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildCorner(bool isTop, bool isLeft) {
    return Positioned(
      top: isTop ? -2 : null,
      bottom: isTop ? null : -2,
      left: isLeft ? -2 : null,
      right: isLeft ? null : -2,
      child: Container(
        width: Responsive.w(24),
        height: Responsive.w(24),
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? BorderSide(color: const Color(0xFF5B8DEF), width: Responsive.w(4))
                : BorderSide.none,
            bottom: !isTop
                ? BorderSide(color: const Color(0xFF5B8DEF), width: Responsive.w(4))
                : BorderSide.none,
            left: isLeft
                ? BorderSide(color: const Color(0xFF5B8DEF), width: Responsive.w(4))
                : BorderSide.none,
            right: !isLeft
                ? BorderSide(color: const Color(0xFF5B8DEF), width: Responsive.w(4))
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: isTop && isLeft ? Radius.circular(Responsive.w(20)) : Radius.zero,
            topRight: isTop && !isLeft ? Radius.circular(Responsive.w(20)) : Radius.zero,
            bottomLeft: !isTop && isLeft ? Radius.circular(Responsive.w(20)) : Radius.zero,
            bottomRight: !isTop && !isLeft ? Radius.circular(Responsive.w(20)) : Radius.zero,
          ),
        ),
      ),
    );
  }
}

