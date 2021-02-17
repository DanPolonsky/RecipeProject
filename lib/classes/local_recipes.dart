import 'dart:convert';
import 'package:flutter_app/classes/recipeInfo.dart';
import 'package:flutter_app/classes/enums.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalRecipes {
    static File _jsonFile;
    static final String _fileName = "localRecipesJson.json";

    static Future<File> getLocalFile() async {
        final directory = await getApplicationDocumentsDirectory();
        String localPath = directory.path;
        _jsonFile = File('$localPath/$_fileName');
        return _jsonFile;
    }



    static SavedRecipeEnum savedRecipe(int recipeId) {
        Map <String, dynamic> localRecipesJMap =  getJson();

        if (localRecipesJMap != {}) {
            List<dynamic> localRecipesList = localRecipesJMap["localRecipes"];
            for(Map<String, dynamic> recipeMap in localRecipesList){
                if(recipeId == recipeMap["id"]){
                    return SavedRecipeEnum.saved;
                }
            }
            return SavedRecipeEnum.notSaved;

        }
        else {
            return SavedRecipeEnum.error;
        }
    }

    static bool saveNewRecipe(RecipeInfo info)  {
        Map <String, dynamic> localRecipesJMap = getJson();

        if (localRecipesJMap != {}) {
            localRecipesJMap["localRecipes"].add(info.toJson());
            String jsonString = jsonEncode(jsonEncode(localRecipesJMap));
            _jsonFile.writeAsString(jsonString);
            print(localRecipesJMap);

            return true;
        }
        else {
            // error
            return false;
        }
    }

    static Map<String, dynamic> getJson() {
        try {
            // Read _jsonString<String> from the _file.
            String jsonString =  _jsonFile.readAsStringSync();
            print(jsonString);
            // Update initialized _json by converting _jsonString<String>->_json<Map>
            var jsonMap = jsonDecode(jsonString);
            print(jsonMap);
            return jsonMap;
        }
        catch (e) {
            print('Tried reading _file error: $e');
            return {};
        }
    }


    static void createJsonFile() {
        _jsonFile.createSync();
        Map<String, dynamic> jsonToWrite = {"localRecipes": []};
        String jsonString = jsonEncode(jsonToWrite);
        _jsonFile.writeAsString(jsonString);
    }


}