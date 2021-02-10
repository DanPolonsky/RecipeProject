
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';

class MyApp2 extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Text-To-Speech Demo', home: Test());
  }
}


class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  SpeechToText _speech = SpeechToText();
  SpeechToTextProvider _speechProvider;



  void initializeSpeechProvider() async{
    _speechProvider = SpeechToTextProvider(_speech);
    await _speechProvider.initialize();

    // if(_available){
    //
    // }
    // else{
    //
    // }

  }

  void startListening(){
    if(!_speechProvider.isListening) {
      print("listening");
      _speechProvider.listen();
    }
  }





  void initState(){
    super.initState();
    initializeSpeechProvider();
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [Center(
            child: FlatButton(
              onPressed: () => startListening(),
              color: Colors.red,
              child: Text("listen"),
            ),
          ),
          _speechProvider.isListening ? Text("listening") : Text("not Listening")

          ],
        ),
      ),
    );
  }
}
