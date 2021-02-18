import 'dart:io';


import 'package:flutter_app/classes/audio_classes/SpeechRecognition.dart';
import 'package:flutter_app/classes/audio_classes/hotkeyword_detection.dart';
import 'package:flutter_app/classes/audio_classes/text_to_speech.dart';
import 'package:flutter_app/classes/local_recipes.dart';

import 'package:flutter_app/providers/add_recipe_page_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/providers/category_provider.dart';
import 'package:flutter_app/providers/recipe_page_provider.dart';

import '../classes/local_recipes.dart';
import '../global_variables.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';


class InitialWaitingPage extends StatefulWidget {
    @override
    _InitialWaitingPageState createState() => _InitialWaitingPageState();
}

class _InitialWaitingPageState extends State<InitialWaitingPage> {

    void initializeHomePageData() async {
        var recipeListProvider = Provider.of<CategoryRecipeListProvider>(context, listen: false);
        await recipeListProvider.initializeNewCategory("popular");

        Navigator.pushReplacement(
            context, CupertinoPageRoute(
            builder: (context) => Home(),
        ),
        );
    }


    void authenticationCheck() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      RunTimeVariables.prefs = prefs;

      if(prefs.getBool("LoggedIn") == null){
        prefs.setBool("LoggedIn", false);
        RunTimeVariables.loggedIn = false;
      }

      else if (prefs.getBool("LoggedIn") == false) {
        RunTimeVariables.loggedIn = false;
      }

      else {
        RunTimeVariables.loggedIn = true;
      }
    }

    @override
    void initState() {
        super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_) async {
            // check whether the user is logged in or not and store the value in Constants.loggedIn

            await authenticationCheck();

            //Todo: change this shit
            var addRecipePageProvider = Provider.of<AddRecipePageProvider>(context, listen: false);
            addRecipePageProvider.initializeLists();


            File savedRecipesFile = await LocalRecipes.getLocalFile();
            bool fileExists = await savedRecipesFile.exists();
            if(!fileExists){
                LocalRecipes.createJsonFile();
            }
            LocalRecipes.getJson();


            // Initializing all audio functions
            SpeechRecognition(context);
            TextToSpeech(context);
            HotKeyWordDetection(context);


            //downloading home page list of recipes
            initializeHomePageData();
        });
    }

    @override
    Widget build(BuildContext context) {
        return
            MultiProvider(
                providers: [
                    ChangeNotifierProvider(create: (context) => AddRecipePageProvider()),
                    ChangeNotifierProvider(create: (context) => RecipePageProvider()),
                ],
              child: Scaffold(
                  body: Center(
                      child: CircularProgressIndicator(),
                  )
              ),
            );
    }
}


class RecipesWaitingPage extends StatefulWidget {
    @override
    _RecipesWaitingPageState createState() => _RecipesWaitingPageState();
}

class _RecipesWaitingPageState extends State<RecipesWaitingPage> {
    @override
    Widget build(BuildContext context) {
        return Center(
            child: CircularProgressIndicator(),
        );
    }
}

