import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global_variables.dart';

/// Function saves user info to local memory with sharedPreferences
/// Saves codeId for uploading recipes with [userName] and [password]
void saveLoginParameters(String userName, String password) {
  SharedPreferences prefs = RunTimeVariables.prefs;
  prefs.setBool('LoggedIn', true);

  // Creation of codeId for easier authentication of user
  var bytes = utf8.encode(userName + password);
  Digest digest = sha256.convert(bytes);
  String codeId = digest.toString();

  prefs.setString("codeId", codeId);
}

/// Function logs use out of the system, deleting the code id.
void logout() {
  SharedPreferences prefs = RunTimeVariables.prefs;
  prefs.setBool('LoggedIn', false);
  prefs.remove("codeId");
}
