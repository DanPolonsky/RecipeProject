import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/recipe_page/recipe_page_provider.dart';
import 'package:provider/provider.dart';

import '../waiting_page.dart';
import 'local_recipes_provider.dart';

class LocalRecipesPage extends StatefulWidget {
  @override
  _LocalRecipesPageState createState() => _LocalRecipesPageState();
}

class _LocalRecipesPageState extends State<LocalRecipesPage> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provider = Provider.of<LocalRecipesProvider>(context, listen: false);
      provider.getSavedRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalRecipesProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          title: Text("Testing App"),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                provider.reset();
                Navigator.of(context).pop();
              }),
        ),
        body: Stack(children: [
          provider.loadedRecipes ? RecipeCardList() : RecipesWaitingPage()
        ]),
      ),
    );
  }
}

class RecipeCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalRecipesProvider>(
      builder: (context, provider, child) => Container(
          child: SingleChildScrollView(
        child: Column(children: provider.localRecipes),
      )),
    );
  }
}
