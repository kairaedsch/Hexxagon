import '../game/Hexxagon.dart';
import 'montecarlo/MonteCarloHexxagonPlayer.dart';
import '../game/RandomHexxagonPlayer.dart';
import '../general/Move.dart';
import '../general/Player.dart';
import '../general/TileType.dart';
import 'dart:async';
import 'dart:isolate';

import 'package:tuple/tuple.dart';

typedef void Callback();


abstract class ComputerPlayer extends Player<Hexxagon>
{
  bool get isHuman
  {
    return false;
  }

  void move(Hexxagon board, MoveCallback moveCallback)
  {
    DateTime start = new DateTime.now();
    moveKI(board, moveCallback);
    print("$name: ${new DateTime.now().difference(start).inMilliseconds}ms");
  }

  void moveKI(Hexxagon board, MoveCallback moveCallback);
}