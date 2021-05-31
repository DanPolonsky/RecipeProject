import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../functions.dart';

import '../login_functions.dart';

class SignUpPageProvider extends ChangeNotifier {
  GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // From key for submiting form
  GlobalKey<FormState> get formKey => _formKey;

  // A collection a text controllers for username and passwords
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController get userNameTextController => _userNameTextController;

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController get passwordTextController => _passwordTextController;

  TextEditingController _repeatPasswordTextController = TextEditingController();
  TextEditingController get repeatPasswordTextController =>
      _repeatPasswordTextController;

  String _errorMsg = "";
  String get errorMsg => _errorMsg;

  bool _closeSignUpPage =
      false; // A variable used to determine whether the page should close base on successful signUp
  bool get closeSignUpPage => _closeSignUpPage;

  // Different waiting circles based on situation
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

  void reset(){
    _userNameTextController.text = "";
    _passwordTextController.text = "";
    _repeatPasswordTextController.text = "";
    _errorMsg = "";
  }

  /// Function sends a SignUp request to server using a network function from the functions file
  void sendSingUpRequest() async {
    if (_formKey.currentState.validate()) {
      String userName = _userNameTextController.text;
      String password = _passwordTextController.text;
      String repeatPassword = _repeatPasswordTextController.text;

      // Checking whether the two password match
      if (password != repeatPassword) {
        _errorMsg = "Passwords do not match.";
        notifyListeners();
        return;
      }

      // Making waiting circle while sending request to server
      _waitingCircle = _activeWaitingCircle;
      notifyListeners();

      // Sending sipgn up request with the sendSignUPostRequest from the function file
      String signUpResponseValue =
          await sendSignUpPostRequest(userName, password);

      _waitingCircle = _passiveWaitingCircle;

      if (signUpResponseValue == "signed up") {
        _closeSignUpPage = true;
        _errorMsg = "";
        saveLoginParameters(userName, password);
        notifyListeners();
      } else {
        _errorMsg = signUpResponseValue;
        notifyListeners();
      }
    }
  }
}
