import 'dart:math';

import 'package:tuple/tuple.dart';

import '../../../general/Move.dart';
import '../../../general/Player.dart';
import '../ComputerPlayer.dart';
import '../../Hexxagon.dart';

class MonteCarloHexxagonPlayer extends ComputerPlayer
{
  String get name
  => "MonteCarlo Player";

  String get image => "robot-3.png";

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    List<Tuple2<int, Move>> possibleMoves = hexxagon.getAllPossibleMoves().map((move)
    => new Tuple2(0, move)).toList(growable: true);

    Random rng = new Random();
    int rounds = 0;
    while (rounds < 500)
    {
      for (int i = 0; i < possibleMoves.length; i++)
      {
        Tuple2<int, Move> t = possibleMoves[i];
        Hexxagon clone = new Hexxagon.clone(hexxagon);
        clone.move(t.item2.source, t.item2.target);
        Move move;
        while ((move = clone.getRandomMove(rng)) != null)
        {
          clone.move(move.source, move.target);
        }
        int betterPlayer = clone.betterPlayer;
        if (betterPlayer == hexxagon.getCurrentPlayer())
        {
          possibleMoves[i] = new Tuple2(t.item1 + 1, t.item2);
        }
        if (betterPlayer == hexxagon.getNotCurrentPlayer())
        {
          possibleMoves[i] = new Tuple2(t.item1 - 1, t.item2);
        }
      }
      rounds++;
    }
    print(rounds);
    //print(possibleMoves);

    possibleMoves.shuffle();
    Move move = possibleMoves
        .reduce((t1, t2)
    => t1.item1 >= t2.item1 ? t1 : t2)
        .item2;
    moveCallback(move);
  }
}