import 'package:flutter/material.dart';
import 'file:///D:/flutter%20project/flutter_app/lib/providers/recipe_list_provider.dart';
import 'package:flutter_app/widgets/recipes_page.dart';
import 'package:flutter_app/widgets/waiting_page.dart';
import 'package:provider/provider.dart';


// class that handles search
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

  // builds button on the left of search bar
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // return results based on searching
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