import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Recipe extends StatelessWidget {
  int _id;
  int _recipeCardInfoId;

  //int _date;
  String _ingredients;
  String _recipeName;
  String _steps;

  int _views;
  double _rating;
  double _difficulty;
  String _author;
  MemoryImage _img;

  Recipe(
      int id,
      String recipeName,
      int views,
      double rating,
      double difficulty,
      String author,
      int recipeCardInfoId,
      String ingredients,
      String steps,
      MemoryImage img) {
    this._id = id;
    this._recipeName = recipeName;
    this._views = views;
    this._rating = rating;
    this._difficulty = difficulty;
    this._author = author;
    this._recipeCardInfoId = recipeCardInfoId;
    this._ingredients = ingredients;
    this._steps = steps;
    this._img = img;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Text("$_recipeName,  $_views"),
          width: 100,
          height: 100,
          color: Colors.lightBlue,
        ));
  }
}
