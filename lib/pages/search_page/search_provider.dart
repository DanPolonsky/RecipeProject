import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../global_variables.dart';
import '../../functions.dart';




class SearchRecipeListProvider with ChangeNotifier {
    bool _isLoading = false;

    List<Widget> _recipeCardList = [];
    int _amount = Constants.loadingAmount;
    int _endIndex = Constants.endIndex; // change later
    int _startIndex = Constants.startIndex;

    String _currentSearchValue;
    String get currentSearchValue => _currentSearchValue;

    List<Widget> get searchRecipeCardList => _recipeCardList;

    void initializeNewSearch(String searchValue) async {
        _recipeCardList = [];
        _amount = Constants.loadingAmount;
        _endIndex = Constants.endIndex; // change later
        _startIndex = Constants.startIndex;
        _currentSearchValue = searchValue;

        await downloadListSearch(searchValue);
    }

    void downloadListSearch(String searchValue) async {
        if (!_isLoading) {
            _isLoading = true;
            List<Widget> list = await getRecipesCardsListBySearch(
                searchValue , _startIndex, _endIndex);
            _recipeCardList.addAll(list);
            notifyListeners();
            _isLoading = false;
            _startIndex = _endIndex;
            _endIndex += _amount;
        }
    }
}


