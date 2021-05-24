import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/enums.dart';
import 'package:flutter_app/classes/local_recipes.dart';
import 'package:flutter_app/classes/recipe_info.dart';
import 'package:flutter_app/pages/general_widgets/recipe_card.dart';

class LocalRecipesProvider extends ChangeNotifier {
  List<Widget> _localRecipes = [];

  List<Widget> get localRecipes => _localRecipes;

  bool _storageError = false;

  bool get storageError => _storageError;

  bool _loadedRecipes = false;
  bool get loadedRecipes => _loadedRecipes;

  // Parameters for rating the recipe/

  void updateList(RecipeInfo recipeInfo) {
    try {
      _localRecipes.removeWhere(
          (element) => (element as RecipeCard).recipeInfo.id == recipeInfo.id);
      notifyListeners();
    } catch (error) {}
  }

  void reset() {
    _localRecipes = [];
    _loadedRecipes = false;
  }

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
