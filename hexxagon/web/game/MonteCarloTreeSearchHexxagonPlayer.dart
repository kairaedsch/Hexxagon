import 'ComputerPlayer.dart';
import '../general/Move.dart';
import '../general/Player.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'GameNode.dart';
import 'Hexxagon.dart';
import 'RandomHexxagonPlayer.dart';
import 'dart:async';

import 'dart:math';
import 'package:tuple/tuple.dart';

class MonteCarloTreeSearchHexxagonPlayer extends ComputerPlayer
{
  String get name
  => "MonteCarlo TreeSearch Player";

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    GameNode root = new GameNode(null, hexxagon, null);

    for (int r = 0; r < 30000; r++)
    {
      root.playRandom();
    }

    print(root.toTree("", "", 2));

    moveCallback(root.getBestMove());
  }
}