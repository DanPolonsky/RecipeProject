import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../functions.dart';

class AddRecipePageProvider extends ChangeNotifier{
   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   GlobalKey<FormState> get formKey => _formKey;

  TextEditingController _recipeNameController = TextEditingController();
  TextEditingController get recipeNameController => _recipeNameController;

  List<TextEditingController> _ingredientControllers = [];
  List<TextEditingController> get ingredientControllers => _ingredientControllers;
  List<Widget> _ingredientTextFormFields = [];
  List<Widget> get ingredientTextFormFields => _ingredientTextFormFields;

  List<TextEditingController> _stepControllers = [];
  List<TextEditingController> get stepControllers => _stepControllers;
  List<Widget> _stepTextFormFields = [];
  List<Widget> get stepTextFormFields => _stepTextFormFields;

  File _image;
  File get image => _image;

  String _imageType;

  final _picker = ImagePicker();


  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    // final bytes = await pickedFile.readAsBytes();
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageType = pickedFile.path.split(".").last;
      } else {
        print('No image selected.');
      }

  }

  void addIngredientTextFromField(bool notify){
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
    if(notify) {
      notifyListeners();
    }
  }


  void addStepTextFromField(bool notify){
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
    if(notify) {
      notifyListeners();
    }
  }


   void sendRecipePost() {
     if (_formKey.currentState.validate() &&
         _image != null) {
       print("sending recipe");


       String reciepName = _recipeNameController.text;
       String ingredients = "";
       String steps = "";

       String difficulty = "easy";
       String cookTime = "4 hours";


       int index = 1;
       _ingredientControllers.forEach((controller) {
         ingredients += index.toString() + ". " + controller.text + "\n";
         index++;
       });

       index = 1;
       _stepControllers.forEach((controller) {
         steps += index.toString() + ". " + controller.text + "\n";
         index++;
       });

       sendNewRecipePost(reciepName, ingredients, steps,
           _image.readAsBytesSync(), difficulty, cookTime, _imageType);
     }
   }

   void initializeLists(){
    addIngredientTextFromField(false);
    addStepTextFromField(false);
   }



}



