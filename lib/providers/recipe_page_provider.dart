import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:porcupine/porcupine_error.dart';
import 'package:porcupine/porcupine_manager.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';


class RecipePageProvider extends ChangeNotifier {

    FlutterTts _flutterTts = FlutterTts();
    double _volume = 0.7;
    double _pitch = 1.0;
    double _rate = 0.8;
    List<String> _ingredientsList;
    List<String> _stepsList;

    Map<String, int> wordsToNumbers = {
        "one":1,
        "two":2,
        "three":3,
        "four":4,
        "five":5,
        "six":6,
        "seven":7,
        "eight":8,
        "nine":9,
        "ten":10,
        "eleven":11,
        "twelve":12,
        "thirteen":13,
        "fourteen":14,
        "fifteen":15,
        "sixteen":16,
        "seventeen":17,
        "eighteen":18,
        "nineteen":19,
        "twenty":20
    };


    SpeechToText _speech = SpeechToText();
    bool _speechDetectionAvailable;

    bool get speechDetectionAvailable => _speechDetectionAvailable;


    bool _keyWordDetectionAvailable;

    bool get keyWordDetectionAvailable => _keyWordDetectionAvailable; // Hot keyword detector
    PorcupineManager _porcupineManager;


    bool _error = false;

    bool get error => _error;

    void initializeReadingVariables(List<String> ingredientsList, List<String> stepsList) {
        _ingredientsList = ingredientsList;
        _stepsList = stepsList;
    }


    bool checkListeningAvailability() {
        if (!_keyWordDetectionAvailable || !_speechDetectionAvailable) {
            //Todo: change to not available message
            return false;
        }
        return true;
    }

    void initializeAllListeningFunctions() {
        initializeSpeechDetection();
        initializeKeyWordDetector();
        initializeTextToSpeech();
    }


    ///HotKeyWordDetection

    ///Function initializes PorcupineManager for keyword detection, called once in WaitingPage
    Future<void> initializeKeyWordDetector() async {
        try {
            _porcupineManager = await PorcupineManager.fromKeywords(
                ["alexa"], wakeWordCallback,
                errorCallback: errorCallback);
            _keyWordDetectionAvailable = true;
        } on PvError catch (ex) {
            print("Failed to initialize Porcupine: ${ex.message}");

            _keyWordDetectionAvailable = false;
        }
    }

    Future<void> startKeyWordDetection() async {
        try {
            await _porcupineManager.start();
        } on PvAudioException catch (ex) {
            print("Failed to start audio capture: ${ex.message}");
            _error = true;

            notifyListeners();
        }
    }

    Future<void> stopKeyWordDetection() async {
        await _porcupineManager.stop();
    }

    void wakeWordCallback(int keywordIndex) {
        if (keywordIndex >= 0) {
            print("detected alexa");
            stopKeyWordDetection();
            startListening();
        }
    }

    void errorCallback(PvError error) {
        _error = true;
        print(error.message);
        notifyListeners();
    }


    ///SpeechToText
    Future<void> initializeSpeechDetection() async {
        _speechDetectionAvailable = await _speech.initialize(
            onError: errorListener, onStatus: statusListener);
    }

    void startListening() {
        _speech.listen(onResult: resultListener, cancelOnError: true);
    }

    void resultListener(SpeechRecognitionResult result) async {
        print('recognized ${result.recognizedWords} - ${result.finalResult}');
        if (result.finalResult) {
            String command = result.recognizedWords;
            print("command - $command");
            await readCommand(command);
            startKeyWordDetection();
        }
    }


    void errorListener(SpeechRecognitionError error) {
        print('${error.errorMsg} - ${error.permanent}');
//        if(error.errorMsg == "error_no_match"){
//
//        }
        startKeyWordDetection();
    }

    void statusListener(String status) {
        print('status: $status');
    }


    /// TextToSpeech

    void initializeTextToSpeech() async {
        List<dynamic> languages = await _flutterTts.getLanguages;


        await _flutterTts.setVolume(_volume);
        await _flutterTts.setSpeechRate(_rate);
        await _flutterTts.setPitch(_pitch);

        _flutterTts.setErrorHandler((msg) {
            _error = true;
            notifyListeners();
        });
    }

    void readCommand(String command) async {
        print("in read command");
        List<String> commandList = command.split(" ");
        print(commandList);
        if (commandList[0] == "read") {
            if (commandList[1] == "step") {
                print("reading");
                try {
                    await _flutterTts.speak(_stepsList[wordsToNumbers[commandList[2]]]);
                }
                catch (e) {
                    try{
                        await _flutterTts.speak(_stepsList[int.parse(commandList[2])]);
                    }
                    catch(e){
                        print("command not clear");
                    }
                }
                print("command not clear");
            }
        }
    }


}