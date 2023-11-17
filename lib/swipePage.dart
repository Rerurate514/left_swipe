 import 'package:flutter/material.dart';


class SwipePage extends StatelessWidget {
  int _colorSeed = 0;

  SwipePage(this._colorSeed);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
        width: 300,
        height: 550,
        color: Color.fromRGBO(
          (_colorSeed * 100) % 255, 
          (_colorSeed + 100) % 255,
          (_colorSeed * 100 + 150) % 255,
          1),
      ),
      )
    );
  }
}
