import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/add_recipe_page/cook_time_picker.dart';
import 'package:flutter_app/pages/add_recipe_page/meal_amount_picker.dart';
import 'package:flutter_app/pages/add_recipe_page/total_time_picker.dart';

import 'package:provider/provider.dart';

import 'add_recipe_page_provider.dart';
import 'cook_time_picker.dart';
import 'drop_down_menu.dart';

class AddRecipePage extends StatelessWidget {
  void initialize(BuildContext context) {
    var addRecipePageProvider =
        Provider.of<AddRecipePageProvider>(context, listen: false);
    addRecipePageProvider.initializeLists();
  }

  Widget build(BuildContext context) {
    initialize(context);
    return Consumer<AddRecipePageProvider>(
      builder: (BuildContext context, provider, Widget child) => Scaffold(
          appBar: AppBar(
            title: Text("Add Recipe Page"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
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
                          hintText: "Enter Recipe Name ...",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          isDense: true,
                          contentPadding: EdgeInsets.all(12),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter recipe name.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Text("Recipe Description",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: TextFormField(
                        controller: provider.recipeDescriptionController,
                        decoration: InputDecoration(
                          hintText: "Enter Recipe Description ...",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          isDense: true,
                          contentPadding: EdgeInsets.all(12),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter recipe description.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Text("Ingredients",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    Column(children: provider.ingredientTextFormFields),
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context)
                              .unfocus(disposition: UnfocusDisposition.scope);
                          provider.addIngredientTextFormField(true);
                        },
                        child: Text("Add ingredient"),
                      ),
                    ),
                    Text("Steps",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    Column(children: provider.stepTextFormFields),
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context)
                              .unfocus(disposition: UnfocusDisposition.scope);
                          provider.addStepTextFormField(true);
                        },
                        child: Text("Add step"),
                      ),
                    ),
                    Text("Difficulty",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    RowOfDifficulties(),
                    Text("Categories",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 7, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DropDownCategoryMenu(0),
                          DropDownCategoryMenu(1),
                        ],
                      ),
                    ),
                    Text("Total Time",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    Container(
                        alignment: Alignment.center, child: TotalTimePicker()),
                    Text("Cook Time",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    Container(
                        alignment: Alignment.center, child: CookTimePicker()),
                    Text("Meals Amount",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    Container(
                        alignment: Alignment.center, child: MealAmountPick()),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 2),
                      alignment: Alignment.center,
                      child: FlatButton(
                        onPressed: (){
                          provider.getImage;
                        },
                        padding: EdgeInsets.fromLTRB(42, 0, 42, 0),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.blue,
                                width: 1,
                                style: BorderStyle.solid)),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                style: TextStyle(color: Colors.black),
                                text: "Click ",
                              ),
                              WidgetSpan(
                                child: Icon(Icons.add_a_photo, size: 20),
                              ),
                              TextSpan(
                                style: TextStyle(color: Colors.black),
                                text: " to add a picture",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    provider.image == null
                        ? Container(
                            alignment: Alignment.center,
                            child: Text("No image is selected"),
                            margin: EdgeInsets.only(bottom: 10),
                          )
                        : Container(),
                    ElevatedButton(
                        onPressed: () {
                          print("pressed submit");
                          provider.sendRecipePost();
                          if (provider.closeAddRecipePage) {
                            provider.resetParameters();
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Submit Recipe")),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class RowOfDifficulties extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddRecipePageProvider>(
      builder: (BuildContext context, provider, Widget child) => Container(
        margin: EdgeInsets.fromLTRB(0, 7, 0, 30),
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
                    side: BorderSide(
                        color: provider.pressedDifficulty == "easy"
                            ? Colors.black45
                            : Colors.transparent,
                        width: 3)),
                color: Colors.green[600],
                child: Text(
                  "easy",
                  style: TextStyle(fontSize: 20),
                )),
            FlatButton(
                onPressed: () {
                  provider.pressedDifficulty = "medium";
                },
                padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                        color: provider.pressedDifficulty == "medium"
                            ? Colors.black45
                            : Colors.transparent,
                        width: 3)),
                color: Colors.yellowAccent,
                child: Text(
                  "medium",
                  style: TextStyle(fontSize: 20),
                )),
            FlatButton(
                onPressed: () {
                  provider.pressedDifficulty = "hard";
                },
                padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                        color: provider.pressedDifficulty == "hard"
                            ? Colors.black45
                            : Colors.transparent,
                        width: 3)),
                color: Colors.red,
                child: Text(
                  "hard",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
