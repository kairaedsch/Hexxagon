import 'ComputerPlayer.dart';
import '../general/Move.dart';
import '../general/Player.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'Hexxagon.dart';
import 'RandomHexxagonPlayer.dart';
import 'dart:async';

import 'package:dartson/dartson.dart';
import 'package:tuple/tuple.dart';

@Entity()
class MonteCarloHexxagonPlayer extends ComputerPlayer
{
  get isHuman => false;

  String get name => "MonteCarlo Player";

  Move CalculateMove(Hexxagon hexxagon, int player)
  {
    List<TilePosition> canBeMoved = hexxagon.canBeMoved(player);

    List<Tuple2<int, Move>> possibleMoves = [];
    for (TilePosition pos in canBeMoved)
    {
      possibleMoves.addAll(hexxagon.getPossibleMoves(player, pos).map((move)
      => new Tuple2(0, move)));
    }

    DateTime start = new DateTime.now();
    RandomHexxagonPlayer randomHexxagonPlayer = new RandomHexxagonPlayer();
    int rounds = 0;
    while(rounds < 10)
    {
      for (int i = 0; i < possibleMoves.length; i++)
      {
        Tuple2<int, Move> t = possibleMoves[i];
        Hexxagon clone = new Hexxagon.clone(hexxagon);
        clone.move(player, t.item2.source, t.item2.target);
        while (!clone.isOver)
        {
          randomHexxagonPlayer.move2(clone, clone.getCurrentPlayer());
        }
        if (clone.betterPlayer == hexxagon.getCurrentPlayer())
        {
          possibleMoves[i] = new Tuple2(t.item1 + 1, t.item2);
        }
        if (clone.betterPlayer == hexxagon.getNotCurrentPlayer())
        {
          possibleMoves[i] = new Tuple2(t.item1 - 1, t.item2);
        }
      }
      rounds++;
    }
    print(rounds);

    possibleMoves.shuffle();
    Move move = possibleMoves
        .reduce((t1, t2)
    => t1.item1 >= t2.item1 ? t1 : t2)
        .item2;
    return move;
  }
}