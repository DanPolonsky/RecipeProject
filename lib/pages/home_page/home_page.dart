import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/data_search.dart';
import 'package:flutter_app/pages/add_recipe_page/add_recipe_page.dart';
import 'package:flutter_app/pages/authentication/login_functions.dart';
import 'package:flutter_app/pages/authentication/login_page/login_page.dart';

import 'package:flutter_app/pages/local_recipes_page/local_recipes_page.dart';
import 'package:flutter_app/pages/recipe_page/recipe_page_provider.dart';

import 'package:provider/provider.dart';

import '../../global_variables.dart';
import '../waiting_page.dart';
import 'category_provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer2<CategoryRecipeListProvider, RecipePageProvider>(
        builder: (context, provider, recipeProvider, child) => Scaffold(
              appBar: AppBar(
                title: Text("Testing App"),
                centerTitle: true,
                elevation: 0,
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
              drawer: Drawer(
                child: ListView(
                  children: [
                    DrawerHeader(
                      child: Text('Drawer Header'),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                    ),
                    ListTile(
                      title: Text("Saved recipes"),
                      leading: Icon(Icons.star),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocalRecipesPage()),
                        );
                      },
                    ),
                    RunTimeVariables.loggedIn
                        ? ListTile(
                            title: Text("Add recipe"),
                            leading: Icon(Icons.add),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new AddRecipePage()),
                              );
                            })
                        : ListTile(
                            title: Text("Login"),
                            leading: Icon(Icons.login),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                              provider.resetPage();
                            },
                          ),
                    RunTimeVariables.loggedIn
                        ? ListTile(
                            title: Text("Sign out"),
                            leading: Icon(Icons.logout),
                            onTap: () {
                              logout();
                              Navigator.pop(context);
                              provider.resetPage();
                              print("popping");
                            })
                        : Container()
                  ],
                ),
              ),
              body: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  padding: EdgeInsets.only(bottom: screenHeight * 0.07),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (String category in Constants.categories)
                          Container(
                            margin: EdgeInsets.all(6),
                            child: RaisedButton(
                              elevation: 7.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: category == provider.currentCategory
                                      ? BorderSide(
                                          width: 1.5, color: Colors.grey[600])
                                      : BorderSide(color: Colors.transparent)),
                              onPressed: () =>
                                  provider.initializeNewCategory(category),
                              child: Text(category),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                provider.waitingPage ? RecipesWaitingPage() : RecipeCardList()
              ]),
            ));
  }
}

class RecipeCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryRecipeListProvider>(
      builder: (context, provider, child) => Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: NotificationListener<ScrollNotification>(
            // ignore: missing_return
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >
                  scrollInfo.metrics.maxScrollExtent -
                      MediaQuery.of(context).size.height) {
                provider.downloadListCategory();
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
