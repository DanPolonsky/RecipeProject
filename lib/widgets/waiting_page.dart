import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/providers/category_provider.dart';
import 'package:flutter_app/providers/recipe_page_provider.dart';

import '../global_variables.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';



class InitialWaitingPage extends StatefulWidget {
  @override
  _InitialWaitingPageState createState() => _InitialWaitingPageState();
}

class _InitialWaitingPageState extends State<InitialWaitingPage> {

  void getRecipeJson() async{
    var recipeListProvider = Provider.of<CategoryRecipeListProvider>(context, listen: false);
    await recipeListProvider.initializeNewCategory("popular");
    Navigator.pushReplacement(
      context, CupertinoPageRoute(
      builder: (context) => Home(),
      ),
    );
  }




  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // check whether the user is logged in or not and store the value in Constants.loggedIn
      SharedPreferences prefs = await SharedPreferences.getInstance();

      RunTimeVariables.prefs = prefs;

      if(prefs.getBool("LoggedIn") == null || prefs.getBool("LoggedIn") == false){
        RunTimeVariables.loggedIn = false;
      }
      else{
        RunTimeVariables.loggedIn = true;
      }

      var recipeProvider = Provider.of<RecipePageProvider>(context, listen: false);

      // initializes speech detection and keyWord detection for recipePage
      recipeProvider.initializeAllListeningFunctions();

      //downloading home page list of recipes
      getRecipeJson();
    });

  }

  @override
  Widget build(BuildContext context) {
    return
        Center(
          child: CircularProgressIndicator(),
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
    return Scaffold(
        body:Center(
          child: CircularProgressIndicator(),
        )
    );
  }
}

