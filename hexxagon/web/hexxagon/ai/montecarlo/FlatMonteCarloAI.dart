import '../../../general/TileType.dart';
import '../MoveFinder.dart';
import '../random/RandomAI.dart';
import 'dart:math';

import 'package:tuple/tuple.dart';

import '../../../general/Move.dart';
import '../../../general/Intelligence.dart';
import '../ArtificialIntelligence.dart';
import '../../board/Hexxagon.dart';

class FlatMonteCarloAI extends ArtificialIntelligence
{
  @override
  String get name => "Flat MonteCarlo";

  @override
  int get strength => 1;

  /// The time budget for each calculation.
  int _timeBudget;

  /// Create a new FlatMonteCarloAI with the given time budget.
  FlatMonteCarloAI(this._timeBudget);

  @override
  void moveAI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    Random rng = new Random();

    // Get all Moves with score pairs and set the initial win-lost-score to 0.
    List<Tuple2<int, Move>> possibleMoves = MoveFinder.getAllMovesOptimiseAll(hexxagon)
        .map((move) => new Tuple2(0, move))
        .toList(growable: true);

    // Execute the loop while we have not exited our time budget.
    DateTime start = new DateTime.now();
    int rounds = 0;
    while (new DateTime.now().difference(start).inMilliseconds < _timeBudget)
    {
      // For each possible move, play a random party and update its score.
      for (int i = 0; i < possibleMoves.length; i++)
      {
        // Play a random party.
        Tuple2<int, Move> t = possibleMoves[i];
        Hexxagon clone = new Hexxagon.clone(hexxagon);
        clone.move(t.item2);
        Move move;
        while ((move = RandomAI.getRandomMove(clone, rng)) != null)
        {
          clone.move(move);
        }

        // Update its score.
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
      rounds++;
    }
    print("AI: $rounds rounds");

    // Get the best move according to the win-lost-score.
    Move move = possibleMoves
        .reduce((t1, t2) => t1.item1 >= t2.item1 ? t1 : t2)
        .item2;

    moveCallback(move);
  }
}