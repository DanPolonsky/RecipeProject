import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/local_recipes.dart';
import 'package:flutter_app/classes/recipeInfo.dart';
import 'package:flutter_app/recipe_card.dart';

class LocalRecipesProvider extends ChangeNotifier {
  List<Widget> _localRecipes = [];

  List<Widget> get localRecipes => _localRecipes;

  bool _storageError = false;

  bool get storageError => _storageError;

  bool _loadedRecipes = false;
  bool get loadedRecipes => _loadedRecipes;


  void reset(){
    _localRecipes = [];
    _loadedRecipes = false;
  }

  void getSavedRecipes() {
    Map<String, dynamic> savedRecipesMap = LocalRecipes.localRecipesMap;

    if (savedRecipesMap != {}) {
      savedRecipesMap.forEach((key, recipeJsonMap) {
        if(key.toLowerCase() != "placeholder"){
          RecipeInfo info = RecipeInfo.fromJson(recipeJsonMap);
          _localRecipes.add(RecipeCard(info));
        }


      });
    }
    else {
      _storageError = true;
    }
    print(localRecipes);

    _loadedRecipes = true;
    notifyListeners();
  }
}
