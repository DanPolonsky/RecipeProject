import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../functions.dart';

import '../login_functions.dart';

/// Logic class handling all functionallity of login page
class LoginPageProvider extends ChangeNotifier {
  GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // From key for submiting form
  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController get userNameTextController => _userNameTextController;

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController get passwordTextController => _passwordTextController;

  String _errorMsg = ""; // String holding error messages
  String get errorMsg => _errorMsg;

  bool _closeLoginPage =
      false; // A variable used to determine whether the page should close base on successful login
  bool get closeLoginPage => _closeLoginPage;

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

  /// Function sends login request to server based on user input
  void sendLoginRequest() async {
    if (_formKey.currentState.validate()) {
      _waitingCircle = _activeWaitingCircle;
      notifyListeners();

      String userName = _userNameTextController.text;
      String password = _passwordTextController.text;

      // Sending login request with the sendLoginPostRequest from the function file
      String loginResponseValue =
          await sendLoginPostRequest(userName, password);

      _waitingCircle = _passiveWaitingCircle;

      if (loginResponseValue == "logged in") {
        _closeLoginPage = true;
        _errorMsg = "";
        saveLoginParameters(userName, password);
        notifyListeners();
      } else {
        _errorMsg = loginResponseValue;
        notifyListeners();
      }
    }
  }
}
