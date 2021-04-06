import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../global_variables.dart';
import '../../functions.dart';
import '../reached_bottom_widget.dart';

class CategoryRecipeListProvider with ChangeNotifier {
    bool _isLoading = false;

    bool get isLoading => _isLoading;

    bool _waitingPage = false;

    bool get waitingPage => _waitingPage;


    List<Widget> _recipeCardList = [];
    int _amount = Constants.loadingAmount;
    int _endIndex = Constants.endIndex; // change later
    int _startIndex = Constants.startIndex;

    String _currentCategory;
    String get currentCategory => _currentCategory;

    List<Widget> get categoryRecipeCardList => _recipeCardList;

    ScrollController _scrollController = ScrollController();

    ScrollController get scrollController => _scrollController;



    /// Function initializes the recipeCardsList to a new category
    void initializeNewCategory(String category) async {
        if(!_waitingPage){
          _waitingPage = true;
          notifyListeners();
          // resetting all parameters for new category
          _recipeCardList = [];
          _amount = Constants.loadingAmount;
          _endIndex = Constants.endIndex; // change later
          _startIndex = Constants.startIndex;

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
