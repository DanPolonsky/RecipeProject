import 'package:flutter/cupertino.dart';
import '../constants.dart';
import '../functions.dart';

class CategoryRecipeListProvider with ChangeNotifier {
  bool _isLoading = false;

  List<Widget> _recipeCardList = [];
  int _amount = Constants.loadingAmount;
  int _endIndex = Constants.endIndex; // change later
  int _startIndex = Constants.startIndex;

  String _currentCategory;

  List<Widget> get categoryRecipeCardList => _recipeCardList;

  void initializeNewCategory(String category) async {
    print("in initialize");
    _recipeCardList = [];
    _amount = Constants.loadingAmount;
    _endIndex = Constants.endIndex; // change later
    _startIndex = Constants.startIndex;

    _currentCategory = category;
    var startingTime = new DateTime.now();
    await downloadListCategory();
    var endingTime = new DateTime.now();
    print("difference");
    print(endingTime.difference(startingTime).inSeconds);
  }

  void downloadListCategory() async {
    if(!_isLoading) {
      _isLoading = true;
      List<Widget> list = await getRecipesCardsListByCategory(
          _currentCategory, _startIndex, _endIndex);
      _recipeCardList.addAll(list);
      notifyListeners();
      _isLoading = false;
      _startIndex = _endIndex;
      _endIndex += _amount;
    }
  }
}



class SearchRecipeListProvider with ChangeNotifier {
  bool _isLoading = false;

  List<Widget> _recipeCardList = [];
  int _amount = Constants.loadingAmount;
  int _endIndex = Constants.endIndex; // change later
  int _startIndex = Constants.startIndex;

  String _currentSearch;

  List<Widget> get searchRecipeCardList => _recipeCardList;

  void initializeNewSearch(String searchValue) async {
    _recipeCardList = [];
    _amount = Constants.loadingAmount;
    _endIndex = Constants.endIndex; // change later
    _startIndex = Constants.startIndex;

    _currentSearch = searchValue;
    await downloadListSearch();
  }

  void downloadListSearch() async {
    if (!_isLoading) {
      _isLoading = true;
      List<Widget> list = await getRecipesCardsListBySearch(
          _currentSearch, _startIndex, _endIndex);
      _recipeCardList.addAll(list);
      notifyListeners();
      _isLoading = false;
      _startIndex = _endIndex;
      _endIndex += _amount;
    }
  }
}
