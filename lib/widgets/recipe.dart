import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Recipe extends StatelessWidget {
  int _id;

  //int _date;
  String _ingredients;
  String _recipeName;
  String _steps;
  int _views;
  double _rating;
  double _difficulty;
  String _author;
  String _cookTime;
  MemoryImage _img;


  Recipe(int id, String recipeName, int views, double rating,
      double difficulty, String author, String ingredients, String steps, String cookTime,MemoryImage img) {
    this._id = id;

    this._recipeName = recipeName;
    this._views = views;
    this._rating = rating;
    this._difficulty = difficulty;
    this._author = author;

    this._ingredients = ingredients;
    this._steps = steps;
    this._cookTime = cookTime;
    this._img = img;

  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            child: Text("$_recipeName,  $_views"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
                image: DecorationImage(image: _img, fit: BoxFit.cover)
            )));
  }
}
