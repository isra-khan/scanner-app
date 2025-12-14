import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RecognitionController extends GetxController {
  final XFile image;
  RecognitionController(this.image);

  TextRecognizer? textRecognizer;
  var result = "".obs;
  var isRecognizing = true.obs;

  @override
  void onInit() {
    super.onInit();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    doTextRecognition();
  }

  @override
  void onClose() {
    textRecognizer?.close();
    super.onClose();
  }

  doTextRecognition() async {
    final inputImage = InputImage.fromFilePath(image.path);
    final recognizedText = await textRecognizer!.processImage(inputImage);

    result.value = recognizedText.text;
    isRecognizing.value = false;
  }
}
