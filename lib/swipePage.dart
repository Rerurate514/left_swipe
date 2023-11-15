import 'package:flutter/material.dart';

class SwipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SwipePageState();
}

class SwipePageState extends State<SwipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: 300,
        height: 550,
        color: Colors.blue,
      ),
    ));
  }
}
