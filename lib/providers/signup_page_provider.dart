import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../functions.dart';
import 'package:crypto/crypto.dart';

import 'login_functions.dart';



class SignUpPageProvider extends ChangeNotifier{
    /// A form key for the form widget to work properly
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    GlobalKey<FormState> get formKey => _formKey;


    /// A collection a text controllers to get the text out of TextFields

    TextEditingController _userNameTextController = TextEditingController();
    TextEditingController get userNameTextController => _userNameTextController;

    TextEditingController _passwordTextController = TextEditingController();
    TextEditingController get passwordTextController => _passwordTextController;

    TextEditingController _repeatPasswordTextController = TextEditingController();
    TextEditingController get repeatPasswordTextController => _repeatPasswordTextController;



    String _errorMsg = "";
    String get errorMsg => _errorMsg;

    /// A variable used to determine whether the page should close base on successful signUp
    bool _closeSignUpPage = false;
    bool get closeSignUpPage => _closeSignUpPage;



    /// A widget _waitingCircle will be equal to when sending request
    Widget _activeWaitingCircle = Container(
        child: SpinKitCircle(
            color: Colors.green,
            size: 50.0,
        ),
    );

    /// A widget _waitingCircle will be equal to when until sending request
    Widget _passiveWaitingCircle = Container(
        height: 50,
    );

    /// default _waitingCircle
    Widget _waitingCircle = Container(
        height: 50,
    );

    Widget get waitingCircle => _waitingCircle;



    /// Function sends a SignUp request to server using a network function from the functions file
    void sendSingUpRequest() async{
        if(_formKey.currentState.validate()){

            String userName = _userNameTextController.text;
            String password = _passwordTextController.text;
            String repeatPassword = _repeatPasswordTextController.text;

            /// Checking whether the two password match
            if(password != repeatPassword){
                _errorMsg = "Passwords do not match.";
                notifyListeners();
                return;
            }

            /// Making waiting circle while sending request to server
            _waitingCircle = _activeWaitingCircle;
            notifyListeners();

            /// Sending sipgn up request with the sendSignUPostRequest from the function file
            String signUpResponseValue = await sendSignUpPostRequest(userName, password);

            _waitingCircle = _passiveWaitingCircle;

            if(signUpResponseValue == "signed up"){
                _closeSignUpPage = true;
                saveLoginParameters(userName, password);
                notifyListeners();
            }


            else{
                _errorMsg = signUpResponseValue;
                notifyListeners();
            }

        }


    }




}

