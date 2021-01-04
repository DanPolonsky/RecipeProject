import 'dart:collection';
import 'dart:typed_data';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/RecipeCard.dart';
import 'package:http/http.dart' as http;

// fucntion sends http request with given category receives data and build list of
// RecipeCards out of data
Future<List<Widget>> getRecipesCardsListByCategory(
    String category, int startIndex, int endIndex) async {
  // list of RecipeCard objects
  List<Widget> recipeCardList = [];

  print("sending request");

  //sending request and getting the response
  http.Response response = await http.get(Uri.http("192.168.11.105:5356",
      "/category/$category/from:$startIndex-to:$endIndex"));

  print("got response");

  // turning the json string response into list of PictureInfo classes
  var recipesInfoDictList = jsonDecode(response.body)['response'] as List;

  // turning each recipeInfo dict into RecipeCard widget
  recipesInfoDictList.forEach((recipesDictInfo) {
    Uint8List byteslist = hex.decode(recipesDictInfo["data"]);
    recipeCardList.add(RecipeCard(
        recipesDictInfo["id"],
        recipesDictInfo["recipeName"],
        recipesDictInfo["views"],
        recipesDictInfo["rating"],
        recipesDictInfo["difficulty"],
        recipesDictInfo["author"],
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
  http.Response response = await http.get(Uri.http("192.168.11.105:5356",
      "/search/$searchValue/from:$startIndex-to:$endIndex"));

  print("got response");

  // turning the json string response into list of PictureInfo classes
  var recipesInfoDictList = jsonDecode(response.body)['response'] as List;

  // turning each recipeInfo dict into RecipeCard widget
  recipesInfoDictList.forEach((recipesDictInfo) {
    Uint8List byteslist = hex.decode(recipesDictInfo["data"]);
    recipeCardList.add(RecipeCard(
        recipesDictInfo["id"],
        recipesDictInfo["recipeName"],
        recipesDictInfo["views"],
        recipesDictInfo["rating"],
        recipesDictInfo["difficulty"],
        recipesDictInfo["author"],
        MemoryImage(byteslist)));
  });

  print("added recipes");
  return recipeCardList;
}


Future<HashMap<String, dynamic>> getRecipeById(int id) async {
  print("sending request");

  //sending request and getting the response
  http.Response response =
  await http.get(Uri.http("192.168.11.105:5356", "/get_recipe/id:$id"));

  print("got recipe by id response");
  print(response.contentLength);

  var recipeJson = jsonDecode(response.body)['response'];
  print(recipeJson.runtimeType);


  return recipeJson;
}
