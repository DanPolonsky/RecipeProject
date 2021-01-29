import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/add_recipe_page_provider.dart';

import 'package:provider/provider.dart';

class AddRecipePage extends StatefulWidget {
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {

  void initState(){
    super.initState();
    var provider = Provider.of<AddRecipePageProvider>(context, listen: false);
    provider.initializeLists();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<AddRecipePageProvider>(
      builder: (BuildContext context, provider, Widget child) => Scaffold(
          appBar: AppBar(
            title: Text("add recipe page"),
            centerTitle: true,
          ),
          body: Form(
            key: provider.formKey,
            child: Container(
              margin: EdgeInsets.all(10),
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
                          autofocus: true,
                          decoration: InputDecoration(
                              labelText: "Recipe name",
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
                      Text("steps",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)),
                      Column(children: provider.stepTextFormFields),
                      ElevatedButton(
                        onPressed: () {
                            provider.addStepTextFormField(true);
                        },
                        child: Text("Add step"),
                      ),

                      ElevatedButton(
                          onPressed: () async {
                            provider.sendRecipePost();
                            if(provider.closeAddRecipePage){
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
              ),
            ),
          )),
    );
  }
}
