import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../functions.dart';
import 'package:crypto/crypto.dart';



class LoginPageProvider extends ChangeNotifier{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController get userNameTextController => _userNameTextController;

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController get passwordTextController => _passwordTextController;

  String _errorMsg = "";
  String get errorMsg => _errorMsg;

  bool _closeLoginPage = false;
  bool get closeLoginPage => _closeLoginPage;


  Widget _activeWaitingCircle = Container(


    child: SpinKitCircle(
      color: Colors.green,
      size: 50.0,
    ),
  );

  Widget _passiveWaitingCircle = Container(
    height: 50,
  );

  Widget _waitingCircle = Container(
    height: 50,
  );

  Widget get waitingCircle => _waitingCircle;




  void sendLoginRequest() async{
    if(_formKey.currentState.validate()){
      _waitingCircle = _activeWaitingCircle;
      notifyListeners();

      String userName = _userNameTextController.text;
      String password = _passwordTextController.text;

      // Sending login request with the sendLoginPostRequest from the function file
      String loginResponseValue = await sendLoginPostRequest(userName, password);

      _waitingCircle = _passiveWaitingCircle;

      if(loginResponseValue == "logged in"){
        _closeLoginPage = true;
        SharedPreferences prefs = RunTimeVariables.prefs;
        prefs.setBool('LoggedIn', true);

        var bytes = utf8.encode(userName+password);
        Digest digest = sha256.convert(bytes);
        String codeId = digest.toString();
        print(codeId);
        prefs.setString("codeId", codeId);

        RunTimeVariables.loggedIn = true;
        notifyListeners();
      }

      else{
        _errorMsg = loginResponseValue;
        notifyListeners();
      }

    }


  }

}