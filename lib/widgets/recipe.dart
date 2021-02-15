import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/classes/recipeInfo.dart';

import 'package:flutter_app/custom_icons_icons.dart';
import 'package:flutter_app/functions.dart';
import 'package:flutter_app/global_variables.dart';
import 'package:flutter_app/providers/recipe_page_provider.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Recipe extends StatelessWidget {
    RecipeInfo _recipeInfo;

    Color _difficultyColor;

    double _newRating;
    bool _rated = false;

    //bool _saved;


    void initializer(BuildContext context) async {
        var recipeProvider = Provider.of<
            RecipePageProvider>(context, listen: false);
        if (!recipeProvider.checkListeningAvailability()) {
            print("not available");
            return;
        }
        recipeProvider.initializeReadingVariables(_recipeInfo.ingredients
            .split("\n"), _recipeInfo.steps.split("\n"));
        recipeProvider.startKeyWordDetection();

        //Todo: add notifylisteners to show listening for keywords is activated
        //Todo: call checking function to see if listening is working

        print("initialized listening functions");
    }

    Recipe(RecipeInfo recipeInfo) {
        _recipeInfo = recipeInfo;


//        _saved = jsonDecode(RunTimeVariables.prefs
//            .getString("SavedRecipes"))["savedRecipes"]
//            .contains(_recipeInfo.id);


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
            builder: (context, provider, child) =>
                Scaffold(
                    appBar: AppBar(
                        leading: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                                if (_rated) {
                                    rate(_recipeInfo
                                        .id, _newRating);
                                }
                                provider.stopKeyWordDetection();
                                Navigator.of(context).pop();
                            }),
                    ),
                    body: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start,
                            children: [
                                Container(
                                    alignment: Alignment.topRight,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.4,
                                    child: IconButton(
                                        icon: Icon(Icons.star),
                                        //_saved ? Icons.star : Icons
                                        //                                            .star_border, color: Colors.yellow
                                        onPressed: () {
                                            //if(!_saved){
                                                provider.saveRecipe(_recipeInfo);
                                           // }
                                        },
                                    ),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(image: _recipeInfo.img, fit: BoxFit
                                            .cover)),
                                ),
                                Container(
                                    child: Text(
                                        "${_recipeInfo.recipeName}",
                                        style: TextStyle(fontWeight: FontWeight
                                            .bold, fontSize: 35),
                                        maxLines: 3,
                                        overflow: TextOverflow
                                            .ellipsis,
                                    )),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                        Container(
                                            margin: EdgeInsets.all(3),
                                            child: Text("ratings: ${_recipeInfo
                                                .ratings}",
                                                style: TextStyle(fontSize: 21)),
                                        ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                                Container(
                                                    child: Text(
                                                        "${_recipeInfo
                                                            .rating}",
                                                        style: TextStyle(fontSize: 21),
                                                    )),
                                                Container(
                                                    margin: EdgeInsets
                                                        .fromLTRB(3, 0, 3, 5),
                                                    child: RatingBar
                                                        .builder(
                                                        initialRating: _recipeInfo
                                                            .rating,
                                                        minRating: 1,
                                                        direction: Axis
                                                            .horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemPadding: EdgeInsets
                                                            .symmetric(horizontal: 4.0),
                                                        itemSize: 28,
                                                        itemBuilder: (context, _) =>
                                                            Icon(
                                                                Icons
                                                                    .star,
                                                                color: Colors
                                                                    .amber,
                                                            ),
                                                        onRatingUpdate: (rating) {
                                                            print(rating);
                                                            _newRating = rating;
                                                            _rated = true;
                                                        },
                                                    ),
                                                ),
                                            ],
                                        )
                                    ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .end,
                                    children: [
                                        Container(
                                            padding: EdgeInsets
                                                .fromLTRB(10, 3, 10, 3),
                                            margin: EdgeInsets
                                                .only(bottom: 7),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .all(Radius
                                                    .circular(15)),
                                                color: _difficultyColor,
                                            ),
                                            child: Text(
                                                "${_recipeInfo
                                                    .difficulty}",
                                                style: TextStyle(fontSize: 20),
                                            )),
                                        Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.25,
                                            child: Column(
                                                children: [
                                                    Icon(Icons
                                                        .access_alarm_outlined),
                                                    Text("${_recipeInfo
                                                        .totalTime}")
                                                ],
                                            ),
                                        ),
                                        Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.25,
                                            child: Column(
                                                children: [
                                                    Icon(CustomIcons
                                                        .food_1, size: 27),
                                                    Text("${_recipeInfo
                                                        .cookTime}")
                                                ],
                                            ),
                                        ),
                                        Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.25,
                                            child: Column(
                                                children: [
                                                    Icon(CustomIcons
                                                        .food),
                                                    Text("${_recipeInfo
                                                        .servings}")
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
                                    margin: EdgeInsets
                                        .fromLTRB(4, 10, 0, 4),
                                    child: Text(
                                        "Ingredients",
                                        style: TextStyle(fontWeight: FontWeight
                                            .bold, fontSize: 35),
                                    ),
                                ),
                                Container(
                                    margin: EdgeInsets.all(6),
                                    child: Text(
                                        _recipeInfo.ingredients,
                                        style: TextStyle(fontSize: 24),
                                    )),
                                Container(
                                    margin: EdgeInsets
                                        .fromLTRB(4, 10, 0, 4),
                                    child: Text(
                                        "Steps",
                                        style: TextStyle(fontWeight: FontWeight
                                            .bold, fontSize: 35),
                                    ),
                                ),
                                Container(
                                    margin: EdgeInsets.all(6),
                                    child: Text(
                                        _recipeInfo.steps,
                                        style: TextStyle(fontSize: 24),
                                    )
                                ),
                                Container(
                                    margin: EdgeInsets
                                        .fromLTRB(6, 12, 6, 0),
                                    child: Text(
                                        "Author: ${_recipeInfo
                                            .author}",
                                        style: TextStyle(fontSize: 24),
                                    )
                                ),

                                provider.error ? Scaffold.of(context)
                                    .showSnackBar(
                                    SnackBar(content: Text("Some Error"), duration: Duration(seconds: 4))
                                ) : Container()

                            ],
                        ),

                    )
                ),
        );
    }
}
