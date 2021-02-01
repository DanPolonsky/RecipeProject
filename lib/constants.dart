import 'package:shared_preferences/shared_preferences.dart';

class Constants{
  static final int firstLoad = 6;
  static final int loadingAmount = 4;
  static final int startIndex = 0;
  static final int endIndex = startIndex + loadingAmount + firstLoad;
}

class RunTimeVariables{
  static bool loggedIn;
  static SharedPreferences prefs;
}