import '../../../general/Move.dart';
import '../../../general/TilePosition.dart';
import 'dart:math';

import '../../../general/Intelligence.dart';
import '../ArtificialIntelligence.dart';
import '../../Hexxagon.dart';

class RandomAI extends ArtificialIntelligence
{
  String get name => "Random Player";

  int get strength => 1;

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
          return possibleMoves[rng.nextInt(possibleMoves.length)];
        }
      }
      loop = loop.next(hexxagon.width, hexxagon.height);
    }
    while (!loop.equals(start));

    return null;
  }
}