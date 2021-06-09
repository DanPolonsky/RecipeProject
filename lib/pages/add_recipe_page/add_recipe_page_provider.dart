import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../functions.dart';

/// A logic class handling all functionality of add recipe page
class AddRecipePageProvider extends ChangeNotifier {
  GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // form key for submitting all data
  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController _recipeNameController = TextEditingController();
  TextEditingController get recipeNameController => _recipeNameController;

  TextEditingController _recipeDescriptionController = TextEditingController();
  TextEditingController get recipeDescriptionController =>
      _recipeDescriptionController;

  List<TextEditingController> _ingredientControllers =
      []; // List of all ingredient text field controllers
  List<TextEditingController> get ingredientControllers =>
      _ingredientControllers;

  List<Widget> _ingredientTextFormFields =
      []; // List of all ingredient text fields
  List<Widget> get ingredientTextFormFields => _ingredientTextFormFields;

  List<TextEditingController> _stepControllers =
      []; // List of all step text field controllers
  List<TextEditingController> get stepControllers => _stepControllers;

  List<Widget> _stepTextFormFields = []; // List of all step text fields

  List<Widget> get stepTextFormFields => _stepTextFormFields;

  File _image; // Recipe image file
  File get image => _image;

  String _imageType; // String representing the type of image, jpg, png ...
  final _picker = ImagePicker(); // Object for picking images from the gallery

  bool _closeAddRecipePage =
      false; // Variable representing if all fields are complete
  bool get closeAddRecipePage => _closeAddRecipePage;

  String _pressedDifficulty; // The recipe difficulty
  String get pressedDifficulty => _pressedDifficulty;

  set pressedDifficulty(String difficulty) {
    _pressedDifficulty = difficulty;
    notifyListeners();
  }

  String _defaultDropDownMenuValue = "No category";
  String get defaultDropDownMenuValue => _defaultDropDownMenuValue;

  List<String> _pressedCategories = [
    "",
    ""
  ]; // List containing the categories the recipe is associated with
  List<String> get pressedCategories => _pressedCategories;

  int totalCookTimeHours = 0;
  int totalCookTimeMinutes = 0;

  int cookTimeHours = 0;
  int cookTimeMinutes = 0;

  int mealsAmount = 0;

  void notify() {
    notifyListeners();
  }

  /// Function gets new category [newValue] pressed by the user, changes the list in [index] to the new category
  void onPressedCategory(String newValue, int index) {
    _pressedCategories[index] = newValue;
    notifyListeners();
  }

  /// Function resets page when user leaves page or submits recipe
  void resetParameters() {
    _recipeNameController.text = "";
    _recipeDescriptionController.text = "";
    _ingredientControllers = [];
    _ingredientTextFormFields = [];
    _stepControllers = [];
    _stepTextFormFields = [];
    _pressedDifficulty = "";
    _image = null;
    _pressedCategories = ["", ""];
    _closeAddRecipePage = false;
    totalCookTimeHours = 0;
    totalCookTimeMinutes = 0;
    cookTimeHours = 0;
    cookTimeMinutes = 0;
    mealsAmount = 0;
  }

  /// Function opens image picking dialog
  void getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    // final bytes = await pickedFile.readAsBytes();
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _imageType = pickedFile.path.split(".").last;
    } else {
      print('No image selected.');
    }
  }

  /// Function adds ingredient text form field to the list, the function will reload the page if [notify] is true
  void addIngredientTextFormField(bool notify) {
    final ingredientController = TextEditingController();
    FocusNode focusNode = FocusNode();

    _ingredientControllers.add(ingredientController);

    _ingredientTextFormFields.add(createTextFormField("Enter ingredient...",
        'Please enter ingredient.', focusNode, ingredientController));

    if (notify) {
      focusNode.requestFocus();
      notifyListeners();
    }
  }

  /// Function adds step text form field to the list
  void addStepTextFormField(bool notify) {
    final stepController = TextEditingController();
    FocusNode focusNode = FocusNode();

    _stepControllers.add(stepController);
    _stepTextFormFields.add(createTextFormField('Enter step of making...',
        'Please enter step of making.', focusNode, stepController));

    if (notify) {
      focusNode.requestFocus();
      notifyListeners();
    }
  }

  /// Function create a new text form field based on [hintText] and [emptyStringErrorMsg]
  Widget createTextFormField(String hintText, String emptyStringErrorMsg,
      FocusNode focusNode, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          isDense: true,
          contentPadding: EdgeInsets.all(12),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return emptyStringErrorMsg;
          }
          return null;
        },
      ),
    );
  }

  /// Function sends post request to the server with the recipe info the user provided
  /// Function checks if all fields are complete
  void sendRecipePost() {
    if (_formKey.currentState.validate() && _image != null) {
      print("sending recipe");

      String recipeName = _recipeNameController.text;
      String recipeDescription = _recipeDescriptionController.text;
      List<String> ingredients = [];
      List<String> steps = [];
      String categories = "";

      String difficulty = _pressedDifficulty;
      String cookTimeHoursString = "$cookTimeHours hr";
      String cookTimeMinutesString = "$cookTimeMinutes mins";
      String cookTime =
          "${cookTimeHours == 0 ? "" : cookTimeHoursString} ${cookTimeMinutes == 0 ? "" : cookTimeMinutesString}";

      String totalTimeHoursString = "$totalCookTimeHours hr";
      String totalTimeMinutesString = "$totalCookTimeMinutes mins";
      String totalTime =
          "${totalCookTimeHours == 0 ? "" : totalTimeHoursString} ${totalCookTimeMinutes == 0 ? "" : totalTimeMinutesString}";

      _ingredientControllers.forEach((controller) {
        ingredients.add(controller.text);
      });

      int index = 1;
      _stepControllers.forEach((controller) {
        steps.add(index.toString() + ". " + controller.text);
        index++;
      });

      if (pressedCategories[0] != "" &&
          pressedCategories[0] != _defaultDropDownMenuValue) {
        categories += pressedCategories[0] + ",";
      }

      if (pressedCategories[1] != "" &&
          pressedCategories[1] != _defaultDropDownMenuValue) {
        categories += pressedCategories[1] + ",";
      }

      print(ingredients);
      sendNewRecipePost(
          recipeName,
          recipeDescription,
          ingredients,
          steps,
          _image.readAsBytesSync(),
          difficulty,
          cookTime,
          totalTime,
          mealsAmount.toString(),
          categories,
          _imageType);

      _closeAddRecipePage = true;
    }
  }

  /// Function adds the first ingredient and step text fields
  void initializeLists() {
    addStepTextFormField(false);
    addIngredientTextFormField(false);
  }
}
