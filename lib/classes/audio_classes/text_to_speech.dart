import 'package:flutter/cupertino.dart';
import 'package:flutter_app/pages/recipe_page/recipe_page_provider.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class TextToSpeech {
    static BuildContext _context;
    static RecipePageProvider _recipePageProvider;
    static FlutterTts _flutterTts;

    static double _volume = 0.7;
    static double _pitch = 1.0;
    static double _rate = 0.8;
    static List<String> _ingredientsList;
    static List<String> _stepsList;

    static Map<String, int> wordsToNumbers = {
        "one": 1,
        "two": 2,
        "to": 2,
        "three": 3,
        "four": 4,
        "for": 4,
        "five": 5,
        "six": 6,
        "seven": 7,
        "eight": 8,
        "ate": 8,
        "nine": 9,
        "ten": 10,
        "eleven": 11,
        "twelve": 12,
        "thirteen": 13,
        "fourteen": 14,
        "fifteen": 15,
        "sixteen": 16,
        "seventeen": 17,
        "eighteen": 18,
        "nineteen": 19,
        "twenty": 20
    };



    TextToSpeech(BuildContext context) {
        _context = context;
        _recipePageProvider = Provider.of<RecipePageProvider>(_context, listen: false);
        _flutterTts =  FlutterTts();
    }



    static void setReadingVariables(String ingredients, String steps){
        _ingredientsList = ingredients.split("\n");
        _stepsList = steps.split("\n");
    }

    static void initializeTextToSpeech() async {

        await _flutterTts.setVolume(_volume);
        await _flutterTts.setSpeechRate(_rate);
        await _flutterTts.setPitch(_pitch);

        _flutterTts.setErrorHandler((msg) {
            _recipePageProvider.notifyError("audio error");

        });
    }

    static void readCommand(String command) async {
        print("in read command");
        List<String> commandList = command.toLowerCase().split(" ");
        print(commandList);

        if (commandList[0] == "step") {
            print("reading");
            try {
                await _flutterTts.speak(_stepsList[wordsToNumbers[commandList[1]] - 1]);
            }
            catch (e) {
                try {
                    await _flutterTts.speak(_stepsList[int.parse(commandList[1]) - 1]);
                }
                catch (e) {
                    print("command not clear");
                }
                print("command not clear");
            }
        }

        else if (commandList[0] == "ingredient") {
            try {
                await _flutterTts.speak(_ingredientsList[wordsToNumbers[commandList[1]] - 1]);
            }
            catch (e) {
                try {
                    await _flutterTts.speak(_ingredientsList[int.parse(commandList[1]) - 1]);
                }
                catch (e) {
                    print("command not clear");
                }
                print("command not clear");
            }
        }
    }


}