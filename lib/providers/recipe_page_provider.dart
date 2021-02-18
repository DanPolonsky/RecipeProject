

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/enums.dart';
import 'package:flutter_app/classes/local_recipes.dart';
import 'package:flutter_app/classes/recipeInfo.dart';


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


    bool listeningFunctionsAvailability(){
        print(speechRecognitionAvailable);
        print(hotKeywordDetectionAvailable);
        return speechRecognitionAvailable && hotKeywordDetectionAvailable;
    }

    Future<void> callSavedRecipe(int recipeId) async{
        SavedRecipeEnum savedRecipeStatus = await LocalRecipes.savedRecipe(recipeId);
        if(savedRecipeStatus == SavedRecipeEnum.error){
            savedRecipe = false;
            notifyError("storage error");
        }
        else if(savedRecipeStatus == SavedRecipeEnum.saved){
            savedRecipe = true;

        }
        else{
            savedRecipe = false;
        }
    }

    //Todo: check if its better to let LocalRecipes access to provider instead of calling functions
    Future<void> callSaveNewRecipe(RecipeInfo recipeInfo){
        if(!_loading){
            _loading = true;
            bool savedRecipe = LocalRecipes.saveNewRecipe(recipeInfo);
            if(!savedRecipe){
                savedRecipe = false;
                notifyError("storage error");
            }
            else{
                savedRecipe = true;
            }
            _loading = false;
            notifyListeners();
        }


    }


    void notifyError(String errorType){
        //Todo: check error types
        print(errorType);
        if(errorType == "audio error"){
            _listeningError = true;
        }
        else if(errorType == "storage error"){
            _storageError = true;
        }

        notifyListeners();
    }






}