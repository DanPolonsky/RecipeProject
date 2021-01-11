import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../functions.dart';

class AddRecipePage extends StatefulWidget {
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}


class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();

  final _recipeNameController = TextEditingController();

  List<TextEditingController> _ingredientControllers = [];
  List<Widget> _ingredientTextFormFields = [];


  List<TextEditingController> _stepControllers = [];
  List<Widget> _stepTextFormFields = [];

  File _image;
  final _picker = ImagePicker();

  //Todo: move all logic to provider
  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    // final bytes = await pickedFile.readAsBytes();
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }



  void addIngredientTextFromField(){
    final recipeIngredientController = TextEditingController();
    _ingredientControllers.add(recipeIngredientController);

    _ingredientTextFormFields.add(Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: TextFormField(
        controller: recipeIngredientController,
        autofocus: true,
        decoration: InputDecoration(
            labelText: "ingredient:",
            hintText: 'Enter ingredient...'
        ),

        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter ingredient.';
          }
          return null;
        },
      ),
    ));

  }


  void addStepTextFromField(){
    final stepIngredientController = TextEditingController();
    _stepControllers.add(stepIngredientController);
    _stepTextFormFields.add(Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: TextFormField(

        controller: stepIngredientController,
        autofocus: true,
        decoration: InputDecoration(
            labelText: "step of making:",
            hintText: 'Enter step of making...'
        ),

        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter step of making.';
          }
          return null;
        },
      ),
    ));

  }

  void initState(){
    super.initState();
    addIngredientTextFromField();
    addStepTextFromField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add recipe page"),
        centerTitle: true,
      ),
      body:Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Recipe Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                    )
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: TextFormField(
                    controller: _recipeNameController,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "Recipe name",
                        hintText: 'Enter Recipe Name...'
                    ),

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter recipe name.';
                      }
                      return null;
                    },
                  ),
                ),

                Text(
                    "Ingredients",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                    )
                ),

                Column(
                  children: _ingredientTextFormFields
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: ElevatedButton(
                    onPressed:(){
                      setState(() {
                        addIngredientTextFromField();
                      });
                    },
                    child: Text("Add ingredient"),
                  ),
                ),

                Text(
                  "steps",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                    )
                ),
                Column(
                    children: _stepTextFormFields
                ),

                ElevatedButton(
                  onPressed:(){
                    setState(() {
                      addStepTextFromField();
                    });
                  },
                  child: Text("Add step"),
                ),

                ElevatedButton(
                    onPressed: () async{
                      if(_formKey.currentState.validate() && _image != null){
                        print("got input");
                        print("got image");
                        Uint8List imageBytes = await _image.readAsBytes();

                        sendNewRecipePost();



//                        print(_recipeNameController.text);
//
//                        _ingredientControllers.forEach((controller) {
//                          print(controller.text);
//                        });
//
//                        _stepControllers.forEach((controller) {
//                          print(controller.text);
//                        });

                      }
                    },
                    child: Text("Submit Recipe")
                ),
                FloatingActionButton(

                  onPressed: getImage,
                  tooltip: 'Pick Image',
                  child: Icon(Icons.add_a_photo),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}


