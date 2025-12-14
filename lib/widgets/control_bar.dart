import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/responsive_util.dart';

class ControlBar extends StatelessWidget {
  final Function(XFile?)? onImageSelected;
  final VoidCallback? onTakePicture;
  final VoidCallback? onSwitchCamera;

  const ControlBar({
    super.key,
    this.onImageSelected,
    this.onTakePicture,
    this.onSwitchCamera,
  });

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (onImageSelected != null) {
        onImageSelected!(image);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(32),
        vertical: Responsive.h(24),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5B8DEF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Responsive.w(32)),
          topRight: Radius.circular(Responsive.w(32)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Switch Camera Button
          IconButton(
            onPressed: onSwitchCamera,
            icon: Icon(
              Icons.autorenew,
              color: Colors.white,
              size: Responsive.w(24),
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              padding: EdgeInsets.all(Responsive.w(12)),
            ),
          ),

          // Shutter Button
          GestureDetector(
            onTap: onTakePicture,
            child: Container(
              width: Responsive.w(72),
              height: Responsive.w(72),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: Responsive.w(10),
                    offset: Offset(0, Responsive.h(4)),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera,
                size: Responsive.w(40),
                color: const Color(0xFF5B8DEF),
              ),
            ),
          ),

          // Gallery Button
          IconButton(
            onPressed: _pickImage,
            icon: Icon(
              Icons.photo_library_outlined,
              color: Colors.white,
              size: Responsive.w(24),
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              padding: EdgeInsets.all(Responsive.w(12)),
            ),
          ),
        ],
      ),
    );
  }
}
