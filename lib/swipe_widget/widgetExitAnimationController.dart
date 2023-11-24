import './easeInOutAnimationGenerator.dart';
import 'package:flutter/material.dart';

class WidgetExitAnimationController {
  late final DragEndDetails _dragEndDetails;
  late final SwipeDirectionBuffer _swipeDirectionBuffer;
  late final double _angle;
  late final double _currentPosX;

  late final EaseInOutAnimationGenerator _rightPosInitializer = EaseInOutAnimationGenerator(2000, 1, 128);
  late final EaseInOutAnimationGenerator _leftPosInitializer = EaseInOutAnimationGenerator(-2000, 1, 128);
  late final EaseInOutAnimationGenerator _angleInitializer = EaseInOutAnimationGenerator(_angle * 10, 2, 128);

  WidgetExitAnimationController(this._dragEndDetails, this._angle, this._currentPosX){
    _swipeDirectionBuffer = SwipeDirectionBuffer(_dragEndDetails);

  }
  
  List<Stream> generateExitAnimationIterable(){
    List<Stream> resultIterable = [];

    if(_swipeDirectionBuffer.direction == SwipeDirection.RIGHT){
      Stream rightStream = _rightPosInitializer.doEaseInOutStream(_currentPosX);
      resultIterable.add(rightStream);
    }
    else if(_swipeDirectionBuffer.direction == SwipeDirection.LEFT){
      Stream leftStream = _leftPosInitializer.doEaseInOutStream(_currentPosX);
      resultIterable.add(leftStream);
    }

    Stream angleStream = _angleInitializer.doEaseInOutStream(_angle);
    resultIterable.add(angleStream);

    return resultIterable;
  }
}

class SwipeDirectionBuffer{
  late final SwipeDirection _swipeDirection;
  SwipeDirection get direction => _swipeDirection;

  SwipeDirectionBuffer(DragEndDetails dragEndDetailsArg) {
    _swipeDirection = _judgeSwipeDirection(dragEndDetailsArg);
  }

  SwipeDirection _judgeSwipeDirection(DragEndDetails details) {
    double velocityX = details.velocity.pixelsPerSecond.dx;

    if (velocityX == 0) {
      return SwipeDirection.IDOL;
    } else {
      return velocityX < 0 ? SwipeDirection.LEFT : SwipeDirection.RIGHT;
    }
  }
}

enum SwipeDirection { IDOL, RIGHT, LEFT }


