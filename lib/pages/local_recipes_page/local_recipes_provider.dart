import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/enums.dart';
import 'package:flutter_app/classes/local_recipes.dart';
import 'package:flutter_app/classes/recipe_info.dart';
import 'package:flutter_app/pages/general_widgets/recipe_card.dart';

class LocalRecipesProvider extends ChangeNotifier {
  List<Widget> _localRecipes = []; // List of RecipeCard shown on screen

  List<Widget> get localRecipes => _localRecipes;

  bool _storageError = false;

  bool get storageError => _storageError;

  bool _loadedRecipes =
      false; // Variable is true if saved recipes are loaded from storage
  bool get loadedRecipes => _loadedRecipes;

  /// Function updates the [recipeInfo] of a recipe on changes saved status
  void updateList(RecipeInfo recipeInfo) {
    try {
      if (recipeInfo.saved == SavedRecipeEnum.notSaved) {
        _localRecipes.removeWhere((element) =>
            (element as RecipeCard).recipeInfo.id == recipeInfo.id);
        notifyListeners();
      }
    } catch (error) {}
  }

  /// Function resets variables on page exit
  void reset() {
    _localRecipes = [];
    _loadedRecipes = false;
  }

  /// Function loaded the saved recipes from storage
  void getSavedRecipes() {
    Map<String, dynamic> savedRecipesMap = LocalRecipes.localRecipesMap;
    RecipeInfo info;

    if (savedRecipesMap != {}) {
      savedRecipesMap.forEach((key, recipeJsonMap) {
        if (key != "placeHolder") {
          info = RecipeInfo.fromJson(recipeJsonMap);
          info.saved = SavedRecipeEnum.saved;
          _localRecipes.add(RecipeCard(info));
        }
      });
    } else {
      _storageError = true;
    }
    print(localRecipes);

    _loadedRecipes = true;
    notifyListeners();
  }
}
