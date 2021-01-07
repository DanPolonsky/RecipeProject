import 'package:flutter/material.dart';
import 'package:flutter_app/classes/recipe_list_provider.dart';

import 'package:provider/provider.dart';
import 'classes/DataSearch.dart';
import 'widgets/waitingPage.dart';

void main() async {
  return runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => CategoryRecipeListProvider()),
      ChangeNotifierProvider(create: (context) => SearchRecipeListProvider())
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Text-To-Speech Demo', home: WaitingPage());
  }
}

// ignore: must_be_immutable
class Home extends StatelessWidget {
  //String _category = "popular";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Testing App"),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  String result = await showSearch(
                      context: context, delegate: DataSearch());
                  print(result);
                })
          ],
        ),
        body: Consumer<CategoryRecipeListProvider>(
          builder: (context, provider, child) =>
              NotificationListener<ScrollNotification>(
            // ignore: missing_return
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                provider.downloadListCategory();
              }
            },
            child:SingleChildScrollView(
              child: Column(children: provider.categoryRecipeCardList),
            )
//            child: ListView(
//              children: provider.categoryRecipeCardList,
//            ),
          ),
        ));
  }
}
