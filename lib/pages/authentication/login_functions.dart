

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global_variables.dart';

/// Function is called after successful login or signUp.
/// Saves to local memory with prefs - login status = true, and saves to runTimeVariables the login status = true for easier access
/// Saves codeId for uploading recipes with [userName] and [password]
void saveLoginParameters(String userName, String password){
    SharedPreferences prefs = RunTimeVariables.prefs;
    prefs.setBool('LoggedIn', true);

    var bytes = utf8.encode(userName+password);
    Digest digest = sha256.convert(bytes);
    String codeId = digest.toString();

    prefs.setString("codeId", codeId);



}



/// Function loges use out of the system, deleting the code id.
void logout(){
  SharedPreferences prefs = RunTimeVariables.prefs;
  prefs.setBool('LoggedIn', false);
  prefs.remove("codeId");

}
