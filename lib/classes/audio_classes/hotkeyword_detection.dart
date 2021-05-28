import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/audio_classes/SpeechRecognition.dart';
import 'package:flutter_app/pages/recipe_page/recipe_page_provider.dart';

import 'package:porcupine/porcupine_error.dart';
import 'package:porcupine/porcupine_manager.dart';
import 'package:provider/provider.dart';


/// Class containing hot key word detection functions and features
class HotKeyWordDetection {
    static BuildContext _context; // The context variable of the app, used to access the RecipePageProvider
    static PorcupineManager _porcupineManager; // Main object used to detect key word
    static RecipePageProvider _recipePageProvider; // Object representing the RecipePageProvider

    HotKeyWordDetection(BuildContext context) {
        _context = context;
        _recipePageProvider = Provider.of<RecipePageProvider>(_context, listen: false);
        initializeKeyWordDetector();
    }



    /// Function initializes PorcupineManager for keyword detection, saves if succeeds in RecipePageProvider
    static Future<void> initializeKeyWordDetector() async {
        try {
            _porcupineManager = await PorcupineManager.fromKeywords(
                ["alexa"], wakeWordCallback,
                errorCallback: errorCallback);
            _recipePageProvider.hotKeywordDetectionAvailable = true;
        } on PvError catch (ex) {
            print("Failed to initialize Porcupine: ${ex.message}");
            _recipePageProvider.hotKeywordDetectionAvailable = false;
        }
    }

    /// Function starts the detection of the key word
    static Future<void> startKeyWordDetection() async {
        try {
            await _porcupineManager.start();
        } on PvAudioException catch (ex) {
            print("Failed to start audio capture: ${ex.message}");
            _recipePageProvider.notifyError("audio error");
        }
    }

    /// Function stops the detection
    static Future<void> stopKeyWordDetection() async {
        await _porcupineManager.stop();
    }

    /// The call back function, activated when key word is detected.
    /// [keywordIndex] indicates which key word is detected
    static void wakeWordCallback(int keywordIndex) {
        if (keywordIndex >= 0) {
            print("detected alexa");
            stopKeyWordDetection();
            SpeechRecognition.startListening();
        }
    }

    /// The call back function when error occurred
    static void errorCallback(PvError error) {
        print(error.message);
        _recipePageProvider.notifyError("audio error");

    }


}