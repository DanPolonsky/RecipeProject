import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../functions.dart';

class AddRecipePageProvider extends ChangeNotifier {
  // form key for submitting all data
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  // defining textControllers and textFields
  TextEditingController _recipeNameController = TextEditingController();

  TextEditingController get recipeNameController => _recipeNameController;

  List<TextEditingController> _ingredientControllers = [];

  List<TextEditingController> get ingredientControllers =>
      _ingredientControllers;
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

  bool _closeAddRecipePage = false;
  bool get closeAddRecipePage => _closeAddRecipePage;

  String _pressedDifficulty;
  String get pressedDifficulty => _pressedDifficulty;

  set pressedDifficulty(String difficulty) {
    _pressedDifficulty = difficulty;
    notifyListeners();
  }

  String _defaultDropDownMenuValue = "No category";
  String get defaultDropDownMenuValue => _defaultDropDownMenuValue;

  List<String> _pressedCategories = ["", ""];
  List<String> get pressedCategories => _pressedCategories;

  int totalCookTimeHours = 0;
  int totalCookTimeMinutes = 0;

  int cookTimeHours = 0;
  int cookTimeMinutes = 0;

  void notify() {
    notifyListeners();
  }

  void onPressedCategory(String newValue, int index) {
    _pressedCategories[index] = newValue;
    notifyListeners();
  }

  /// Function resets page when user leaves page or submits recipe
  void resetParameters() {
    _recipeNameController.text = "";
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
    initializeLists();
  }

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

  // TODO: add diposing
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

  void sendRecipePost() {
    if (_formKey.currentState.validate() && _image != null) {
      print("sending recipe");

      String recipeName = _recipeNameController.text;
      List<String> ingredients = [];
      List<String> steps = [];
      String categories = "popular,";

      String difficulty = _pressedDifficulty;
      String cookTimeHoursString = "$cookTimeHours hr";
      String cookTimeMinutesString = "$cookTimeMinutes mins";
      String cookTime =
          "${cookTimeHours == 0 ? "" : cookTimeHoursString} ${cookTimeMinutes == 0 ? "" : cookTimeMinutesString}";

      String totalTimeHoursString = "$totalCookTimeHours hr";
      String totalTimeMinutesString = "$totalCookTimeMinutes mins";
      String totalTime =
          "${totalCookTimeHours == 0 ? "" : totalTimeHoursString} ${totalCookTimeMinutes == 0 ? "" : totalTimeMinutesString}";

      String servings = "10";
      String description = "this is a recipe description";

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
          ingredients,
          steps,
          _image.readAsBytesSync(),
          difficulty,
          cookTime,
          totalTime,
          servings,
          description,
          categories,
          _imageType);

      _closeAddRecipePage = true;
    }
  }

  void initializeLists() {
    addStepTextFormField(false);
    addIngredientTextFormField(false);
  }
}
