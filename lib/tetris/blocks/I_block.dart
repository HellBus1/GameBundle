import 'package:bundle_of_simple_game/tetris/tetris_util/block_substance.dart';
import 'package:bundle_of_simple_game/tetris/tetris_util/point.dart';
import 'package:flutter/material.dart';

class IBlock extends BlockSubstance {
  IBlock(int width){
    points[0] = Point((width/2 - 2).floor(), -1);
    points[1] = Point((width/2 - 1).floor(), -1);
    points[2] = Point((width/2 - 0).floor(), -1);
    points[3] = Point((width/2 + 1).floor(), -1);
    rotationCenter = points[1];
    color = Colors.cyanAccent;
  }
}