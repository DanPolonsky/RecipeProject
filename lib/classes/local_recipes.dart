import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/recipeInfo.dart';
import 'package:flutter_app/global_variables.dart';


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


    static Future<bool> saveNewRecipe(RecipeInfo info) async {


        Map <String, dynamic> localRecipes = await getJson();

        if (localRecipes != {}) {
            localRecipes["localRecipes"].add(info.toJson());
            String jsonString = jsonEncode(jsonEncode(localRecipes));
            _jsonFile.writeAsString(jsonString);
            print(localRecipes);

            // adding recipe to saved recipes list
            //jsonDecode(RunTimeVariables.prefs.getString("SavedRecipes"))["savedRecipes"].add(info.id);

            // no error
            return false;
        }

        else {

            // error accrued
            return true;
        }
    }

    static Future<Map<String, dynamic>> getJson() async {
        try {
            // Read _jsonString<String> from the _file.
            String jsonString = await _jsonFile.readAsString();
            print(jsonString);
            // Update initialized _json by converting _jsonString<String>->_json<Map>
            Map<String, dynamic> jsonMap = jsonDecode(jsonString);

            return jsonMap;
        } catch (e) {
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