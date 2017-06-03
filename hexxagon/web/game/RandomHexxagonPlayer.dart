import 'ComputerPlayer.dart';
import '../general/Move.dart';
import '../general/Player.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'Hexxagon.dart';
import 'dart:async';

import 'dart:math';

class RandomHexxagonPlayer extends ComputerPlayer
{
  String get name => "Random Player";

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    Random rng = new Random();
    moveCallback(hexxagon.getRandomMove(rng));
  }
}