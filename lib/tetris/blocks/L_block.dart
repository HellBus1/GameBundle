import 'package:bundle_of_simple_game/tetris/tetris_util/block_substance.dart';
import 'package:bundle_of_simple_game/tetris/tetris_util/point.dart';
import 'package:flutter/material.dart';

class LBlock extends BlockSubstance {
  LBlock(int width){
    points[0] = Point((width/2 - 1).floor(), 0);
    points[1] = Point((width/2 + 0).floor(), 0);
    points[2] = Point((width/2 + 1).floor(), 0);
    points[3] = Point((width/2 + 1).floor(), -1);
    rotationCenter = points[1];
    color = Colors.purple;
  }
}