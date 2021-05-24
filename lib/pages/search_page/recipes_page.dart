import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'search_provider.dart';

// ignore: must_be_immutable
class SearchRecipesPage extends StatelessWidget {
  List<Widget> recipeCardList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<SearchRecipeListProvider>(
      builder: (context, provider, child) =>
          NotificationListener<ScrollNotification>(
        // ignore: missing_return
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            provider.downloadListSearch();
          }
        },
        child: ListView(
          children: List<Widget>.from(provider.searchRecipeCardList),
        ),
      ),
    ));
  }
}
