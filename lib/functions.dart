import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/general_widgets/recipe_card.dart';

import 'package:http/http.dart' as http;
import 'package:pointycastle/asymmetric/api.dart';

import 'classes/local_recipes.dart';
import 'classes/recipe_info.dart';
import 'global_variables.dart';

/// A collection of network functions to interact with the server and general functions.

// Ip and port of server
const String IP = "192.168.11.135";
const int PORT = 5356;

const int REQUEST_COOL_DOWN_TIME =
    3; // Amount of time to wait before sending repeated request if the previous one didnt receive answer

/// Function takes json dictionary list [recipesInfoDictList] and turns it to RecipeCard widget list.
List<Widget> recipeInfoDictListToWidgetList(
    List<Map<String, dynamic>> recipesInfoDictList) {
  List<Widget> recipeCardList = []; // A list holding RecipeCard widgets

  recipesInfoDictList.forEach((recipeMapInfo) {
    RecipeInfo recipeInfo = RecipeInfo.fromJson(recipeMapInfo);
    recipeInfo.saved = LocalRecipes.savedRecipe(recipeInfo);
    recipeCardList.add(RecipeCard(recipeInfo));
  });

  return recipeCardList;
}

/// Function sends http request with given [category] [startIndex] and [endIndex] and returns list of
/// widgets out of json response using the recipeInfoDictListToWidgetList function.
Future<List<Widget>> downloadRecipesByCategory(
    String category, int startIndex, int endIndex) async {
  try {
    // sending request and getting and saving response in response
    print("sending request");
    http.Response response = await http.get(Uri.http(
        "$IP:$PORT", "/category/$category/from:$startIndex-to:$endIndex"));
    print("got response");

    // turning the json string response into list of recipe info maps
    var recipesInfoDictList = jsonDecode(response.body)['response'] as List;

    List<Widget> recipeCardList =
        recipeInfoDictListToWidgetList(recipesInfoDictList);

    print("added recipes");
    return recipeCardList;
  } catch (error) {
    await Future.delayed(Duration(seconds: REQUEST_COOL_DOWN_TIME));
    return downloadRecipesByCategory(category, startIndex, endIndex);
  }
}

/// Function sends http request with given [searchValue] [startIndex] and [endIndex] and returns list of
/// widgets out of json response using the recipeInfoDictListToWidgetList function.
Future<List<Widget>> donwloadRecipesBySearch(
    String searchValue, int startIndex, int endIndex) async {
  try {
    // list of RecipeCard objects

    print("sending request");

    //sending request and getting the response
    http.Response response = await http.get(Uri.http(
        "$IP:$PORT", "/search/$searchValue/from:$startIndex-to:$endIndex"));

    print("got response");

    // turning the json string response into list of recipe info maps
    var recipesInfoDictList = jsonDecode(response.body)['response'] as List;

    List<Widget> recipeCardList =
        recipeInfoDictListToWidgetList(recipesInfoDictList);

    print("added recipes");
    return recipeCardList;
  } catch (error) {
    await Future.delayed(Duration(seconds: REQUEST_COOL_DOWN_TIME));
    return donwloadRecipesBySearch(searchValue, startIndex, endIndex);
  }
}

/// Function sends http request to server, adding view to a recipe by [recipeId].
void addView(int recipeId) {
  try {
    http.get(Uri.http("$IP:$PORT", "/addView/id:$recipeId"));
  } catch (error) {}
}

/// Function sends http request to server to add a rating [rating] to recipe [recipeId].
void rate(int recipeId, double rating) {
  try {
    http.get(Uri.http("$IP:$PORT", "/rating/id:$recipeId,rating:$rating"));
  } catch (error) {}
}

/// Function sends a post request for uploading a new recipe.
void sendNewRecipePost(
    String recipeName,
    String recipeDescription,
    List<String> ingredients,
    List<String> steps,
    Uint8List image,
    String difficulty,
    String cookTime,
    String totalTime,
    String servings,
    String categories,
    String imageType) async {
  try {
    // codeId is a code created when user is created to verify user in different requests, such as uploading recipe
    // The creation of codeId is explained in Authentication/login_functions.dart
    String codeId = RunTimeVariables.prefs.getString("codeId");

    // Getting rsa encryption key
    Encrypter encrypter = await getEncrypter();
    String encryptedCodeId = encrypter.encrypt(codeId).base64;

    print(ingredients);
    http.post(
      Uri.http("$IP:$PORT", "recipePost"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

      //Todo: add id per user, to verify user.
      body: jsonEncode(<String, dynamic>{
        "codeId": encryptedCodeId,
        "description": recipeDescription,
        "recipeName": recipeName,
        "ingredients": ingredients,
        "steps": steps,
        "data": image,
        "difficulty": difficulty,
        "cookTime": cookTime,
        "totalTime": totalTime,
        "servings": servings,
        "categories": categories,
        "imageType": imageType
      }),
    );
  } catch (error) {
    await Future.delayed(Duration(seconds: REQUEST_COOL_DOWN_TIME));
    return sendNewRecipePost(
        recipeName,
        recipeDescription,
        ingredients,
        steps,
        image,
        difficulty,
        cookTime,
        totalTime,
        servings,
        categories,
        imageType);
  }
}

/// Function sends login post request, sending [userName] and encrypted [password] using the encrypt method.
/// Returns if request is successful
Future<String> sendLoginPostRequest(String userName, String password) async {
  try {
    // Getting rsa encryption key
    Encrypter encrypter = await getEncrypter();
    String encrypted = encrypter.encrypt(password).base64;

    http.Response loginResponse = await http.post(
        Uri.http("$IP:$PORT", "/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

        //Todo: add id per user, to verify user.
        body: jsonEncode(
            <String, dynamic>{"userName": userName, "password": encrypted}));

    return loginResponse.body;
  } catch (error) {
    await Future.delayed(Duration(seconds: REQUEST_COOL_DOWN_TIME));
    return sendLoginPostRequest(userName, password);
  }
}

/// Function sends signup post request, sending [userName] and encrypted [password] using the encrypt method.
/// Returns if request is successful.
Future<String> sendSignUpPostRequest(String userName, String password) async {
  try {
    // Getting rsa encryption key
    Encrypter encrypter = await getEncrypter();
    String encrypted = encrypter.encrypt(password).base64;

    http.Response signUpResponse = await http.post(
        Uri.http("$IP:$PORT", "/signUp"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

        //Todo: add id per user, to verify user.
        body: jsonEncode(
            <String, dynamic>{"userName": userName, "password": encrypted}));

    return signUpResponse.body;
  } catch (error) {
    await Future.delayed(Duration(seconds: REQUEST_COOL_DOWN_TIME));
    return sendSignUpPostRequest(userName, password);
  }
}

/// Function builds a rsa encrypter with a public key received from server answer
Future<Encrypter> getEncrypter() async {
  try {
    http.Response publicKeyResponse =
        await http.get(Uri.http("$IP:$PORT", "/encrypt"));

    // Rsa key variables to create RSAPublicKey
    String modulus = publicKeyResponse.body.split(",")[0];
    String exponent = publicKeyResponse.body.split(",")[1];

    RSAPublicKey publicKey =
        RSAPublicKey(BigInt.parse(modulus), BigInt.parse(exponent));

    Encrypter encrypter = Encrypter(RSA(publicKey: publicKey));

    return encrypter;
  } catch (error) {
    await Future.delayed(Duration(seconds: REQUEST_COOL_DOWN_TIME));
    return getEncrypter();
  }
}
