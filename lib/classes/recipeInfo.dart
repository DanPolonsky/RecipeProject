import 'package:flutter/cupertino.dart';
import 'package:convert/convert.dart';
class RecipeInfo {
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

    RecipeInfo.fromJson(Map<String, dynamic> json)
        : id = json["id"],
            ingredients = json["ingredients"],
            recipeName = json["recipeName"],
            steps = json["steps"],
            views = json["views"],
            rating = json["rating"],
            difficulty = json["difficulty"],
            author = json["author"],
            cookTime = json["cookTime"],
            ratings = json["ratings"],
            totalTime = json["totalTime"],
            servings = json["servings"],
            description = json["description"],
            img = MemoryImage(hex.decode(json["data"]));


    Map<String, dynamic> toJson() =>
        {
          "id":id,
          "ingredients":ingredients,
          "recipeName": recipeName,
          "steps": steps,
          "views": views,
          "rating": rating,
          "difficulty": difficulty,
          "author": author,
          "cookTime": cookTime,
          "ratings": ratings,
          "totalTime": totalTime,
          "servings": servings,
          "description": description,
          "data": hex.encode(img.bytes)
        };



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