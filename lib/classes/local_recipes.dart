import 'dart:convert';
import 'package:flutter_app/classes/recipe_info.dart';
import 'package:flutter_app/classes/enums.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Class containing functions and variables related to saved recipes
class LocalRecipes {
  static File
      _jsonFile; // A file variable holding the json file in which recipes are stored
  static final String _fileName =
      "localRecipesJson.json"; // The name of the json file
  static Map<String, dynamic>
      localRecipesMap; // A map mapping recipe id to recipe information

  /// Function finds the json file stored and puts a reference to it in [_jsonFile]
  /// Returns the file reference
  static Future<File> getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    _jsonFile = File('$localPath/$_fileName');
    return _jsonFile;
  }

  /// Function checks if a specific recipe is saved by its RecipeInfo [info]
  /// Returns SavedRecipeEnum
  static SavedRecipeEnum savedRecipe(RecipeInfo info) {
    if (localRecipesMap != {}) {
      if (localRecipesMap[info.id.toString()] == null) {
        return SavedRecipeEnum.notSaved;
      } else {
        return SavedRecipeEnum.saved;
      }
    } else {
      return SavedRecipeEnum.error;
    }
  }

  /// Function saves new recipe with its RecipeInfo [info]
  /// Returns if the process is successful
  static bool saveNewRecipe(RecipeInfo info) {
    if (localRecipesMap != {}) {
      localRecipesMap[info.id.toString()] = info.toJson();
      String jsonString = jsonEncode(jsonEncode(localRecipesMap));
      _jsonFile.writeAsString(jsonString);
      return true;
    } else {
      // error
      return false;
    }
  }

  /// Function deletes a saved recipe by its RecipeInfo [info]
  /// Returns if the process is successful
  static bool deleteSavedRecipe(RecipeInfo info) {
    if (localRecipesMap != {}) {
      localRecipesMap.remove(info.id.toString());
      String jsonString = jsonEncode(jsonEncode(localRecipesMap));
      _jsonFile.writeAsString(jsonString);
      return true;
    } else {
      // error
      return false;
    }
  }

  /// Function transfers the saved file map into a [localRecipesMap]
  static void getJson() {
    try {
      String jsonString = _jsonFile.readAsStringSync();

      try {
        jsonString = jsonDecode(jsonString);
      } catch (e) {
        null;
      }
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      localRecipesMap = jsonMap;
    } catch (e) {
      print('Tried reading _file error: $e');
      localRecipesMap = {};
    }
  }

  /// Function creates the json File if it isnt created
  static void createJsonFile() {
    _jsonFile.createSync();
    Map<String, dynamic> jsonToWrite = {"placeHolder": "placeHolder"};
    String jsonString = jsonEncode(jsonToWrite);
    _jsonFile.writeAsString(jsonString);
  }
}
