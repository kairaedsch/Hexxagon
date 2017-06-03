import 'ComputerPlayer.dart';
import '../general/Move.dart';
import '../general/Player.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'Hexxagon.dart';
import 'dart:async';

import 'package:dartson/dartson.dart';

@Entity()
class RandomHexxagonPlayer extends ComputerPlayer
{
  String get name => "Random Player";

  Move CalculateMove(Hexxagon hexxagon, int player)
  {
    return hexxagon.getRandomMove(player);
  }

  void move2(Hexxagon hexxagon, int player)
  {
    Move move = hexxagon.getRandomMove(player);
    hexxagon.move(player, move.source, move.target);
  }
}