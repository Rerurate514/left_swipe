import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:left_swipe/swipePage.dart';
import 'package:left_swipe/toSwipedPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  int _selectPageIndex = 0;

  List<Widget> _pages = [SwipePage(), ToSwipePage()];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectPageIndex);
  }

  void _onPageChanged(int indexArg) {
    setState(() {
      _selectPageIndex = indexArg;
      _pageController.animateToPage(
        indexArg,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    });
  }

  double _currentPositionX = 0;
  double _currentPositionY = 0;

  double x = 0;
  double y = 0;

  double boxSize = 500.0;

  String _direction = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: Text(
            "x = ${_currentPositionX.toInt()}\ny = ${_currentPositionY.toInt()}",
            style: TextStyle(fontSize: 40),
          ),
        ),
        Center(
            child: Container(
          width: boxSize,
          height: boxSize,
          color: const Color.fromARGB(
            100,
            100,
            100,
            100,
          ),
          child: GestureDetector(
            onPanUpdate: (details) => {
              x = details.localPosition.dx,
              y = details.localPosition.dy,

              setState(() {
                if(x > 0 && x < boxSize) {
                  _currentPositionX = x;
                }
                else if(x < 0){
                  _currentPositionX = 0;
                }
                else{
                  _currentPositionX = boxSize;
                }

                if(y > 0 && y < boxSize) {
                  _currentPositionY = y;
                }
                else if(y < 0){
                  _currentPositionY = 0;
                }
                else{
                  _currentPositionY = boxSize;
                }

              })
            },
          ),
        )),
      ],
    ));
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
