import 'package:flutter/material.dart';
import 'package:flutter_app/classes/recipe_list_provider.dart';
import 'package:flutter_app/widgets/recipes_page.dart';
import 'package:flutter_app/widgets/waiting_page.dart';
import 'package:provider/provider.dart';

class DataSearch extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context){
    var recipeListProvider =
        Provider.of<SearchRecipeListProvider>(context, listen: false);

    Future<List<Widget>> getList() async {
      await recipeListProvider.initializeNewSearch("search value");
      return recipeListProvider.searchRecipeCardList;
    }

    return FutureBuilder<List<Widget>>(
      future: getList(),

      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        //TODO: add error else if
        if(snapshot.hasData){
          return SearchRecipesPage();
        }

        else{
          return SearchWaitingPage();
        }
      },
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }

}