import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:porcupine/porcupine_manager.dart';
import 'package:porcupine/porcupine_error.dart';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';


class RecipePageProvider extends ChangeNotifier {
  List<String> _ingredients;
  List<String> _steps;

  SpeechToText _speech = SpeechToText();

  bool _speechDetectionAvailable = true;
  bool _keyWordDetectionAvailable = true;
  String _finalResult;
  String get finalResult => _finalResult;


  Future<void> initializeSpeechDetection() async {
     _speechDetectionAvailable = await _speech.initialize(
        onError: errorListener, onStatus: statusListener);

  }

  void startListening() {
    _speech.listen(onResult: resultListener);
  }

  void resultListener(SpeechRecognitionResult result) {
    print('recognized ${result.recognizedWords} - ${result.finalResult}');
    if(result.finalResult){
      print("final");
      _finalResult = result.recognizedWords;
      notifyListeners();
    }

  }

  void errorListener(SpeechRecognitionError error) {
    print('${error.errorMsg} - ${error.permanent}');
  }

  void statusListener(String status) {
    print('status: $status');
  }



  // Hot keyword detector
  PorcupineManager _porcupineManager;

  ///Function provider with recipe specific information
  void initializeProviderVariables(String ingredients, String steps) async {
    _ingredients = ingredients.split("\n");
    //Todo: check if \n is good pattern to split on - idea: remove all \n from recipe steps and ingredients
    _steps = steps.split("\n");
  }

  ///Function initializes PorcupineManager for keyword detection, called once in WaitingPage
  Future<void> initializeKeyWordDetector() async {
    try {
      _porcupineManager = await PorcupineManager.fromKeywords(
          ["alexa"], wakeWordCallback,
          errorCallback: errorCallback);

    } on PvError catch (ex) {
      print("Failed to initialize Porcupine: ${ex.message}");
      _keyWordDetectionAvailable = false;
      //Todo: call notifyListeners
    }
  }

  Future<void> startKeyWordDetection() async {
    try {
      await _porcupineManager.start();
    } on PvAudioException catch (ex) {
      print("Failed to start audio capture: ${ex.message}");
      _keyWordDetectionAvailable = false;
    }
  }

  Future<void> stopKeyWordDetection() async {
    await _porcupineManager.stop();
  }

  void wakeWordCallback(int keywordIndex) {
    if (keywordIndex >= 0) {
      print("detected");
      if(_speechDetectionAvailable) {
        startListening();
      }
      else{
        print("not available");
        // notifyListeners
      }
    }
  }

  void errorCallback(PvError error) {
    print(error.message);
  }
}
