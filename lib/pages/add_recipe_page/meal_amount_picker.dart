import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/add_recipe_page/add_recipe_page_provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MealAmountPick extends StatelessWidget {
  int _currentMealAmount = 0;
  int _minMealsAmount = 0;
  int _maxMealsAmount = 99;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddRecipePageProvider>(
        builder: (BuildContext context, provider, Widget child) => Container(
              margin: EdgeInsets.all(10),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.blue,
                        width: 1,
                        style: BorderStyle.solid)),
                onPressed: () {
                  FocusScope.of(context)
                      .unfocus(disposition: UnfocusDisposition.scope);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Meals"),
                                  NumberPicker(
                                    value: _currentMealAmount,
                                    minValue: _minMealsAmount,
                                    maxValue: _maxMealsAmount,
                                    onChanged: (value) {
                                      setState(() {
                                        _currentMealAmount = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                          actions: [
                            MaterialButton(
                              child: Text("Ok"),
                              onPressed: () {
                                provider.mealsAmount = _currentMealAmount;

                                Navigator.of(context).pop();
                                provider.notify();
                              },
                            )
                          ],
                        );
                      });
                },
                child: Text("${provider.mealsAmount} meals"),
              ),
            ));
  }
}
