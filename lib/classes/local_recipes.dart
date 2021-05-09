import 'dart:convert';
import 'package:flutter_app/classes/recipe_info.dart';
import 'package:flutter_app/classes/enums.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalRecipes {
  static File _jsonFile;
  static final String _fileName = "localRecipesJson.json";
  static Map<String, dynamic> localRecipesMap;

  static Future<File> getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    _jsonFile = File('$localPath/$_fileName');
    return _jsonFile;
  }

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

  static void createJsonFile() {
    _jsonFile.createSync();
    Map<String, dynamic> jsonToWrite = {"placeHolder": "placeHolder"};
    String jsonString = jsonEncode(jsonToWrite);
    _jsonFile.writeAsString(jsonString);
  }
}
