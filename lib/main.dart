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

    late PageController _swipePageController;
  int _selectSwipePageIndex = 1;
  final List<Widget> _swipePages = [BackSwipePage(),SwipePage(), ToSwipePage()];

  // List<Widget> _swipePagesList= [_SwipePages()];
  // late PageController _pageController;
  // int _selectPageIndex = 0;

  @override
  void initState() {
    super.initState();
    //_pageController = PageController(initialPage: _selectPageIndex);
    _swipePageController = PageController(initialPage: _selectSwipePageIndex);
    //_swipePagesList = List.generate(15, (index) => _SwipePages());
  }

  // void _onPageChanged(int indexArg) {
  //   setState(() {
  //     _selectPageIndex = indexArg;
  //     _pageController.animateToPage(
  //       indexArg,
  //       duration: const Duration(milliseconds: 500),
  //       curve: Curves.decelerate,
  //     );
  //   });
  // }
    void _onPageChanged(int indexArg) {
    setState(() {
      _selectSwipePageIndex = indexArg;
      _swipePageController.animateToPage(
        indexArg,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    });
  }
// PageView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: _swipePagesList.length,
//         itemBuilder: (BuildContext context, int indexArg){
//           return _swipePagesList[indexArg];
//         },
//         onPageChanged: _onPageChanged,
//       ),



  @override
  Widget build(BuildContext context){
    return PageView(
      controller: _swipePageController,
      onPageChanged: _onPageChanged,
      children: _swipePages,
    );
  }
}

// class _SwipePages extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() => _SwipePagesState();
// }

// class _SwipePagesState extends State<_SwipePages>{
//   late PageController _swipePageController;
//   int _selectSwipePageIndex = 1;
//   final List<Widget> _swipePages = [BackSwipePage(),SwipePage(), ToSwipePage()];

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _swipePageController = PageController(initialPage: _selectSwipePageIndex);
//   }
  
//   void _onPageChanged(int indexArg) {
//     setState(() {
//       _selectSwipePageIndex = indexArg;
//       _swipePageController.animateToPage(
//         indexArg,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.decelerate,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context ){
//     return PageView(
//       controller: _swipePageController,
//       onPageChanged: _onPageChanged,
//       children: _swipePages,
//     );
//   }
// }