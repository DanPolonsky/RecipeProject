
import 'dart:typed_data';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/recipe_card.dart';
import 'package:http/http.dart' as http;

// fucntion sends http request with given category receives data and build list of
// RecipeCards out of data
String ip = "10.100.102.6";
int port = 60000;

Future<List<Widget>> getRecipesCardsListByCategory(String category,
    int startIndex, int endIndex) async {
  // list of RecipeCard objects
  List<Widget> recipeCardList = [];

  print("sending request");

  //sending request and getting the response
  http.Response response = await http.get(Uri.http("$ip:$port",
      "/category/$category/from:$startIndex-to:$endIndex"));

  print("got response");

  // turning the json string response into list of PictureInfo classes
  var recipesInfoDictList = jsonDecode(response.body)['response'] as List;

  // turning each recipeInfo dict into RecipeCard widget
  recipesInfoDictList.forEach((recipeMapInfo) {
    Uint8List byteslist = hex.decode(recipeMapInfo["data"]);
    recipeCardList.add(RecipeCard(
        recipeMapInfo["id"],
        recipeMapInfo["recipeName"],
        recipeMapInfo["views"],
        recipeMapInfo["rating"],
        recipeMapInfo["difficulty"],
        recipeMapInfo["author"],
        recipeMapInfo["ingredients"],
        recipeMapInfo["steps"],
        MemoryImage(byteslist)));
  });

  print("added recipes");
  return recipeCardList;
}


Future<List<Widget>> getRecipesCardsListBySearch(String searchValue,
    int startIndex, int endIndex) async {
  // list of RecipeCard objects
  List<Widget> recipeCardList = [];

  print("sending request");

  //sending request and getting the response
  http.Response response = await http.get(Uri.http("$ip:$port",
      "/search/$searchValue/from:$startIndex-to:$endIndex"));

  print("got response");

  // turning the json string response into list of PictureInfo classes
  var recipesInfoDictList = jsonDecode(response.body)['response'] as List;

  // turning each recipeInfo dict into RecipeCard widget
  recipesInfoDictList.forEach((recipeMapInfo) {
    Uint8List byteslist = hex.decode(recipeMapInfo["data"]);
    recipeCardList.add(RecipeCard(
        recipeMapInfo["id"],
        recipeMapInfo["recipeName"],
        recipeMapInfo["views"],
        recipeMapInfo["rating"],
        recipeMapInfo["difficulty"],
        recipeMapInfo["author"],
        recipeMapInfo["ingredients"],
        recipeMapInfo["steps"],
        MemoryImage(byteslist)));
  });

  print("added recipes");
  return recipeCardList;
}



void addView(int recipeId){
  http.get(Uri.http("$ip:$port", "/addView/id:$recipeId"));
}