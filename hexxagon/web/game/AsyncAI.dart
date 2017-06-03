import '../game/Hexxagon.dart';
import '../game/MonteCarloHexxagonPlayer.dart';
import '../game/RandomHexxagonPlayer.dart';
import '../general/Move.dart';
import 'ComputerPlayer.dart';
import 'dart:isolate';

import 'package:dartson/dartson.dart';

void main(List<String> args, SendPort sendPort)
{
  var dson = new Dartson.JSON();

  ComputerPlayer computerPlayer = dson.decode(args[0], new MonteCarloHexxagonPlayer());
  Hexxagon hexxagon = dson.decode(args[1], new Hexxagon());
  int player = int.parse(args[2]);
  print("sfsf");
  Move move = computerPlayer.CalculateMove(hexxagon, player);

  sendPort.send(dson.encode(move));
}
