import 'dart:math';
import 'package:bundle_of_simple_game/tetris/blocks/I_block.dart';
import 'package:bundle_of_simple_game/tetris/blocks/J_block.dart';
import 'package:bundle_of_simple_game/tetris/blocks/L_block.dart';
import 'package:bundle_of_simple_game/tetris/blocks/S_block.dart';
import 'package:bundle_of_simple_game/tetris/blocks/T_block.dart';
import 'package:bundle_of_simple_game/tetris/blocks/Z_block.dart';
import 'package:bundle_of_simple_game/tetris/blocks/sq_block.dart';
import 'package:bundle_of_simple_game/tetris/main_screen_tetris.dart';
import 'package:bundle_of_simple_game/tetris/tetris_util/block_substance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BlockSubstance getRandomBlock(){
  int random = Random().nextInt(7);
  switch(random){
    case 0:{
      return IBlock(BOARD_WIDTH);
    }break;
    case 1:{
      return JBlock(BOARD_WIDTH);
    }break;
    case 2:{
      return LBlock(BOARD_WIDTH);
    }break;
    case 3:{
      return SBlock(BOARD_WIDTH);
    }break;
    case 4:{
      return SquareBlock(BOARD_WIDTH);
    }break;
    case 5:{
      return TBlock(BOARD_WIDTH);
    }break;
    case 6:{
      return ZBlock(BOARD_WIDTH);
    }break;
  }
}

Widget getTetrisPoint(Color color){
  return Container(
    width: POINT_SIZE,
    height: POINT_SIZE,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.rectangle,
      border: Border.all(color: Colors.black)
    ),
  );
}

Widget getGameOverText(int score){
  return Center(
    child: Text('Game Over\nEnd ScoreL $score'),
  );
}