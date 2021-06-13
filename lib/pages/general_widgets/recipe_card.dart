import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/enums.dart';
import 'package:flutter_app/classes/recipe_info.dart';
import 'package:flutter_app/pages/recipe_page/recipe.dart';

import '../../functions.dart';

// ignore: must_be_immutable
class RecipeCard extends StatelessWidget {
  RecipeInfo _recipeInfo;

  RecipeInfo get recipeInfo => _recipeInfo;

  Color _difficultyColor;

  RecipeCard(RecipeInfo recipeInfo) {
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
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Recipe(_recipeInfo),
            ),
          );
          addView(_recipeInfo.id);
        },
        child: Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.97,
            height: _recipeInfo.ratio >= 1
                ? MediaQuery.of(context).size.height * 0.4
                : MediaQuery.of(context).size.height * 0.6,
            //height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(image: _recipeInfo.img, fit: BoxFit.cover),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 6),
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  "${_recipeInfo.rating}/5",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                                  margin: EdgeInsets.only(top: 4),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: _difficultyColor,
                                  ),
                                  child: Text(
                                    "${_recipeInfo.difficulty}",
                                    style: TextStyle(fontSize: 20),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(
                            _recipeInfo.saved == SavedRecipeEnum.saved
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.yellow,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Colors.black.withOpacity(0.47),
                    ),
                    child: Center(
                      child: Container(

                        margin: EdgeInsets.all(5),
                        child: Text(
                          "${_recipeInfo.recipeName}",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  // Column(
                  //   children: [
                  //     Container(
                  //       margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                  //
                  //       child: Text(
                  //         "${_recipeInfo.recipeName}",
                  //         maxLines: 2,
                  //         overflow: TextOverflow.ellipsis,
                  //         softWrap: false,
                  //         style: TextStyle(
                  //             fontSize: 25,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Column(
                  //   children: [
                  //     Container(
                  //       margin: EdgeInsets.all(4),
                  //       child: Icon(
                  //         _recipeInfo.saved == SavedRecipeEnum.saved
                  //             ? Icons.star
                  //             : Icons.star_border,
                  //         color: Colors.yellow,
                  //         size: 24.0,
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.all(4),
                  //       child: Text(
                  //         "${_recipeInfo.views} views",
                  //         maxLines: 1,
                  //         overflow: TextOverflow.ellipsis,
                  //         softWrap: false,
                  //         style: TextStyle(
                  //             fontSize: 20,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.all(4),
                  //       child: Text(
                  //         "${_recipeInfo.rating}/5 rating",
                  //         maxLines: 1,
                  //         overflow: TextOverflow.ellipsis,
                  //         softWrap: false,
                  //         style: TextStyle(
                  //             fontSize: 20,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.all(4),
                  //       child: Text(
                  //         "${_recipeInfo.difficulty}",
                  //         maxLines: 1,
                  //         overflow: TextOverflow.ellipsis,
                  //         softWrap: false,
                  //         style: TextStyle(
                  //             fontSize: 20,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //     )
                  //   ],
                  // )
                ])));
  }
}
