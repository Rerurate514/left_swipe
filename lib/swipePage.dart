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
            child: Expanded(
      child: Container(
        width: 1000,
        height: 500,
        color: Colors.blue,
        child: const Text("lets swipe"),
      ),
    )));
  }
}
