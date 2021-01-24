import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/functions.dart';


import 'package:flutter_rating_bar/flutter_rating_bar.dart';



// ignore: must_be_immutable
class Recipe extends StatelessWidget {
  int _id;

  //int _date;
  String _ingredients;
  String _recipeName;
  String _steps;
  int _views;
  double _rating;
  String _difficulty;
  String _author;
  String _cookTime;
  int _ratings;
  String _totalTime;
  int _servings;
  String _description;

  MemoryImage _img;

  Color _difficultyColor;

  double _newRating;
  bool _rated = false;

  Recipe(
      int id, String recipeName, int views, double rating,
      String difficulty, String author, String ingredients, String steps, String cookTime, int ratings, String totalTime, int servings, String description, MemoryImage img) {
    this._id = id;

    this._recipeName = recipeName;
    this._views = views;
    this._rating = rating;
    this._difficulty = difficulty;
    this._author = author;

    this._ingredients = ingredients;
    this._steps = steps;
    this._cookTime = cookTime;
    this._ratings = ratings;
    this._totalTime = totalTime;
    this._servings = servings;
    this._description = description;

    this._img = img;


    if(_difficulty == "easy"){
      _difficultyColor = Colors.green[600];
    }
    else if(_difficulty == "medium"){
      _difficultyColor = Colors.yellowAccent;
    }
    else{
      _difficultyColor = Colors.red;
    }

  }


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if(_rated) {
                rate(_id, _newRating);
              }
              Navigator.of(context).pop();
            }
           ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: _img,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              Container(
                  child: Text(
                    "$_recipeName",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(3),
                    child: Text(
                        "ratings: $_ratings",
                        style: TextStyle( fontSize: 21)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          child: Text(
                            "$_rating",
                            style: TextStyle( fontSize: 21),
                          )
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(3, 0, 3, 5),
                        child: RatingBar.builder(
                          initialRating: _rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemSize: 28,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      margin: EdgeInsets.all(3),
                      padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: _difficultyColor,
                      ),
                      child: Text(
                          "$_difficulty",
                           style: TextStyle(fontSize: 20),
                      )
                  ),
                  Container(
                    child: Column(
                      children: [
                        Icon(Icons.access_alarm_outlined),
                        Text("$_cookTime")
                      ],
                    ),

                  ),
                  Container(
                    child: Column(
                      children: [
                        Icon(Icons.add),
                        Text("$_totalTime")
                      ],
                    ),

                  ),
                  Container(
                    child: Column(
                      children: [
                        Icon(Icons.add),
                        Text("$_servings")
                      ],
                    ),

                  )


                ],

              ),
              Container(
                  margin: EdgeInsets.all(3),
                  child: Text(
                    _description,
                    style: TextStyle(fontSize: 24),
                  )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(4, 10, 0, 4),
                child: Text(
                  "Ingredients",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
              ),
              Container(
                  margin: EdgeInsets.all(6),
                  child: Text(
                    _ingredients,
                    style: TextStyle(fontSize: 24),
                  )),
              Container(
                margin: EdgeInsets.fromLTRB(4, 10, 0, 4),
                child: Text(
                  "Steps",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
              ),
              Container(
                  margin: EdgeInsets.all(6),
                  child: Text(
                    _steps,
                    style: TextStyle(fontSize: 24),
                  )
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(6, 12, 6, 0),
                  child: Text(
                    "Author: $_author",
                    style: TextStyle(fontSize: 24),
                  )
              )
            ],
          ),
        ));
  }
}
