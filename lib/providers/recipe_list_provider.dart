import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../functions.dart';


class CategoryRecipeListProvider with ChangeNotifier {
    bool _isLoading = false;

    bool get isLoading => _isLoading;

    List<Widget> _recipeCardList = [];
    int _amount = Constants.loadingAmount;
    int _endIndex = Constants.endIndex; // change later
    int _startIndex = Constants.startIndex;

    String _currentCategory;

    List<Widget> get categoryRecipeCardList => _recipeCardList;

    ScrollController _scrollController = ScrollController();

    ScrollController get scrollController => _scrollController;


    /// Function initializes the recipeCardsList to a new category
    void initializeNewCategory(String category) async {
        // resetting all parameters for new category
        _recipeCardList = [];
        _amount = Constants.loadingAmount;
        _endIndex = Constants.endIndex; // change later
        _startIndex = Constants.startIndex;

        _currentCategory = category;

        await downloadListCategory(true);
    }

    /// Function downloads an amount of recipeCards from the server using the function getRecipesCardsListByCategory
    void downloadListCategory(bool waitingScreen) async {
        if (!_isLoading) {
            _isLoading = true;
            if (waitingScreen) {
                print("waiting screen");
                notifyListeners();

            }

            List<Widget> list = await getRecipesCardsListByCategory(
                _currentCategory, _startIndex, _endIndex);

            _recipeCardList.addAll(list);
            _isLoading = false;

            if(list.length != 0){
                notifyListeners();
                _startIndex = _endIndex;
                _endIndex += _amount;
            }
        }
    }
}


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


