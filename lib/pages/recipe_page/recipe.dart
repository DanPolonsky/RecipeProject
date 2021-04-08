import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/audio_classes/hotkeyword_detection.dart';
import 'package:flutter_app/classes/audio_classes/text_to_speech.dart';

import 'package:flutter_app/classes/recipe_info.dart';

import 'package:flutter_app/custom_icons_icons.dart';

import 'package:flutter_app/pages/home_page/category_provider.dart';

import 'package:flutter_app/pages/recipe_page/recipe_page_provider.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Recipe extends StatelessWidget {
  RecipeInfo _recipeInfo;

  Color _difficultyColor;

  void initializer(BuildContext context) {
    var recipePageProvider =
        Provider.of<RecipePageProvider>(context, listen: false);

    if (recipePageProvider.listeningFunctionsAvailability()) {
      print("starting to listen");
      TextToSpeech.setReadingVariables(
          _recipeInfo.ingredients, _recipeInfo.steps);
      recipePageProvider.checkRecipeSavedStatus(_recipeInfo);
      HotKeyWordDetection.startKeyWordDetection();
    } else {
      print("not available");
    }
  }

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

  Widget build(BuildContext context) {
    initializer(context);

    return Consumer<RecipePageProvider>(
      builder: (context, provider, child) => Scaffold(
          body: Stack(children: <Widget>[
        ImageContainer(_recipeInfo),
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
                    "${_recipeInfo.recipeName}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.all(3),
                        child: Text("ratings: ${_recipeInfo.ratings}",
                            style: TextStyle(fontSize: 21)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              child: Text(
                            "${_recipeInfo.rating}",
                            style: TextStyle(fontSize: 21),
                          )),
                          Container(
                            margin: EdgeInsets.fromLTRB(3, 0, 3, 5),
                            child: RatingBar.builder(
                              initialRating: _recipeInfo.rating,
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
                            color: _difficultyColor,
                          ),
                          child: Text(
                            "${_recipeInfo.difficulty}",
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                        child: Column(
                          children: [
                            Icon(Icons.access_alarm_outlined),
                            Text("${_recipeInfo.totalTime}")
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Icon(CustomIcons.food_1, size: 27),
                            Text("${_recipeInfo.cookTime}")
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Icon(CustomIcons.food),
                            Text("${_recipeInfo.servings}")
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.all(3),
                      child: Text(
                        _recipeInfo.description,
                        style: TextStyle(fontSize: 24),
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(4, 10, 0, 4),
                    child: Text(
                      "Ingredients",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(12,6,6,6),
                      child: Text(
                        _recipeInfo.ingredients,
                        style: TextStyle(fontSize: 20),
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
                      margin: EdgeInsets.fromLTRB(12,6,6,6),
                      child: Text(
                        _recipeInfo.steps,
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(6, 12, 6, 0),
                      child: Text(
                        "Author: ${_recipeInfo.author}",
                        style: TextStyle(fontSize: 24),
                      )),

                  provider.listeningError
                      ? Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Audio Error"),
                          duration: Duration(seconds: 3)))
                      : Container(),

//                                provider.listeningFunctionsAvailability() ? Scaffold.of(context)
//                                    .showSnackBar(
//                                    SnackBar(content: Text("Start Commanding!"), duration: Duration(seconds: 3))
//                                ) : Container()
                  provider.storageError
                      ? Scaffold.of(context).showSnackBar(SnackBar(
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
            ).createShader(Rect.fromLTRB(0, _height*0.18, rect.width, rect.height));
          },
          blendMode: BlendMode.dstIn,
          child: Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              margin: EdgeInsets.fromLTRB(5, 7, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        provider.reset(_recipeInfo);

                        final homeProvider =
                            Provider.of<CategoryRecipeListProvider>(context,
                                listen: false);

                        homeProvider.updateRecipeInfo(_recipeInfo);

                        Navigator.of(context).pop();
                      }),
                  IconButton(
                    icon: Icon(
                        provider.savedRecipe ? Icons.star : Icons.star_border,
                        color: Colors.yellow),
                    onPressed: () {
                      if (!provider.savedRecipe) {
                        provider.callSaveNewRecipe(_recipeInfo);
                      }
                    },
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(image: _recipeInfo.img, fit: BoxFit.cover),
              gradient: new LinearGradient(
                end: const Alignment(0.0, -1),
                begin: const Alignment(0.0, 0.6),
                colors: <Color>[
                  const Color(0x8A000000),
                  Colors.black12.withOpacity(0.0)
                ],
              ),
            ),
          )),
    );
  }
}
