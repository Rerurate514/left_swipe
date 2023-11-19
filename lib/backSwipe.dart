import 'package:flutter/material.dart';

class BackSwipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BackSwipePageState();
}

class BackSwipePageState extends State<BackSwipePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Icon(
      Icons.heart_broken,
      size: 200,
      color: Colors.purple,
    )));
  }
}
