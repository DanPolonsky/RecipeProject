import 'dart:io';

import 'package:flutter_app/classes/audio_classes/speech_recognition.dart';
import 'package:flutter_app/classes/audio_classes/hotkeyword_detection.dart';
import 'package:flutter_app/classes/audio_classes/text_to_speech.dart';

import 'package:flutter_app/pages/home_page/home_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/local_recipes.dart';
import '../global_variables.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'home_page/category_provider.dart';

/// Class is the main loading page, initializing various components in the app
class InitialWaitingPage extends StatefulWidget {
  @override
  _InitialWaitingPageState createState() => _InitialWaitingPageState();
}

class _InitialWaitingPageState extends State<InitialWaitingPage> {
  /// Function loads the initial recipe list, viewed in the home page
  void initializeHomePageData() async {
    var recipeListProvider =
        Provider.of<CategoryRecipeListProvider>(context, listen: false);

    recipeListProvider.initializeNewCategory("Popular");

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => Home(),
      ),
    );
  }

  ///Function
  void checkShowRecipeGuide(){
    if(RunTimeVariables.prefs.getBool("ShowRecipeGuide") == null){
      RunTimeVariables.prefs.setBool("ShowRecipeGuide", true);
    }


  }


  /// Function checks if the user is logged in or not
  void authenticationCheck() async {

    if (RunTimeVariables.prefs.getBool("LoggedIn") == null) {
      RunTimeVariables.prefs.setBool("LoggedIn", false);
    }
  }

  /// Function checks if there is a stored recipes file, if there is, the function loads the contents
  /// Creates one if there isnt
  void checkLocalRecipes() async {
    File savedRecipesFile = await LocalRecipes.getLocalFile();
    bool fileExists = await savedRecipesFile.exists();
    if (!fileExists) {
      LocalRecipes.createJsonFile();
    }
    LocalRecipes.getJson();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      // Getting access to SharedPreferences and storing the reference in RunTimeVariables
      SharedPreferences prefs = await SharedPreferences.getInstance();
      RunTimeVariables.prefs = prefs;

      // check whether the user is logged in or not and store the value in Constants.loggedIn
      await authenticationCheck();

      await checkLocalRecipes();

      await checkShowRecipeGuide();

      // Initializing all audio functions
      SpeechRecognition(context);
      TextToSpeech(context);
      HotKeyWordDetection(context);

      // Downloading home page list of recipes
      initializeHomePageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
      ],
    ));
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
