import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart' as cropper;
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/pdf_preview_screen.dart';
import '../screens/recognization_screen.dart';

enum ScanMode { scan, recognize, enhance, idCard }

class ScannerController extends GetxController with WidgetsBindingObserver {
  CameraController? controller;
  var isCameraInitialized = false.obs;
  List<CameraDescription> cameras = [];
  var selectedCameraIndex = 0;

  // Track the current mode (Scan vs Recognize vs Enhance vs ID Card)
  var currentMode = ScanMode.recognize.obs;
  var idCardSide = 0.obs; // 0 = Front, 1 = Back
  String? idFrontPath;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    initializeCamera();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // If app is inactive (background), dispose camera to free resources
    if (state == AppLifecycleState.inactive) {
      isCameraInitialized.value = false; // Explicitly mark as uninitialized
      cameraController?.dispose();
    }
    // If app is resumed (foreground), re-initialize camera if needed
    else if (state == AppLifecycleState.resumed) {
      // Only initialize if we are NOT in 'Scan' mode (which uses native scanner)
      if (currentMode.value != ScanMode.scan) {
        initializeCamera();
      }
    }
  }

  Future<void> initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isDenied) return;

    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // If we already have a controller, dispose it first and wait
        if (controller != null) {
          await controller!.dispose();
          controller = null; // Clear reference immediately
        }

        final newController = CameraController(
          cameras[selectedCameraIndex],
          ResolutionPreset.high,
          enableAudio: false,
        );

        // Initialize the new controller
        await newController.initialize();

        // Only assign it if it was successfully initialized
        controller = newController;
        isCameraInitialized.value = true;
        update();
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      isCameraInitialized.value = false;
    }
  }

  void setMode(int index) {
    switch (index) {
      case 0:
        currentMode.value = ScanMode.recognize;
        // Ensure camera is ready for Recognize mode
        if (!isCameraInitialized.value) initializeCamera();
        break;
      case 1:
        currentMode.value = ScanMode.scan;
        // Automatically trigger scanner when switching to Scan mode
        takePicture();
        break;
      case 2:
        currentMode.value = ScanMode.enhance;
        // Ensure camera is ready for Enhance mode
        if (!isCameraInitialized.value) initializeCamera();
        break;
      case 3:
        currentMode.value = ScanMode.idCard;
        idCardSide.value = 0; // Reset to Front
        idFrontPath = null;
        // Ensure camera is ready for ID Card mode
        if (!isCameraInitialized.value) initializeCamera();
        break;
    }
  }

  Future<void> takePicture() async {
    // Check if controller is ready
    if (controller == null || !controller!.value.isInitialized) return;
    if (controller!.value.isTakingPicture) return;

    try {
      // Capture image from the "outside" (preview) camera
      final XFile picture = await controller!.takePicture();

      // Route based on mode
      if (currentMode.value == ScanMode.scan) {
        // Scan Mode: Use Native Scanner for Auto-Edge Detection
        try {
          List<String> pictures =
              await CunningDocumentScanner.getPictures() ?? [];
          if (pictures.isNotEmpty) {
            onImagesSelected(pictures);
          }
        } catch (e) {
          debugPrint('Error scanning document: $e');
        }
      } else if (currentMode.value == ScanMode.idCard) {
        // ID Card Logic
        if (idCardSide.value == 0) {
          idFrontPath = picture.path;
          idCardSide.value = 1;
          Get.snackbar(
            "Front Captured",
            "Now scan the back side of the ID card.",
          );
        } else {
          Get.to(
            () => PdfPreviewScreen(
              imagePaths: [idFrontPath!, picture.path],
              isIdCard: true,
            ),
          );
          idCardSide.value = 0;
          idFrontPath = null;
        }
      } else if (currentMode.value == ScanMode.recognize) {
        // Recognize Mode: Send to OCR
        onImageSelected(picture);
      } else if (currentMode.value == ScanMode.enhance) {
        // Enhance Mode: Send to Editor
        final editedImage = await Get.to(
          () => ImageEditor(image: File(picture.path).readAsBytesSync()),
        );

        if (editedImage != null) {
          final tempDir = await getTemporaryDirectory();
          final tempFile = File(
            '${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg',
          );
          await tempFile.writeAsBytes(editedImage);
          Get.to(() => PdfPreviewScreen(imagePaths: [tempFile.path]));
        }
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  void switchCamera() {
    if (cameras.length < 2) return;
    isCameraInitialized.value = false;
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    initializeCamera();
  }

  void onImagesSelected(List<String> paths) {
    if (paths.isNotEmpty) {
      Get.to(() => PdfPreviewScreen(imagePaths: paths));
    }
  }

  void onImageSelected(XFile? image) {
    if (image != null) {
      if (currentMode.value == ScanMode.scan) {
        Get.to(() => PdfPreviewScreen(imagePaths: [image.path]));
      } else {
        Get.to(() => RecognizationScreen(image: image));
      }
    }
  }
}
