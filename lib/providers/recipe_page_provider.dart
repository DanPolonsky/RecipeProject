

import 'package:flutter/cupertino.dart';


//Todo: change to listening function provider
//Todo: split to two providers
class RecipePageProvider extends ChangeNotifier {

    bool _listeningError = false;
    bool get listeningError => _listeningError;

    bool speechRecognitionAvailable;
    bool hotKeywordDetectionAvailable;


    bool listeningFunctionsAvailability(){
        print(speechRecognitionAvailable);
        print(hotKeywordDetectionAvailable);
        return speechRecognitionAvailable && hotKeywordDetectionAvailable;
    }

    void notifyError(String errorType){
        //Todo: check error types
        print(errorType);
        _listeningError = true;
        notifyListeners();
    }






}