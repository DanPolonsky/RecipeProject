import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/classes/recipe_list_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../main.dart';

//TODO: make waiting pages stateless

class WaitingPage extends StatefulWidget {
  @override
  _WaitingPageState createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {

  void getRecipeJson() async{
    var recipeListProvider =
        Provider.of<CategoryRecipeListProvider>(context, listen: false);
    await recipeListProvider.initializeNewCategory("popular");
    Navigator.pushReplacement(
      context, CupertinoPageRoute(
      builder: (context) => Home(),
    ),);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getRecipeJson();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
          child: SpinKitWave(
            color: Colors.green,
            size: 50.0,
          ),
        )
    );
  }
}


class SearchWaitingPage extends StatefulWidget {
  @override
  _SearchWaitingPageState createState() => _SearchWaitingPageState();
}

class _SearchWaitingPageState extends State<SearchWaitingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
          child: Text("Waiting!"),
        )
    );
  }
}

