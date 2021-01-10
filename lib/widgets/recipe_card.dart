import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../functions.dart';
import 'recipe.dart';

// ignore: must_be_immutable
class RecipeCard extends StatelessWidget {
  int _id;

  //int _date;
  String _ingredients;
  String _recipeName;
  String _steps;
  int _views;
  double _rating;
  double _difficulty;
  String _author;
  MemoryImage _img;


  RecipeCard(int id, String recipeName, int views, double rating,
      double difficulty, String author, String ingredients, String steps, MemoryImage img) {
    this._id = id;

    this._recipeName = recipeName;
    this._views = views;
    this._rating = rating;
    this._difficulty = difficulty;
    this._author = author;

    this._ingredients = ingredients;
    this._steps = steps;
    this._img = img;

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Recipe(_id, _recipeName, _views,
                      _rating, _difficulty, _author, _ingredients, _steps, _img
                  )
              )
          );
          addView(_id);
          
        },
        child: Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(image: _img, fit: BoxFit.cover)),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            width: constraints.maxWidth * 0.5,
                            child: Text(
                              "$_recipeName",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(4),
                            child: Text(
                              "$_views views",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(4),
                            child: Text(
                              "$_rating/5 rating",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(4),
                            child: Text(
                              "$_difficulty/5 difficulty",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ]
                );
              },
            )
        )
    );
  }
}
