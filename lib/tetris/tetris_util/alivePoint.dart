import 'package:bundle_of_simple_game/tetris/tetris_util/point.dart';
import 'package:flutter/material.dart';

class AlivePoint extends Point {
  Color color;
  AlivePoint(int x, int y, this.color) : super(x, y);

  bool checkIfPointsCollide(List<Point> pointList){
    bool retVal = false;
    pointList.forEach((element) {
      if(element.x == x && element.y == y-1){
        retVal = true;
      }
    });
    return retVal;
  }

  bool checkIfPointsCollideleft(List<Point> pointList){
    bool retVal = false;
    pointList.forEach((element) {
      if(element.x == x-1 && element.y == y){
        retVal = true;
      }
    });
    return retVal;
  }

  bool checkIfPointsCollideright(List<Point> pointList){
    bool retVal = false;
    pointList.forEach((element) {
      if(element.x == x+1 && element.y == y){
        retVal = true;
      }
    });
    return retVal;
  }
}