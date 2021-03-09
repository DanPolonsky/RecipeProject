import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/audio_classes/SpeechRecognition.dart';
import 'package:flutter_app/pages/recipe_page/recipe_page_provider.dart';

import 'package:porcupine/porcupine_error.dart';
import 'package:porcupine/porcupine_manager.dart';
import 'package:provider/provider.dart';

class HotKeyWordDetection {
    static BuildContext _context;
    static PorcupineManager _porcupineManager;
    static RecipePageProvider _recipePageProvider;

    HotKeyWordDetection(BuildContext context) {
        _context = context;
        _recipePageProvider = Provider.of<RecipePageProvider>(_context, listen: false);
        initializeKeyWordDetector();
    }


    ///HotKeyWordDetection

    ///Function initializes PorcupineManager for keyword detection, called once in WaitingPage
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

    static Future<void> startKeyWordDetection() async {
        try {
            await _porcupineManager.start();
        } on PvAudioException catch (ex) {
            print("Failed to start audio capture: ${ex.message}");
            _recipePageProvider.notifyError("audio error");
        }
    }

    static Future<void> stopKeyWordDetection() async {
        await _porcupineManager.stop();
    }

    static void wakeWordCallback(int keywordIndex) {
        if (keywordIndex >= 0) {
            print("detected alexa");
            stopKeyWordDetection();
            SpeechRecognition.startListening();
        }
    }

    static void errorCallback(PvError error) {
        print(error.message);
        _recipePageProvider.notifyError("audio error");

    }


}