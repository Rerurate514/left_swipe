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
      child: Icon(Icons.favorite,size: 200, color: Colors.pink,)
    ));
  }
}
