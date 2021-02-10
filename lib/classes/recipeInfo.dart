import 'package:flutter/cupertino.dart';

class RecipeInfo{
  int id;
  //int date;
  String ingredients;
  String recipeName;
  String steps;
  int views;
  double rating;
  String difficulty;
  String author;
  String cookTime;
  int ratings;
  String totalTime;
  int servings;
  String description;
  MemoryImage img;

  RecipeInfo(int id, String recipeName, int views, double rating,
      String difficulty, String author, String ingredients, String steps, String cookTime,
      int ratings, String totalTime, int servings, String description, MemoryImage img) {
    this.id = id;
    this.recipeName = recipeName;
    this.views = views;
    this.rating = rating;
    this.difficulty = difficulty;
    this.author = author;

    this.ingredients = ingredients;
    this.steps = steps;
    this.cookTime = cookTime;
    this.ratings = ratings;
    this.img = img;
    this.totalTime = totalTime;
    this.servings = servings;
    this.description = description;

  }
}