import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../functions.dart';

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
      String loginResponseValue = await sendLoginPostRequest(userName, password);
      _waitingCircle = _passiveWaitingCircle;
      if(loginResponseValue == "logged in"){
        _closeLoginPage = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('LoggedIn', true);
        Constants.loggedIn = true;
        notifyListeners();
      }

      else{
        _errorMsg = loginResponseValue;

        notifyListeners();
      }


    }


  }

}