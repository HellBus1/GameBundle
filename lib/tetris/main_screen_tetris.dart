import 'dart:async';

import 'package:bundle_of_simple_game/tetris/tetris_util/ActionButton.dart';
import 'package:bundle_of_simple_game/tetris/tetris_util/alivePoint.dart';
import 'package:bundle_of_simple_game/tetris/tetris_util/block_substance.dart';
import 'package:bundle_of_simple_game/tetris/tetris_util/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum MoveDirection {LEFT, RIGHT, DOWN}
enum LastButtonPressed {LEFT, RIGHT, ROTATE_LEFT, NONE, ROTATE_RIGHT}
const int BOARD_WIDTH = 10;
const int BOARD_HEIGHT = 20;
const double POINT_SIZE = 20; //size is px

const int GAME_SPEED = 600;
Timer timer;

class MainPageTetris extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<MainPageTetris>{
  LastButtonPressed performAction = LastButtonPressed.NONE;
  BlockSubstance currentBlock;
  List<AlivePoint> alivePoints = List<AlivePoint>();
  int score = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onActionButtonPressed(LastButtonPressed newAction){
    setState(() {
      performAction = newAction;
    });
  }

  void startGame(){
    setState(() {
      currentBlock = getRandomBlock();
    });
    timer = new Timer.periodic(Duration(milliseconds: GAME_SPEED), onTimeTick);
    score = 0;
  }

  bool canMoveRight(){
    bool retVal = true;
    alivePoints.forEach((element) {
      if(element.checkIfPointsCollideleft(currentBlock.points)){
        retVal = false;
      }
    });
    return retVal;
  }

  bool canMoveLeft(){
    bool retVal = true;
    alivePoints.forEach((element) {
      if(element.checkIfPointsCollideright(currentBlock.points)){
        retVal = false;
      }
    });
    return retVal;
  }

  bool isAboveOldBlocks(){
    bool retVal = false;
    alivePoints.forEach((element) {
      if(element.checkIfPointsCollide(currentBlock.points)){
        retVal = true;
      }
    });
    return retVal;
  }

  void checkForUserInput(){
    if(performAction != LastButtonPressed.NONE){
      setState(() {
        switch(performAction){
          case LastButtonPressed.LEFT:{
            currentBlock.move(MoveDirection.LEFT, canMoveLeft());
          }break;
          case LastButtonPressed.RIGHT:{
            currentBlock.move(MoveDirection.RIGHT, canMoveRight());
          }break;
          case LastButtonPressed.ROTATE_LEFT:{
            currentBlock.rotateLeft();
          }break;
          case LastButtonPressed.ROTATE_RIGHT:{
            currentBlock.rotateRight();
          }break;
          default:{

          }break;
        }

        performAction = LastButtonPressed.NONE;
      });
    }
  }

  void saveOldBlock(){
    currentBlock.points.forEach((element) {
      AlivePoint newPoint = AlivePoint(element.x, element.y, currentBlock.color);
      setState(() {
        alivePoints.add(newPoint);
      });
    });
  }

  void removeRow(int row){
    setState(() {
      alivePoints.removeWhere((element) => element.y == row);
      alivePoints.forEach((element) {
        if(element.y < row){
          element.y += 1;
        }
      });
      score += 1;
    });
  }

  void removeFullRows(){
    for(int currRow=0; currRow<BOARD_HEIGHT; currRow++){
      int counter = 0;
      alivePoints.forEach((element) {
        if(element.y == currRow){
          counter++;
        }
      });

      if(counter >= BOARD_WIDTH){
        //remove current row
        removeRow(currRow);
      }
    }
  }

  bool playerLost(){
    bool retVal = false;
    alivePoints.forEach((element) {
      if(element.y <= 0){
        retVal = true;
      }
    });
    return retVal;
  }

  void onTimeTick(Timer time){
    if((currentBlock == null) || playerLost()){
      return;
    }
    //remove full rows
    removeFullRows();

    if(currentBlock.isAtBottom() || isAboveOldBlocks()){
      //save the block
      saveOldBlock();

      //Spawn new block
      setState(() {
        currentBlock = getRandomBlock();
      });
    }else{
      setState(() {
        currentBlock.moveDown();
      });

      checkForUserInput();
    }
  }

  Widget drawTetrisBlock(){
    if(currentBlock == null){
      return null;
    }
    
    List<Positioned> visiblePoints = List();
    //current block
    currentBlock.points.forEach((element) {
      Positioned newPoint = Positioned(
        child: getTetrisPoint(currentBlock.color),
        left: element.x * POINT_SIZE,
        top: element.y * POINT_SIZE,
      );
      visiblePoints.add(newPoint);
    });

    //old blocks
    alivePoints.forEach((element) {
      visiblePoints.add(
        Positioned(
          child: getTetrisPoint(element.color),
          left: element.x * POINT_SIZE,
          top: element.y * POINT_SIZE,
        )
      );
    });

    return Stack(children: visiblePoints,);
  }

  Widget main_screen(widths, heights){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              child: Text('Score $score'),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black)
              ),
            ),
            Container(
              child: RaisedButton(
                child: Icon(Icons.rotate_90_degrees_ccw),
                onPressed: () async {
                  timer.cancel();
                  Navigator.popAndPushNamed(context, 'tetris');
                },
              ),
            ),
          ],
        ),
        Center(
          child: Container(
            width: 200,
            height: 400,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black)
            ),
            child: (playerLost() == false) ? drawTetrisBlock() : getGameOverText(score),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ActionButton(onActionButtonPressed, Icon(Icons.arrow_left), LastButtonPressed.LEFT),
                    ActionButton(onActionButtonPressed, Icon(Icons.arrow_right), LastButtonPressed.RIGHT),
                  ],
                ),
                ActionButton(onActionButtonPressed, Icon(Icons.arrow_downward), LastButtonPressed.LEFT),
              ],
            ),
            Column(
              children: <Widget>[
                ActionButton(onActionButtonPressed, Icon(Icons.rotate_left), LastButtonPressed.ROTATE_LEFT),
                ActionButton(onActionButtonPressed, Icon(Icons.rotate_right), LastButtonPressed.ROTATE_RIGHT),
              ],
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: main_screen(width, height),
      ),
    );
  }
}