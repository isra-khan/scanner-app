import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/scanner_controller.dart';
import '../utils/responsive_util.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ScannerController controller = Get.find<ScannerController>();
    final List<String> modes = ['Recognize', 'Scan', 'Enhance', 'ID Card'];
    final List<IconData> icons = [
      Icons.text_fields,
      Icons.document_scanner_outlined,
      Icons.auto_fix_high_outlined,
      Icons.badge_outlined,
    ];

    return Container(
      margin: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.w(16)),
      ),
      child: Obx(() {
        int selectedIndex;
        switch (controller.currentMode.value) {
          case ScanMode.recognize:
            selectedIndex = 0;
            break;
          case ScanMode.scan:
            selectedIndex = 1;
            break;
          case ScanMode.enhance:
            selectedIndex = 2;
            break;
          case ScanMode.idCard:
            selectedIndex = 3;
            break;
        }

        return Row(
          children: List.generate(modes.length, (index) {
            final isSelected = selectedIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.setMode(index),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Responsive.h(12)),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF5B8DEF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Responsive.w(16)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[index],
                        color: isSelected ? Colors.white : Colors.grey[600],
                        size: Responsive.w(20),
                      ),
                      SizedBox(height: Responsive.h(4)),
                      Text(
                        modes[index],
                        style: GoogleFonts.lato(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontSize: Responsive.sp(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
