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

/// Logic class handling all recipe page functionality
class RecipePageProvider extends ChangeNotifier {
  bool _listeningError = false; // True if there is error in SpeechRecognition
  bool get listeningError => _listeningError;

  bool speechRecognitionAvailable;
  bool hotKeywordDetectionAvailable;

  bool _storageError = false; // True if there is error in storage of recipes
  bool get storageError => _storageError;

  bool savedRecipe = false; // True if recipe is saved on the phone

  bool _loading = false; // True if download function is working

  double newRating; // A rating the user chose
  bool rated = false; // True if the user chose a rating

  /// Function resets all variables when user exists
  void reset(RecipeInfo recipeInfo) {
    if (rated) {
      rate(recipeInfo.id, newRating);
    }

    HotKeyWordDetection.stopKeyWordDetection();
    savedRecipe = false;
    rated = false;
  }

  /// Function calles update functions from different providers by using [context] and changing the saved status in [recipeInfo]
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

  /// Function checks the avaliablity of the various listening objects
  /// Returns true if all objects are avaliable
  bool listeningFunctionsAvailability() {
    print(speechRecognitionAvailable);
    print(hotKeywordDetectionAvailable);
    return speechRecognitionAvailable && hotKeywordDetectionAvailable;
  }

  /// Function checks the saves status by using [info]
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

  /// Function saves recipe [recipeInfo] with the LocalRecipes function
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

  /// Function deletes recipe [recipeInfo] with the LocalRecipes function
  Future<void> callDeleteSavedRecipe(RecipeInfo recipeInfo) {
    if (!_loading) {
      _loading = true;
      recipeInfo.saved = SavedRecipeEnum.notSaved;
      bool success = LocalRecipes.deleteSavedRecipe(recipeInfo);

      if (success) {
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

  /// Function shows error msg [errorType]
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
