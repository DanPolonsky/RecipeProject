import 'package:flutter/cupertino.dart';
import 'package:flutter_app/pages/recipe_page/recipe_page_provider.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

/// Class containing text to speech capabilities
class TextToSpeech {
  static BuildContext
      _context; // The context variable of the app, used to access the RecipePageProvider
  static RecipePageProvider
      _recipePageProvider; // Object representing the RecipePageProvider
  static FlutterTts _flutterTts; // Main object for converting text to speech

  // Speech variables
  static double _volume = 0.7;
  static double _pitch = 1.0;
  static double _rate = 0.8;

  static List<String>
      _ingredientsList; // List containing all ingredients in a specific recipe
  static List<String>
      _stepsList; // List containing all steps in a specific recipe

  static int _nextIngredient =
      0; // Counter to keep track of next ingredient to read
  static int _nextStep = 0; // Counter to keep track of next step to read

  // A map mapping analyzed string-numbers to integers
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
    _recipePageProvider =
        Provider.of<RecipePageProvider>(_context, listen: false);
    _flutterTts = FlutterTts();
  }

  /// Function sets the reading lists from the specific recipe - [ingredients] and [steps]
  static void setReadingVariables(String ingredients, String steps) {
    _ingredientsList = ingredients.split("\n");
    _stepsList = steps.split("\n");
    _nextStep = 0;
    _nextIngredient = 0;
  }

  /// Function initializes the main object responsible for text to speech
  static void initializeTextToSpeech() async {
    await _flutterTts.setVolume(_volume);
    await _flutterTts.setSpeechRate(_rate);
    await _flutterTts.setPitch(_pitch);

    _flutterTts.setErrorHandler((msg) {
      _recipePageProvider.notifyError("audio error");
    });
  }

  /// Function reads(outloud) the info needed from the ingredient and step lists
  /// The function breaks down the [command] to understand which part to read
  static void readCommand(String command) async {
    print("in read command");
    List<String> commandList = command.toLowerCase().split(" ");
    print(commandList);

    if (commandList[0] == "step") {
      print("reading");
      try {
        await _flutterTts.speak(_stepsList[wordsToNumbers[commandList[1]] - 1]);
      } catch (e) {
        try {
          await _flutterTts.speak(_stepsList[int.parse(commandList[1]) - 1]);
        } catch (e) {
          print("command not clear");
        }
        print("command not clear");
      }
    } else if (commandList[0] == "ingredient") {
      try {
        await _flutterTts
            .speak(_ingredientsList[wordsToNumbers[commandList[1]] - 1]);
      } catch (e) {
        try {
          await _flutterTts
              .speak(_ingredientsList[int.parse(commandList[1]) - 1]);
        } catch (e) {
          print("command not clear");
        }
        print("command not clear");
      }
    } else if (commandList[0] == "next") {
      if (commandList[1] == "ingredient") {
        await _flutterTts.speak(_ingredientsList[_nextIngredient]);
        _nextIngredient += 1;
        _nextIngredient = _nextIngredient % (_ingredientsList.length - 1);
      } else if (commandList[1] == "step") {
        await _flutterTts.speak(_stepsList[_nextStep]);
        _nextStep += 1;
        _nextStep = _nextStep % (_stepsList.length - 1);
      }
    }
  }
}
