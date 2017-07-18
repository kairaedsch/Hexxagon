import '../../../general/Board.dart';
import '../../../general/TilePosition.dart';
import '../../HexxagonMove.dart';
import 'dart:math';

import '../../../general/Intelligence.dart';
import '../ArtificialIntelligence.dart';
import '../../Hexxagon.dart';

/// An artificial intelligence who chooses random moves but never a move which does not rise the score of the current player.
class RandomAI extends ArtificialIntelligence
{
  @override
  String get name => "Random";

  @override
  int get strength => 0;

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    Random rng = new Random();
    moveCallback(getRandomMove(hexxagon, rng));
  }

  /// Chooses a random move but never a move which does not rise the score of the current player.
  static HexxagonMove getRandomMove(Hexxagon hexxagon, Random rng)
  {
    TilePosition start = TilePosition.get(rng.nextInt(hexxagon.width), rng.nextInt(hexxagon.height));
    TilePosition loop = start;

    do
    {
      if (hexxagon.get(loop) == hexxagon.currentPlayer)
      {
        List<HexxagonMove> possibleMoves = hexxagon.getPossibleMoves(loop);
        if (possibleMoves.isNotEmpty)
        {
          HexxagonMove move = getRandomMoveFromMoves(hexxagon, possibleMoves, rng);
          if (move != null)
          {
            return move;
          }
        }
      }
      loop = loop.next(hexxagon.width, hexxagon.height);
    }
    while (!loop.equals(start));

    return null;
  }

  /// Chooses a random move from the given ones but never a move which does not rise the score of the current player.
  static HexxagonMove getRandomMoveFromMoves(Hexxagon hexxagon, List<HexxagonMove> possibleMoves, Random rng)
  {
    int start = rng.nextInt(possibleMoves.length);
    int i = start;
    do
    {
      HexxagonMove move = possibleMoves[i];
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
        return move;
      }
      i = (i + 1) % possibleMoves.length;
    }
    while (start != i);
    return null;
  }
}