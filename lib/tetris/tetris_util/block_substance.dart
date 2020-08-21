import 'package:bundle_of_simple_game/tetris/main_screen_tetris.dart';
import 'package:bundle_of_simple_game/tetris/tetris_util/point.dart';
import 'package:flutter/material.dart';

class BlockSubstance {
  List<Point> points = List<Point>(4);
  Point rotationCenter;
  Color color;

  void move(MoveDirection direction, bool canMoveSide){
    switch(direction){
      case MoveDirection.LEFT:{
        if(sideCollition(-1) && canMoveSide){
          points.forEach((element) {
            element.x -= 1;
          });
        }
      }break;
      case MoveDirection.RIGHT:{
        if(sideCollition(1) && canMoveSide){
          points.forEach((element) {
            element.x += 1;
          });
        }
      }break;
      default:{

      }break;
    }
  }

  void moveDown(){
    points.forEach((element) {
      element.y += 1;
    });
  }

  bool sideCollition(int moveAmnt){
    bool retVal = true;
    points.forEach((element) {
      if((element.x + moveAmnt < 0) || (element.x + moveAmnt >= BOARD_WIDTH)){
        retVal = false;
      }
    });
    return retVal;
  }

  bool allPointsmustInside(){
    bool retVal = true;
    points.forEach((element) {
      if((element.x  < 0) || (element.x >= BOARD_WIDTH)){
        retVal = false;
      }
    });
    return retVal;
  }

  void rotateRight(){
    points.forEach((element) {
      int x = element.x;
      element.x = rotationCenter.x - element.y + rotationCenter.y;
      element.y = rotationCenter.y + x - rotationCenter.x;
    });

    if(!allPointsmustInside()){
      rotateLeft();
    }
  }

  void rotateLeft(){
    points.forEach((element) {
      int x = element.x;
      element.x = rotationCenter.x + element.y - rotationCenter.y;
      element.y = rotationCenter.y - x + rotationCenter.x;
    });

    if(!allPointsmustInside()){
      rotateRight();
    }
  }

  bool isAtBottom(){
    int lowestPoint = 0;
    points.forEach((element) {
      if(element.y > lowestPoint){
        lowestPoint = element.y;
      }
    });

    if((lowestPoint >= BOARD_HEIGHT - 1)){
      return true;
    }else{
      return false;
    }
  }
}