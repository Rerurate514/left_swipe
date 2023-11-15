import 'package:flutter/material.dart';

class BackSwipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BackSwipePageState();
}

class BackSwipePageState extends State<BackSwipePage> {
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
        body: Center(
            child: Container(
        width: 1000,
        height: 500,
        color: Colors.green,
        child: const Text("lets swipe"),
      ),
    ));
  }
}
