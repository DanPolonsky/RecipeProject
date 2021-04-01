import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:provider/provider.dart';

import 'add_recipe_page_provider.dart';

class AddRecipePage extends StatelessWidget {
    Widget build(BuildContext context) {
        return Consumer<AddRecipePageProvider>(
            builder: (BuildContext context, provider, Widget child) =>
                Scaffold(
                    appBar: AppBar(
                        title: Text("add recipe page"),
                        centerTitle: true,
                        leading: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: (){
                                provider.resetParameters();
                                Navigator.pop(context);
                            },
                        ),
                    ),
                    body: Form(
                        key: provider.formKey,
                        child: Container(
                            margin: EdgeInsets.all(10),

                            child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text("Recipe Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 30)),
                                        Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                                            child: TextFormField(
                                                controller: provider.recipeNameController,

                                                decoration: InputDecoration(
                                                    hintText: 'Enter Recipe Name...'),
                                                validator: (value) {
                                                    if (value.isEmpty) {
                                                        return 'Please enter recipe name.';
                                                    }
                                                    return null;
                                                },
                                            ),
                                        ),
                                        Text("Ingredients",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 30
                                            )
                                        ),
                                        Column(children: provider.ingredientTextFormFields),

                                        Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                    provider.addIngredientTextFormField(true);
                                                },
                                                child: Text("Add ingredient"),
                                            ),
                                        ),

                                        Text("Steps",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 30)
                                        ),
                                        Column(children: provider.stepTextFormFields),

                                        ElevatedButton(
                                            onPressed: () {
                                                provider.addStepTextFormField(true);
                                            },
                                            child: Text("Add step"),
                                        ),


                                        RowOfDifficulties(),

                                        ElevatedButton(
                                            onPressed: () async {
                                                print("pressed submit");
                                                provider.sendRecipePost();
                                                if (provider.closeAddRecipePage) {
                                                    Navigator.pop(context);
                                                }
                                            },
                                            child: Text("Submit Recipe")
                                        ),

                                        FloatingActionButton(
                                            onPressed: provider.getImage,
                                            tooltip: 'Pick Image',
                                            child: Icon(Icons.add_a_photo),
                                        )
                                    ],
                                ),
                            ),
                        ),)
                )
            ,
        );
    }
}


class RowOfDifficulties extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Consumer<AddRecipePageProvider>(
            builder: (BuildContext context, provider, Widget child) =>
                Container(
                    margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                            FlatButton(
                                onPressed: () {
                                    provider.pressedDifficulty = "easy";
                                },
                                padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: provider
                                        .pressedDifficulty == "easy" ? Colors.black12 : Colors
                                        .white, width: 3)
                                ),
                                color: Colors.green[600],
                                child: Text(
                                    "easy",
                                    style: TextStyle(fontSize: 20),
                                )
                            ),
                            FlatButton(
                                onPressed: () {
                                    provider.pressedDifficulty = "medium";
                                },
                                padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: provider
                                        .pressedDifficulty == "medium" ? Colors.black12 : Colors
                                        .white
                                        , width: 3
                                    )
                                ),
                                color: Colors.yellowAccent,
                                child: Text(
                                    "medium",
                                    style: TextStyle(fontSize: 20),
                                )
                            ),
                            FlatButton(
                                onPressed: () {
                                    provider.pressedDifficulty = "hard";
                                },
                                padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: provider
                                        .pressedDifficulty == "hard" ? Colors.black12 : Colors
                                        .white
                                        , width: 3)
                                ),
                                color: Colors.red,
                                child: Text(
                                    "hard",
                                    style: TextStyle(fontSize: 20),
                                )
                            )
                        ],
                    ),
                ),
        );
    }
}
