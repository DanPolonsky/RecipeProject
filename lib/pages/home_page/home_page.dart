import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/data_search.dart';
import 'package:flutter_app/pages/add_recipe_page/add_recipe_page.dart';
import 'package:flutter_app/pages/authentication/login_page/login_page.dart';

import 'package:flutter_app/pages/authentication/login_page/login_page_provider.dart';
import 'package:flutter_app/pages/authentication/signup_page/signup_page_provider.dart';
import 'package:flutter_app/pages/local_recipes_page/local_recipes_page.dart';

import 'package:provider/provider.dart';

import '../../global_variables.dart';
import '../waiting_page.dart';
import 'category_provider.dart';

class Home extends StatelessWidget {
  final List<String> _categories = ["Popular", "Meat", "BreakFast", "Desert"];

  @override
  Widget build(BuildContext context) {
    print("building");
    return Consumer3<CategoryRecipeListProvider, LoginPageProvider,
        SignUpPageProvider>(
      builder: (context, provider, loginProvider, signUpProvider, child) =>
          Scaffold(
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
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
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
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );

                      },
                    ),
              ListTile(
                title: Text("Saved recipes"),
                leading: Icon(Icons.star),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocalRecipesPage()),
                  );

                },
              ),
            ],
          ),
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
              if (scrollInfo.metrics.pixels + 2 >
                      scrollInfo.metrics.maxScrollExtent -
                          MediaQuery.of(context).size.height * 0.1 &&
                  scrollInfo.metrics.pixels - 2 <
                      scrollInfo.metrics.maxScrollExtent -
                          MediaQuery.of(context).size.height * 0.1) {
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
