import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../waiting_page.dart';
import 'search_provider.dart';

// ignore: must_be_immutable
class SearchRecipesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchRecipeListProvider>(
        builder: (context, provider, child) => Scaffold(
              appBar: AppBar(
                title: Text("Search page"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {

                    provider.reset();
                    Navigator.pop(context);
                  } ,
                ),
              ),
              body: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 10, 5, 30),
                    child: TextFormField(
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (String value) {
                        provider.initializeNewSearch(value);
                      },
                      controller: provider.searchValueController,
                      decoration: InputDecoration(
                        hintText: "Search something ...",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        isDense: true,
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  provider.waitingPage ? RecipesWaitingPage() : RecipeCardList()
                ],
              ),
            ));
  }
}

class RecipeCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchRecipeListProvider>(
      builder: (context, provider, child) => Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: NotificationListener<ScrollNotification>(
            // ignore: missing_return
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >
                  scrollInfo.metrics.maxScrollExtent -
                      MediaQuery.of(context).size.height) {
                provider.downloadListSearch();
              }
            },
            child: ListView.builder(
              controller: provider.scrollController,
              itemCount: provider.searchRecipeCardList.length,
              itemBuilder: (BuildContext context, int index) {
                return provider.searchRecipeCardList[index];
              },
            )),
      ),
    );
  }
}
