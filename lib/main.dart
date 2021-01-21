import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/providers/add_recipe_page_provider.dart';
import 'package:flutter_app/providers/recipe_list_provider.dart';
import 'package:flutter_app/widgets/add_recipe_page.dart';
import 'package:provider/provider.dart';
import 'classes/data_search.dart';
import 'widgets/waiting_page.dart';

void main() async {
  return runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => CategoryRecipeListProvider()),
      ChangeNotifierProvider(create: (context) => SearchRecipeListProvider()),
      ChangeNotifierProvider(create: (context) => AddRecipePageProvider())
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


class Home extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryRecipeListProvider>(
      builder: (context, provider, child) =>
          Scaffold(
            appBar: AppBar(
              title: Text("Testing App"),
              centerTitle: true,

              leading: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddRecipePage()),
                    );
                  }),

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

            body:
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,

                  child: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(4),
                            child: RaisedButton(
                              onPressed: () => provider.initializeNewCategory("meat", true),
                              child: Text("meat"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(4),
                            child: RaisedButton(
                              onPressed: () => provider.initializeNewCategory("meat", true),
                              child: Text("puk"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 55),
                  child: NotificationListener<ScrollNotification>(

                    // add loading animation, maxScrollExtent-number of animation pixels
                    // ignore: missing_return
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          provider.downloadListCategory();
                        }
                      },
                      child: SingleChildScrollView(
                        controller: provider.scrollController,
                        child: Column(children: provider.categoryRecipeCardList),
                      )
                  ),
                )
              ],
            ),
          ),

    );
  }
}
