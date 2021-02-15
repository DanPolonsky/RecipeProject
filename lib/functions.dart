
import 'dart:typed_data';
import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/recipe_card.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/asymmetric/api.dart';
import 'classes/recipeInfo.dart';
import 'global_variables.dart';


/// A collection of network functions to interact with the server.


// Ip and port of server
const String IP = "192.168.11.105";
const int PORT = 5356;


/// Function takes json dictionary [recipesInfoDictList] and turns it to RecipeCard widget list.
List<Widget> recipeInfoDictListToWidgetList(var recipesInfoDictList){
  List<Widget> recipeCardList = [];

  recipesInfoDictList.forEach((recipeMapInfo) {
    RecipeInfo recipeInfo = RecipeInfo.fromJson(recipeMapInfo);
    recipeCardList.add(RecipeCard(recipeInfo));
  });

  return recipeCardList;
}


/// Function sends http request with given [category] [startIndex] and [endIndex] and returns list of
/// widgets out of json response using the recipeInfoDictListToWidgetList function.
Future<List<Widget>> getRecipesCardsListByCategory(String category,
    int startIndex, int endIndex) async {
  print("sending request");

  // sending request and getting and saving response in response
  http.Response response = await http.get(Uri.http("$IP:$PORT",
      "/category/$category/from:$startIndex-to:$endIndex"));

  print("got response");

  // turning the json string response into list of PictureInfo classes
  var recipesInfoDictList = jsonDecode(response.body)['response'] as List;

  List<Widget> recipeCardList = recipeInfoDictListToWidgetList(recipesInfoDictList);


  print("added recipes");
  return recipeCardList;
}


/// Function sends http request with given [searchValue] [startIndex] and [endIndex] and returns list of
/// widgets out of json response using the recipeInfoDictListToWidgetList function.
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


///Function send http request to server to add view to a recipe by [id]
void addView(int recipeId){
  http.get(Uri.http("$IP:$PORT", "/addView/id:$recipeId"));
}

void rate(int recipeId, double rating){
  http.get(Uri.http("$IP:$PORT", "/rating/id:$recipeId,rating:$rating"));
}


void sendNewRecipePost(String recipeName, String ingredients, String steps,
             Uint8List image, String difficulty, String cookTime, String totalTime,
              String servings, String description, String categories, String imageType) async{


  String codeId = RunTimeVariables.prefs.getString("codeId");

  Encrypter encrypter = await getEncrypter();
  String encryptedCodeId = encrypter.encrypt(codeId).base64;

  http.post(
    Uri.http("$IP:$PORT", "recipePost"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },

    //Todo: add id per user, to verify user.
    body: jsonEncode(<String, dynamic>{
      "codeId": encryptedCodeId,
      "recipeName": recipeName,
      "ingredients": ingredients,
      "steps": steps,
      "data": image,
      "difficulty": difficulty,
      "cookTime": cookTime,
      "totalTime": totalTime,
      "servings": servings,
      "description": description,
      "categories":categories,

      "imageType": imageType
    }),
  );
}






Future<String> sendLoginPostRequest(String userName, String password) async{

  Encrypter encrypter = await getEncrypter();
  String encrypted = encrypter.encrypt(password).base64;

  http.Response loginResponse = await http.post(
      Uri.http("$IP:$PORT","/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

      //Todo: add id per user, to verify user.
      body: jsonEncode(<String, dynamic>{
        "userName": userName,
        "password":encrypted
      })
  );

      print(loginResponse.statusCode);
      print(loginResponse.body);

      return loginResponse.body;
}



Future<String> sendSignUpPostRequest(String userName, String password) async{
  Encrypter encrypter = await getEncrypter();
  String encrypted = encrypter.encrypt(password).base64;

  http.Response signUpResponse = await http.post(
          Uri.http("$IP:$PORT","/signUp"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },

          //Todo: add id per user, to verify user.
          body: jsonEncode(<String, dynamic>{
            "userName": userName,
            "password":encrypted
          })
  );

  print(signUpResponse.statusCode);
  print(signUpResponse.body);

  return signUpResponse.body;
}






/// Function builds a rsa encrypter with a public key received from server
Future<Encrypter> getEncrypter() async {
  http.Response publicKeyResponse = await http.get(Uri.http("$IP:$PORT","/encrypt"));

  String modulus = publicKeyResponse.body.split(",")[0];
  String exponent = publicKeyResponse.body.split(",")[1];

  RSAPublicKey publicKey = RSAPublicKey(BigInt.parse(modulus), BigInt.parse(exponent));

  Encrypter encrypter = Encrypter(RSA(publicKey: publicKey));

  return encrypter;
}