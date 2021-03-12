import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReachedBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
