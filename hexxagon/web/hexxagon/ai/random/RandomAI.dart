import '../../../general/Board.dart';
import '../../../general/Move.dart';
import '../../../general/TilePosition.dart';
import 'dart:math';

import '../../../general/Intelligence.dart';
import '../ArtificialIntelligence.dart';
import '../../Hexxagon.dart';

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
          Move<Board> randomMoveFromTile = getRandomMoveFromTile(hexxagon, possibleMoves, rng);
          if (randomMoveFromTile != null)
          {
            return randomMoveFromTile;
          }
        }
      }
      loop = loop.next(hexxagon.width, hexxagon.height);
    }
    while (!loop.equals(start));

    return null;
  }

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
    return null;
  }
}