import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/recipe_info.dart';
import 'package:flutter_app/pages/general_widgets/recipe_card.dart';
import '../../global_variables.dart';
import '../../functions.dart';
import '../general_widgets/reached_bottom_widget.dart';

/// Logic class that handles all functionality of home page
class CategoryRecipeListProvider with ChangeNotifier {
  bool _isLoading =
      false; // Variable represention if class is downloading recipes

  bool get isLoading => _isLoading;

  bool _waitingPage =
      false; // A bool describing if there should be a waiting page while something loads

  bool get waitingPage => _waitingPage;

  List<Widget> _recipeCardList =
      []; // A list containing all recipe cards shown on screen
  int _amount = Constants.loadingAmount; // Amount to load each time
  int _endIndex = Constants.firstLoad; // The recipe end index to download
  int _startIndex = 0; // The recipe start index to download

  String _currentCategory;
  String get currentCategory => _currentCategory;

  List<Widget> get categoryRecipeCardList => _recipeCardList;

  ScrollController _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  /// Function updates the RecipeInfo [recipeInfo]of recipe on changed saved status
  void updateRecipeInfo(RecipeInfo recipeInfo) {
    try {
      int index = _recipeCardList.indexWhere(
          (element) => (element as RecipeCard).recipeInfo.id == recipeInfo.id);

      _recipeCardList[index] = RecipeCard(recipeInfo);
      notifyListeners();
    } catch (error) {}
  }

  void resetPage() {
    notifyListeners();
  }

  /// Function initializes the recipeCardsList to a new [category]
  void initializeNewCategory(String category) async {
    if (!_waitingPage) {
      _waitingPage = true;
      notifyListeners();
      // resetting all parameters for new category
      _recipeCardList = [];
      _amount = Constants.loadingAmount;
      _endIndex = Constants.firstLoad; // change later
      _startIndex = 0;

      _currentCategory = category;

      _recipeCardList.add(new ReachedBottomWidget());
      await downloadListCategory();
      _waitingPage = false;
      notifyListeners();
    }
  }

  /// Function downloads an amount of recipeCards from the server using the function getRecipesCardsListByCategory
  void downloadListCategory() async {
    if (!_isLoading) {
      print("called download");

      _isLoading = true;

      List<Widget> list = await downloadRecipesByCategory(
          _currentCategory, _startIndex, _endIndex);

      _recipeCardList.insertAll(_recipeCardList.length - 1, list);
      _isLoading = false;

      if (list.length != 0) {
        _startIndex = _endIndex;
        _endIndex += _amount;
        notifyListeners();
      }
    }
  }
}
