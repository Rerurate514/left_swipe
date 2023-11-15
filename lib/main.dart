import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:left_swipe/backSwipe.dart';
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

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectPageIndex);
    _pages = List.generate(15, (index) => _SwipeView(_onPageChanged));
  } 

  void _onPageChanged() {
    setState(() {
      _selectPageIndex++;
      if(_selectPageIndex >= _pages.length) _selectPageIndex = 0;
    });

Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        _pages[_selectPageIndex],
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      var opacityTween = Tween<double>(begin: begin, end: end);
      var opacityAnimation = opacityTween.animate(animation);

      return Opacity(
        opacity: opacityAnimation.value,
        child: ScaleTransition(
          child: child,
          scale: animation,
        ),
      );
    },
  ),
);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _SwipeView(_onPageChanged),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: PageView.builder(
  //         scrollDirection: Axis.vertical,
  //         controller: _pageController,
  //         itemCount: _pages.length,
  //         itemBuilder: (BuildContext context, int indexArg) {
  //           return _pages[indexArg];
  //         }),
  //   );
  // }
}

class _SwipeView extends StatefulWidget {
  late Function onChangedCallback;

  _SwipeView(this.onChangedCallback);

  @override
  State<StatefulWidget> createState() => _SwipeViewState(onChangedCallback);
}

class _SwipeViewState extends State<_SwipeView> {
  late AnimationController _animationController;
  late PageController _pageController;
  int _selectPageIndex = 1;

  final Function _onChangedCallback;

  _SwipeViewState(this._onChangedCallback);

  final List<Widget> _pages = [BackSwipePage(), SwipePage(), ToSwipePage()];

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
        curve: Curves.easeOutSine,
      );
    });
    _onChangedCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      children: _pages,
    ),
    );
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
