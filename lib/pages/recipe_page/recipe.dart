import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/audio_classes/hotkeyword_detection.dart';
import 'package:flutter_app/classes/audio_classes/text_to_speech.dart';

import 'package:flutter_app/classes/recipe_info.dart';

import 'package:flutter_app/custom_icons_icons.dart';

import 'package:flutter_app/pages/recipe_page/recipe_page_provider.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../global_variables.dart';

// ignore: must_be_immutable
class Recipe extends StatefulWidget {
  RecipeInfo _recipeInfo; // Object holding the recipe info

  Color _difficultyColor;

  Recipe(RecipeInfo recipeInfo) {
    _recipeInfo = recipeInfo;

    if (_recipeInfo.difficulty == "easy") {
      _difficultyColor = Colors.green[600];
    } else if (_recipeInfo.difficulty == "medium") {
      _difficultyColor = Colors.yellowAccent;
    } else {
      _difficultyColor = Colors.red;
    }
  }

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  int _msBeforeGuideDialog = 400;
  RecipePageProvider recipePageProvider;

  /// Function initalizes all listening fucntionality of the page
  void initializer(BuildContext context) {
    // Getting access to the RecipePageProvider
    recipePageProvider =
        Provider.of<RecipePageProvider>(context, listen: false);

    recipePageProvider.checkRecipeSavedStatus(widget._recipeInfo);

    // Initializing all sound functionality if objects are available
    if (recipePageProvider.listeningFunctionsAvailability()) {
      print("starting to listen");
      TextToSpeech.setReadingVariables(
          widget._recipeInfo.ingredients, widget._recipeInfo.steps);

      HotKeyWordDetection.startKeyWordDetection();
    } else {
      print("not available");
    }
  }

  void showGuideDialog(BuildContext context) {
    bool showRecipeGuide = RunTimeVariables.prefs.getBool("ShowRecipeGuide");
    if (showRecipeGuide) {
      bool available = recipePageProvider.hotKeywordDetectionAvailable &&
          recipePageProvider.speechRecognitionAvailable;

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Command guide"),
              content: available
                  ? Text("Try saying:\n"
                      "Step... number\n"
                      "Ingredient... number\n"
                      "next... step/ingredient")
                  : Text(
                      "Some audio plugins are unavailable, try enabling microphone permission"),
              actions: [
                MaterialButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  child: Text("Don't show again"),
                  onPressed: () {
                    RunTimeVariables.prefs.setBool("ShowRecipeGuide", false);
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  void initState() {
    super.initState();
    initializer(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: _msBeforeGuideDialog));
      showGuideDialog(context);
    });
  }

  Widget build(BuildContext context) {
    return Consumer<RecipePageProvider>(
      builder: (context, provider, child) => Scaffold(
          body: Stack(children: <Widget>[
        ImageContainer(widget._recipeInfo),
        Container(
          margin: EdgeInsets.fromLTRB(
              12, MediaQuery.of(context).size.height * 0.35, 12, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.13),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 7), // changes position of shadow
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: Text(
                    "${widget._recipeInfo.recipeName}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.all(3),
                        child: Text("ratings: ${widget._recipeInfo.ratings}",
                            style: TextStyle(fontSize: 21)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              child: Text(
                            "${widget._recipeInfo.rating}",
                            style: TextStyle(fontSize: 21),
                          )),
                          Container(
                            margin: EdgeInsets.fromLTRB(3, 0, 3, 5),
                            child: RatingBar.builder(
                              initialRating: widget._recipeInfo.rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemSize: 28,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                provider.newRating = rating;
                                provider.rated = true;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                          margin: EdgeInsets.only(bottom: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: widget._difficultyColor,
                          ),
                          child: Text(
                            "${widget._recipeInfo.difficulty}",
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                        child: Column(
                          children: [
                            Icon(Icons.access_alarm_outlined),
                            Text("${widget._recipeInfo.totalTime}")
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Icon(CustomIcons.food_1, size: 27),
                            Text("${widget._recipeInfo.cookTime}")
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Icon(CustomIcons.food),
                            Text("${widget._recipeInfo.servings}")
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(3,13,3,5),
                      child: Text(
                        widget._recipeInfo.description,
                        style: TextStyle(fontSize: 24),
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(4, 10, 0, 4),
                    child: Text(
                      "Ingredients",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(12, 6, 6, 6),
                      child: Text(
                        widget._recipeInfo.ingredients,
                        style: TextStyle(height:0.9, fontSize: 20),
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(4, 10, 0, 4),
                    child: Text(
                      "Steps",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(12, 6, 6, 6),
                      child: Text(
                        widget._recipeInfo.steps,
                        style: TextStyle(height: 1.2, fontSize: 20),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(6, 12, 6, 0),
                      child: Text(
                        "Author: ${widget._recipeInfo.author}",
                        style: TextStyle(fontSize: 24),
                      )),
                  provider.listeningError
                      ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Audio Error"),
                          duration: Duration(seconds: 3)))
                      : Container(),
                  provider.storageError
                      ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Storage Error"),
                          duration: Duration(seconds: 3)))
                      : Container(),
                ],
              ),
            ),
          ),
        )
      ])),
    );
  }
}

// ignore: must_be_immutable
class ImageContainer extends StatelessWidget {
  RecipeInfo _recipeInfo;

  double _width;
  double _height;

  ImageContainer(RecipeInfo recipeInfo) {
    _recipeInfo = recipeInfo;
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Consumer<RecipePageProvider>(
      builder: (context, provider, child) => ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
            ).createShader(
                Rect.fromLTRB(0, _height * 0.21, rect.width, rect.height));
          },
          blendMode: BlendMode.dstIn,
          child: Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              margin: EdgeInsets.fromLTRB(9, 12, 9, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        provider.reset(_recipeInfo);
                        provider.updateRecipeInfo(context, _recipeInfo);
                        Navigator.of(context).pop();
                      }),
                  IconButton(
                    icon: Icon(
                        provider.savedRecipe ? Icons.star : Icons.star_border,
                        color: Colors.yellow),
                    onPressed: () {
                      if (!provider.savedRecipe) {
                        provider.callSaveNewRecipe(_recipeInfo);
                      } else {
                        provider.callDeleteSavedRecipe(_recipeInfo);
                      }
                    },
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(image: _recipeInfo.img, fit: BoxFit.cover),
            ),
          )),
    );
  }
}
