import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/providers/add_recipe_page_provider.dart';
import 'package:flutter_app/providers/category_provider.dart';
import 'package:flutter_app/providers/login_page_provider.dart';
import 'package:flutter_app/providers/recipe_page_provider.dart';
import 'package:flutter_app/providers/signup_page_provider.dart';
import 'package:flutter_app/widgets/add_recipe_page.dart';
import 'package:flutter_app/widgets/login_page.dart';
import 'package:provider/provider.dart';
import 'classes/data_search.dart';
import 'global_variables.dart';
import 'providers/search_provider.dart';
import 'widgets/waiting_page.dart';

void main() async {
  //return runApp(MyApp2());

  return runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => CategoryRecipeListProvider()),
      ChangeNotifierProvider(create: (context) => SearchRecipeListProvider()),
      ChangeNotifierProvider(create: (context) => AddRecipePageProvider()),
      ChangeNotifierProvider(create: (context) => LoginPageProvider()),
      ChangeNotifierProvider(create: (context) => SignUpPageProvider()),
      ChangeNotifierProvider(create: (context) => RecipePageProvider())
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Text-To-Speech Demo', home: InitialWaitingPage());
  }
}

class Home extends StatelessWidget {
  final List<String> _categories = ["Popular", "Meat", "BreakFast", "Desert"];

  @override
  Widget build(BuildContext context) {
    return Consumer3<CategoryRecipeListProvider, LoginPageProvider,
        SignUpPageProvider>(
      builder: (context, provider, loginProvider, signUpProvider, child) =>
          Scaffold(
        appBar: AppBar(
          title: Text("Testing App"),
          centerTitle: true,
          leading: RunTimeVariables.loggedIn
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new AddRecipePage()),
                    );
                  })
              : Container(
                  //margin: EdgeInsets.all(4),
                  child: IconButton(
                    //padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: Icon(Icons.login),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ),
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
        body: Stack(children: [
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (String category in _categories)
                    Container(
                      margin: EdgeInsets.all(4),
                      child: RaisedButton(
                        onPressed: () =>
                            provider.initializeNewCategory(category),
                        child: Text(category),
                      ),
                    ),
                ],
              ),
            ),
          ),
          provider.isLoading ? RecipesWaitingPage() : RecipeCardList()
        ]),
      ),
    );
  }
}

class RecipeCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryRecipeListProvider>(
      builder: (context, provider, child) => Container(
        margin: EdgeInsets.only(top: 55),
        child: NotificationListener<ScrollNotification>(

            // add loading animation, maxScrollExtent-number of animation pixels
            // ignore: missing_return
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                provider.downloadListCategory(false);
              }
            },
            child: SingleChildScrollView(
              controller: provider.scrollController,
              child: Column(children: provider.categoryRecipeCardList),
            )),
      ),
    );
  }
}
