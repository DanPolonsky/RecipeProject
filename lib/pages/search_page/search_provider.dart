import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/recipe_info.dart';
import '../../functions.dart';
import '../../global_variables.dart';

import '../general_widgets/recipe_card.dart';
import '../general_widgets/reached_bottom_widget.dart';

class SearchRecipeListProvider with ChangeNotifier {
  bool _isLoading = false;

  List<Widget> _recipeCardList = [];
  int _amount = Constants.loadingAmount;
  int _endIndex = Constants.firstLoad; // change later
  int _startIndex = 0;

  String _currentSearchValue;

  String get currentSearchValue => _currentSearchValue;

  List<Widget> get searchRecipeCardList => _recipeCardList;

  bool _waitingPage = false;

  bool get waitingPage => _waitingPage;

  void updateRecipeInfo(RecipeInfo recipeInfo) {
    try {
      int index = _recipeCardList.indexWhere(
          (element) => (element as RecipeCard).recipeInfo.id == recipeInfo.id);

      _recipeCardList[index] = RecipeCard(recipeInfo);
      notifyListeners();
    } catch (error) {}
  }

  void initializeNewSearch(String searchValue) async {
    // resetting all parameters for new category
    _recipeCardList = [];
    _amount = Constants.loadingAmount;
    _endIndex = Constants.firstLoad; // change later
    _startIndex = 0;

    _currentSearchValue = searchValue;

    _recipeCardList.add(new ReachedBottomWidget());
    await downloadListSearch();
  }

  void downloadListSearch() async {
    if (!_isLoading) {
      _isLoading = true;
      List<Widget> list = await getRecipesCardsListBySearch(
          _currentSearchValue, _startIndex, _endIndex);
      _recipeCardList.insertAll(_recipeCardList.length - 1, list);
      notifyListeners();
      _isLoading = false;
      _startIndex = _endIndex;
      _endIndex += _amount;
    }
  }
}
