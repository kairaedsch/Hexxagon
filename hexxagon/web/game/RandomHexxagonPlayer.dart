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
    List<TilePosition> canBeMoved = hexxagon.canBeMoved(player);
    TilePosition position = (canBeMoved..shuffle())[0];
    return (hexxagon.getPossibleMoves(player, position)
        ..shuffle())[0];
  }

  void move2(Hexxagon hexxagon, int player)
  {
    List<TilePosition> canBeMoved = hexxagon.canBeMoved(player);
    TilePosition position = (canBeMoved..shuffle())[0];
    Move move = (hexxagon.getPossibleMoves(player, position)..shuffle())[0];
    hexxagon.move(player, move.source, move.target);
  }
}