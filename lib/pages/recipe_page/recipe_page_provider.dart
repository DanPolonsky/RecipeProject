import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/audio_classes/hotkeyword_detection.dart';
import 'package:flutter_app/classes/enums.dart';
import 'package:flutter_app/classes/local_recipes.dart';
import 'package:flutter_app/classes/recipe_info.dart';
import 'package:flutter_app/pages/home_page/category_provider.dart';
import 'package:flutter_app/pages/local_recipes_page/local_recipes_provider.dart';
import 'package:flutter_app/pages/search_page/search_provider.dart';
import 'package:provider/provider.dart';

import '../../functions.dart';

//Todo: change to listening function provider
//Todo: split to two providers
class RecipePageProvider extends ChangeNotifier {
  bool _listeningError = false;
  bool get listeningError => _listeningError;

  bool speechRecognitionAvailable;
  bool hotKeywordDetectionAvailable;

  bool _storageError = false;
  bool get storageError => _storageError;

  bool savedRecipe = false;

  bool _loading = false;

  double newRating;
  bool rated = false;

  void reset(RecipeInfo recipeInfo) {
    if (rated) {
      rate(recipeInfo.id, newRating);
    }

    HotKeyWordDetection.stopKeyWordDetection();
    savedRecipe = false;
    rated = false;
  }

  void updateRecipeInfo(BuildContext context, RecipeInfo recipeInfo) {
    final categoryProvider =
        Provider.of<CategoryRecipeListProvider>(context, listen: false);

    categoryProvider.updateRecipeInfo(recipeInfo);

    final searchProvider =
        Provider.of<SearchRecipeListProvider>(context, listen: false);

    searchProvider.updateRecipeInfo(recipeInfo);

    final localRecipesProvider =
        Provider.of<LocalRecipesProvider>(context, listen: false);
    localRecipesProvider.updateList(recipeInfo);
  }

  bool listeningFunctionsAvailability() {
    print(speechRecognitionAvailable);
    print(hotKeywordDetectionAvailable);
    return speechRecognitionAvailable && hotKeywordDetectionAvailable;
  }

  Future<void> checkRecipeSavedStatus(RecipeInfo info) async {
    SavedRecipeEnum savedRecipeStatus = info.saved;
    print(savedRecipeStatus);
    if (savedRecipeStatus == SavedRecipeEnum.error) {
      savedRecipe = false;
      notifyError("storage error");
    } else if (savedRecipeStatus == SavedRecipeEnum.saved) {
      savedRecipe = true;
    } else {
      savedRecipe = false;
    }
  }

  //Todo: check if its better to let LocalRecipes access to provider instead of calling functions
  // ignore: missing_return
  Future<void> callSaveNewRecipe(RecipeInfo recipeInfo) {
    if (!_loading) {
      _loading = true;
      recipeInfo.saved = SavedRecipeEnum.saved;
      bool saved = LocalRecipes.saveNewRecipe(recipeInfo);
      if (!saved) {
        savedRecipe = false;
        notifyError("storage error");
      } else {
        savedRecipe = true;

        print("saved recipe");
      }
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> callDeleteSavedRecipe(RecipeInfo recipeInfo) {
    if (!_loading) {
      _loading = true;
      recipeInfo.saved = SavedRecipeEnum.notSaved;
      bool noError = LocalRecipes.deleteSavedRecipe(recipeInfo);

      if (noError) {
        savedRecipe = false;
        print("saved recipe");
      } else {
        savedRecipe = true;
        notifyError("storage error");
      }

      _loading = false;
      notifyListeners();
    }
  }

  void notifyError(String errorType) {
    //Todo: check error types
    print(errorType);
    if (errorType == "audio error") {
      _listeningError = true;
    } else if (errorType == "storage error") {
      _storageError = true;
    }
    notifyListeners();
  }
}
