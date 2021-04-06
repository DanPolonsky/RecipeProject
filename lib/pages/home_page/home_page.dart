import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/data_search.dart';
import 'package:flutter_app/pages/add_recipe_page/add_recipe_page.dart';
import 'package:flutter_app/pages/authentication/login_page/login_page.dart';


import 'package:flutter_app/pages/local_recipes_page/local_recipes_page.dart';

import 'package:provider/provider.dart';

import '../../global_variables.dart';
import '../waiting_page.dart';
import 'category_provider.dart';

class Home extends StatelessWidget {
    final List<String> _categories = ["Popular", "Meat", "BreakFast", "Desert", "Vegan", "Fast"];

    @override
    Widget build(BuildContext context) {
     
        return Consumer<CategoryRecipeListProvider>(
            builder: (context, provider, child) =>
                
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/background2.jpg"), fit: BoxFit.cover
                    )
                ),
                child:Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                        title: Text("Testing App"),
                        centerTitle: true,
                        backgroundColor: Colors.transparent,
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
                                            MaterialPageRoute(builder: (context) =>
                                                LocalRecipesPage()),
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
                                                margin: EdgeInsets.all(6),
                                                child: RaisedButton(
                                                    elevation: 7.0,
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: category == provider.currentCategory ? BorderSide(width: 1.5, color: Colors.grey[600]) : BorderSide(color: Colors.transparent )
                                                    ),
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
                ),
        )

            );


    }
}

class RecipeCardList extends StatelessWidget {
    @override
    Widget build(BuildContext context) {

        return Consumer<CategoryRecipeListProvider>(
            builder: (context, provider, child) =>
                Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
                    child: NotificationListener<ScrollNotification>(
                        // ignore: missing_return
                        onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels > scrollInfo.metrics
                                .maxScrollExtent - MediaQuery
                                .of(context)
                                .size
                                .height) {
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
