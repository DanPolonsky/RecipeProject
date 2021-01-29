
import 'dart:typed_data';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/recipe_card.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/asymmetric/api.dart';


/*
  A collection of network functions to interact with the server.
 */


const String IP = "10.100.102.2";
const int PORT = 60000;


// turning each recipeInfo dict into RecipeCard widget
List<Widget> recipeInfoDictListToWidgetList(var recipesInfoDictList){
  List<Widget> recipeCardList = [];

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
        recipeMapInfo["cookTime"],
        recipeMapInfo["ratings"],
        recipeMapInfo["totalTime"],
        recipeMapInfo["servings"],
        recipeMapInfo["description"],
        MemoryImage(byteslist)));
  });

  return recipeCardList;
}


// fucntion sends http request with given category receives data and build list of
// RecipeCards out of data
Future<List<Widget>> getRecipesCardsListByCategory(String category,
    int startIndex, int endIndex) async {
  // list of RecipeCard objects

  print("sending request");

  //sending request and getting the response
  http.Response response = await http.get(Uri.http("$IP:$PORT",
      "/category/$category/from:$startIndex-to:$endIndex"));

  print("got response");

  // turning the json string response into list of PictureInfo classes
  var recipesInfoDictList = jsonDecode(response.body)['response'] as List;



  List<Widget> recipeCardList = recipeInfoDictListToWidgetList(recipesInfoDictList);


  print("added recipes");
  return recipeCardList;
}


Future<List<Widget>> getRecipesCardsListBySearch(String searchValue,
    int startIndex, int endIndex) async {
  // list of RecipeCard objects


  print("sending request");

  //sending request and getting the response
  http.Response response = await http.get(Uri.http("$IP:$PORT",
      "/search/$searchValue/from:$startIndex-to:$endIndex"));

  print("got response");

  // turning the json string response into list of PictureInfo classes
  var recipesInfoDictList = jsonDecode(response.body)['response'] as List;

  List<Widget> recipeCardList = recipeInfoDictListToWidgetList(recipesInfoDictList);


  print("added recipes");
  return recipeCardList;
}



void addView(int recipeId){
  http.get(Uri.http("$IP:$PORT", "/addView/id:$recipeId"));
}

void rate(int recipeId, double rating){
  http.get(Uri.http("$IP:$PORT", "/rating/id:$recipeId,rating:$rating"));
}


void sendNewRecipePost(String recipeName, String ingredients, String steps, Uint8List image, String difficulty, String cookTime, String imageType) {
  http.post(
    Uri.http("$IP:$PORT", "recipePost"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },

    //Todo: add id per user, to verify user.
    body: jsonEncode(<String, dynamic>{
      "recipeName": recipeName,
      "ingredients": ingredients,
      "steps": steps,
      "data": image,
      "difficulty": difficulty,
      "cookTime": cookTime,
      "imageType": imageType
    }),
  );
}


Future<String> sendLoginPostRequest(String userName, String password) async{

  http.Response publicKeyResponse = await http.get(Uri.http("$IP:$PORT","/login"));

  String modulus = publicKeyResponse.body.split(",")[0];
  String exponent = publicKeyResponse.body.split(",")[1];


  RSAPublicKey publicKey = RSAPublicKey(BigInt.parse(modulus), BigInt.parse(exponent));

  Encrypter encrypter = Encrypter(RSA(publicKey: publicKey));
  final encrypted = encrypter.encrypt(password);



  http.Response loginResponse = await http.post(
      Uri.http("$IP:$PORT","/verify"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

      //Todo: add id per user, to verify user.
      body: jsonEncode(<String, dynamic>{
        "userName": userName,
        "password":encrypted.base64
      }));

      print(loginResponse.statusCode);
      print(loginResponse.body);

      return loginResponse.body;
}

