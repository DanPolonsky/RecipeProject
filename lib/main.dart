import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/pages/add_recipe_page/add_recipe_page_provider.dart';
import 'package:flutter_app/pages/authentication/login_page/login_page_provider.dart';
import 'package:flutter_app/pages/authentication/signup_page/signup_page_provider.dart';
import 'package:flutter_app/pages/home_page/category_provider.dart';
import 'package:flutter_app/pages/local_recipes_page/local_recipes_provider.dart';
import 'package:flutter_app/pages/recipe_page/recipe_page_provider.dart';
import 'package:flutter_app/pages/waiting_page.dart';


import 'package:provider/provider.dart';

import 'pages/search_page/search_provider.dart';

/// Main function called at start up
void main() async {
  return runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => CategoryRecipeListProvider()),
      ChangeNotifierProvider(create: (context) => SearchRecipeListProvider()),
      ChangeNotifierProvider(create: (context) => AddRecipePageProvider()),
      ChangeNotifierProvider(create: (context) => LoginPageProvider()),
      ChangeNotifierProvider(create: (context) => SignUpPageProvider()),
      ChangeNotifierProvider(create: (context) => RecipePageProvider()),
      ChangeNotifierProvider(create: (context) => LocalRecipesProvider()),

    ], child: MyApp()),
  );
}

/// The main visual component
class MyApp extends StatelessWidget {

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Text-To-Speech Demo', home: InitialWaitingPage());
  }
}


