import '../game/Hexxagon.dart';
import '../game/MonteCarloHexxagonPlayer.dart';
import '../game/RandomHexxagonPlayer.dart';
import '../general/Move.dart';
import '../general/Player.dart';
import '../general/TileType.dart';
import 'dart:async';
import 'dart:isolate';
import 'package:dartson/dartson.dart';

import 'package:tuple/tuple.dart';

typedef void Callback();


abstract class ComputerPlayer extends Player<Hexxagon>
{
  bool get isHuman
  {
    return false;
  }

  void move(Hexxagon board, int player, MoveCallback moveCallback)
  {
    var dson = new Dartson.JSON();
    ReceivePort receivePort = new ReceivePort();
    receivePort.listen((move)
    {
      moveCallback(dson.decode(move, new Move()));
    });
    Isolate.spawnUri(Uri.parse(identical(1, 1.0) ? "game/AsyncAI.dart.js" : "../game/AsyncAI.dart"), [dson.encode(this), dson.encode(board), player.toString()], receivePort.sendPort);
  }

  Move CalculateMove(Hexxagon board, int player);
}