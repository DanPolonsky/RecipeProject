import 'dart:io';

import 'package:flutter_app/classes/audio_classes/SpeechRecognition.dart';
import 'package:flutter_app/classes/audio_classes/hotkeyword_detection.dart';
import 'package:flutter_app/classes/audio_classes/text_to_speech.dart';

import 'package:flutter_app/pages/home_page/home_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/local_recipes.dart';
import '../global_variables.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_recipe_page/add_recipe_page_provider.dart';
import 'home_page/category_provider.dart';

class InitialWaitingPage extends StatefulWidget {
  @override
  _InitialWaitingPageState createState() => _InitialWaitingPageState();
}

class _InitialWaitingPageState extends State<InitialWaitingPage> {
  bool _networkError = false;

  void initializeHomePageData() async {
    var recipeListProvider =
        Provider.of<CategoryRecipeListProvider>(context, listen: false);

    recipeListProvider.initializeNewCategory("popular");

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => Home(),
      ),
    );
  }

  void authenticationCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    RunTimeVariables.prefs = prefs;

    if (prefs.getBool("LoggedIn") == null) {
      prefs.setBool("LoggedIn", false);
      RunTimeVariables.loggedIn = false;
    } else if (prefs.getBool("LoggedIn") == false) {
      RunTimeVariables.loggedIn = false;
    } else {
      RunTimeVariables.loggedIn = true;
    }
  }

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
      // check whether the user is logged in or not and store the value in Constants.loggedIn

      await authenticationCheck();

      //Todo: change this shit
      var addRecipePageProvider =
          Provider.of<AddRecipePageProvider>(context, listen: false);
      addRecipePageProvider.initializeLists();

      await checkLocalRecipes();

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
        _networkError ? Text("network error try again later...") : Container()
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
    print("building wait");
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
