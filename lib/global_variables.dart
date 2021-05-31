import 'package:shared_preferences/shared_preferences.dart';

/// Class containing a few application constants
class Constants {
  static final int firstLoad =
      10; // The recipes amount to load when initializing new category or search
  static final int loadingAmount =
      4; // the recipes amount to load when scrolling down

  // List of home recipe categories.
  static final List<String> categories = [
    "Popular",
    "New",
    "Meat",
    "BreakFast",
    "Desert",
    "Vegan",
    "Fast"
  ];
}

/// Class containing variables which are initialized during start up for later use in various places in the application
class RunTimeVariables {
  static SharedPreferences
      prefs; // Variable gives access to stored long term variables
}
