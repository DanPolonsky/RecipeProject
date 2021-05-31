import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/audio_classes/hotkeyword_detection.dart';
import 'package:flutter_app/classes/audio_classes/text_to_speech.dart';
import 'package:flutter_app/pages/recipe_page/recipe_page_provider.dart';

import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechRecognition {
  static BuildContext
      _context; // The context variable of the app, used to access the RecipePageProvider
  static SpeechToText _speech; // Main object responsible for SpeechToText
  static RecipePageProvider
      _recipePageProvider; // Object representing the RecipePageProvider

  SpeechRecognition(BuildContext context) {
    _context = context;
    _recipePageProvider =
        Provider.of<RecipePageProvider>(_context, listen: false);
    _speech = SpeechToText();
    initializeSpeechRecognition();
  }

  /// Function initializes the SpeechToText object, saves success in RecipePageProvider
  static Future<void> initializeSpeechRecognition() async {
    _recipePageProvider.speechRecognitionAvailable = await _speech.initialize(
        onError: errorListener, onStatus: statusListener);
  }

  /// Function start the listening/recording of voice
  static void startListening() {
    _speech.listen(onResult: resultListener, cancelOnError: true);
  }

  /// Call back function for when a word is detected
  static void resultListener(SpeechRecognitionResult result) async {
    print('recognized ${result.recognizedWords} - ${result.finalResult}');
    if (result.finalResult) {
      String command = result.recognizedWords;
      print("command - $command");
      await TextToSpeech.readCommand(command);
      HotKeyWordDetection.startKeyWordDetection();
    }
  }

  /// Call back function for when error occures
  static void errorListener(SpeechRecognitionError error) {
    print('${error.errorMsg} - ${error.permanent}');
    if (error.errorMsg != "error_no_match" ||
        error.errorMsg != "error_timed_out") {
      HotKeyWordDetection.startKeyWordDetection();
    } else {
      _recipePageProvider.notifyError("audio error"); // add error type
    }
  }

  /// Call back function for when listening status changes
  static void statusListener(String status) {
    print('status: $status');
  }
}
