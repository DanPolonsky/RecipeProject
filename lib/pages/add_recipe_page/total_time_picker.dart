import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/add_recipe_page/add_recipe_page_provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class TotalTimePicker extends StatefulWidget {
  @override
  _TotalTimePickerState createState() => _TotalTimePickerState();
}

class _TotalTimePickerState extends State<TotalTimePicker> {
  int currentHoursValue = 0;
  int currentMinutesValue = 0;
  final int _minHours = 0;
  final int _maxHours = 99;

  final int _minMinutes = 0;
  final int _maxMinutes = 55;

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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("Hours"),
                                      NumberPicker(
                                        value: currentHoursValue,
                                        minValue: _minHours,
                                        maxValue: _maxHours,
                                        onChanged: (value) {
                                          setState(() {
                                            currentHoursValue = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(":"),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("Minutes"),
                                      NumberPicker(
                                        step: 5,
                                        value: currentMinutesValue,
                                        minValue: _minMinutes,
                                        maxValue: _maxMinutes,
                                        onChanged: (value) {
                                          setState(() {
                                            currentMinutesValue = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          actions: [
                            MaterialButton(
                              child: Text("Ok"),
                              onPressed: () {
                                provider.totalCookTimeHours = currentHoursValue;
                                provider.totalCookTimeMinutes =
                                    currentMinutesValue;
                                Navigator.of(context).pop();
                                provider.notify();
                              },
                            )
                          ],
                        );
                      });
                },
                child: Text(
                    "${provider.totalCookTimeHours}hr ${provider.totalCookTimeMinutes}mins"),
              ),
            ));
  }
}
