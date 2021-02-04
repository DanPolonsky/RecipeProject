import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

//class RecipePageProvider extends ChangeNotifier{
//    stt.SpeechToText speech = stt.SpeechToText();
//
//    void initializeSpeechToText() async{
//        bool available = await speech.initialize( onStatus: statusListener, onError: errorListener );
//        if ( available ) {
//            speech.listen( onResult: resultListener );
//        }
//        else {
//            print("The user has denied the use of speech recognition.");
//        }
//    }
//
//}