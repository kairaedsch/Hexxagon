import '../../../general/Board.dart';
import '../../../general/TilePosition.dart';
import '../../board/HexxagonMove.dart';
import 'dart:math';

import '../../../general/Intelligence.dart';
import '../ArtificialIntelligence.dart';
import '../../board/Hexxagon.dart';

/// An artificial intelligence who chooses random moves but never a move which does not rise the score of the current player.
class RandomAI extends ArtificialIntelligence
{
  @override
  String get name => "Random";

  @override
  int get strength => 0;

  @override
  void moveAI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    Random rng = new Random();
    moveCallback(getRandomMove(hexxagon, rng));
  }

  /// Chooses a random move but never a move which does not rise the score of the current player.
  /// Please note, that although some bad moves are filtered, this function will always return a Move, if any exists.
  /// Also note, that the possibilities to be taken around all good moves are not equally distributed, but should not vary too much. This is done for performance reasons.
  static HexxagonMove getRandomMove(Hexxagon hexxagon, Random rng)
  {
    /// Get a random start Tile and search through all tiles.
    TilePosition randomStartTile = TilePosition.get(rng.nextInt(hexxagon.width), rng.nextInt(hexxagon.height));
    TilePosition loop = randomStartTile;

    do
    {
      /// Check if there are moves from the current tile and choose a random move from it, if any move is good enough.
      if (hexxagon.couldBeMoved(loop))
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
    while (!loop.equals(randomStartTile));

    return null;
  }

  /// Chooses a random move from the given ones but never a move which does not rise the score of the current player.
  static HexxagonMove getRandomMoveFromMoves(Hexxagon hexxagon, List<HexxagonMove> possibleMoves, Random rng)
  {
    /// Get a random start index and search through all moves.
    int start = rng.nextInt(possibleMoves.length);
    int i = start;
    do
    {
      HexxagonMove move = possibleMoves[i];
      /// If the move is a jump, it is only then good enough, if any enemy tile will be captured.
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

    /// No good move was found.
    return null;
  }
}