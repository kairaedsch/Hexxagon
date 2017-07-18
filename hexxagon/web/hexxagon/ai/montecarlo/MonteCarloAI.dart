import '../../../general/TileType.dart';
import '../MoveFinder.dart';
import '../random/RandomAI.dart';
import 'dart:math';

import 'package:tuple/tuple.dart';

import '../../../general/Move.dart';
import '../../../general/Intelligence.dart';
import '../ArtificialIntelligence.dart';
import '../../Hexxagon.dart';

class MonteCarloAI extends ArtificialIntelligence
{
  @override
  String get name => "MonteCarlo Player";

  @override
  int get strength => 1;

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    List<Tuple2<int, Move>> possibleMoves = MoveFinder.getAllMovesOptimiseAll(hexxagon)
        .map((move) => new Tuple2(0, move))
        .toList(growable: true);

    Random rng = new Random();
    DateTime start = new DateTime.now();
    int rounds = 0;
    while (new DateTime.now().difference(start).inMilliseconds < 5000)
    {
      for (int innerRound = 0; innerRound < 20; innerRound++)
      {
        for (int i = 0; i < possibleMoves.length; i++)
        {
          Tuple2<int, Move> t = possibleMoves[i];
          Hexxagon clone = new Hexxagon.clone(hexxagon);
          clone.move(t.item2);
          Move move;
          while ((move = RandomAI.getRandomMove(clone, rng)) != null)
          {
            clone.move(move);
          }
          TileType betterPlayer = clone.betterPlayer;
          if (betterPlayer == hexxagon.currentPlayer)
          {
            possibleMoves[i] = new Tuple2(t.item1 + 1, t.item2);
          }
          else if (betterPlayer == hexxagon.notCurrentPlayer)
          {
            possibleMoves[i] = new Tuple2(t.item1 - 1, t.item2);
          }
        }
      }
      rounds++;
    }
    print("AI: $rounds rounds");

    possibleMoves.shuffle();
    Move move = possibleMoves
        .reduce((t1, t2)
    => t1.item1 >= t2.item1 ? t1 : t2)
        .item2;
    moveCallback(move);
  }
}