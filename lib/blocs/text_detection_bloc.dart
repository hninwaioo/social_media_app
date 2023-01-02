import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import '../ml_kit/ml_kit_text_recognition.dart';

class TextDetectionBloc extends ChangeNotifier {
  File? chosenImageFile;

  ///MLKit

  final MLKitTextRecognition _mlKitTextRecognition = MLKitTextRecognition();
  onImageChosen(File imageFile, Uint8List bytes){
    chosenImageFile = imageFile;
    _mlKitTextRecognition.detectTexts(imageFile);
    notifyListeners();
  }
}