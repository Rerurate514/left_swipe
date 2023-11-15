import 'package:flutter/material.dart';

class ToSwipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ToSwipePageState();
}

class ToSwipePageState extends State<ToSwipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Expanded(
      child: Container(
        width: 1000,
        height: 500,
        color: Colors.red,
        child: const Text("swiped"),
      ),
    )));
  }
}
