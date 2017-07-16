import '../../../general/Board.dart';
import '../../../general/Move.dart';
import '../../../general/TilePosition.dart';
import 'dart:math';

import '../../../general/Intelligence.dart';
import '../ArtificialIntelligence.dart';
import '../../Hexxagon.dart';

/// An artificial intelligence who chooses random moves but never a move which does not rise the score of the current player.
class RandomAI extends ArtificialIntelligence
{
  String get name
  => "Random";

  int get strength
  => 1;

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    Random rng = new Random();
    moveCallback(getRandomMove(hexxagon, rng));
  }

  /// Chooses a random move but never a move which does not rise the score of the current player.
  static Move getRandomMove(Hexxagon hexxagon, Random rng)
  {
    TilePosition start = TilePosition.get(rng.nextInt(hexxagon.width), rng.nextInt(hexxagon.height));
    TilePosition loop = start;

    do
    {
      if (hexxagon.get(loop) == hexxagon.currentPlayer)
      {
        List<Move> possibleMoves = hexxagon.getPossibleMoves(loop);
        if (possibleMoves.isNotEmpty)
        {
          return getRandomMoveFromTile(hexxagon, possibleMoves, rng);
        }
      }
      loop = loop.next(hexxagon.width, hexxagon.height);
    }
    while (!loop.equals(start));

    return null;
  }

  /// Chooses a random move from the given ones but never a move which does not rise the score of the current player.
  static Move<Board> getRandomMoveFromTile(Hexxagon hexxagon, List<Move<Board>> possibleMoves, Random rng)
  {
    int start = rng.nextInt(possibleMoves.length);
    int i = start;
    do
    {
      Move<Board> move = possibleMoves[i];
      bool goodMove = true;
      if (move.kindOf == "jump")
      {
        goodMove = false;
        move.to.forEachNeighbour(hexxagon, (neighbour)
        {
          if (hexxagon.get(neighbour) == hexxagon.notCurrentPlayer)
          {
            goodMove = true;
          }
        });
      }
      if (goodMove)
      {
        return possibleMoves[i];
      }
      i = (i + 1) % possibleMoves.length;
    }
    while (start != i);
    throw new Exception("There has to be a copy move or a good jump");
  }
}