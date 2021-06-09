// ignore: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../global_variables.dart';
import 'add_recipe_page_provider.dart';

// ignore: must_be_immutable
class DropDownCategoryMenu extends StatefulWidget {
  int _dropDownMenuIndex;

  DropDownCategoryMenu(int index) {
    _dropDownMenuIndex = index;
  }

  @override
  _DropDownCategoryMenuState createState() => _DropDownCategoryMenuState();
}

class _DropDownCategoryMenuState extends State<DropDownCategoryMenu> {
  String firstValue = "No category";

  List<String> viewCategories;

  void initializeCategoryList(BuildContext context) {
    viewCategories = List.from(Constants.addingRecipeCategories);
    viewCategories.remove("Popular");

    var addRecipeProvider =
        Provider.of<AddRecipePageProvider>(context, listen: false);

    // Deleting already pressed cateogries from both drop down menus
    viewCategories.remove(
        addRecipeProvider.pressedCategories[1 - widget._dropDownMenuIndex]);

    viewCategories.insert(0, addRecipeProvider.defaultDropDownMenuValue);
    print("${widget._dropDownMenuIndex} $viewCategories");
  }

  @override
  Widget build(BuildContext context) {
    initializeCategoryList(context);
    print("value = $firstValue");
    return Consumer<AddRecipePageProvider>(
        builder: (BuildContext context, provider, Widget child) =>
            DropdownButton<String>(
              value: firstValue,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.blue),
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onTap: () {
                FocusScope.of(context)
                    .unfocus(disposition: UnfocusDisposition.scope);
              },
              onChanged: (newValue) {
                firstValue = newValue;

                provider.onPressedCategory(newValue, widget._dropDownMenuIndex);
              },
              items: viewCategories.map<DropdownMenuItem<String>>((String str) {
                return DropdownMenuItem<String>(
                  value: str,
                  child: Text(str),
                );
              }).toList(),
            ));
  }
}
