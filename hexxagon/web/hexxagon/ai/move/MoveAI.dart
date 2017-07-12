import '../../../general/Move.dart';
import '../../../general/Intelligence.dart';
import '../../../general/TileType.dart';
import '../ArtificialIntelligence.dart';
import '../../Hexxagon.dart';
import '../MoveFinder.dart';
import 'package:tuple/tuple.dart';

typedef double Heuristic(Hexxagon hexxagon, TileType player);

class MoveAI extends ArtificialIntelligence
{
  final double _goNearCoef = 0.2;
  final double _goAwayCoef = 0.2;

  String get name
  => "Move";

  int get strength
  => 1;

  MoveAI();

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    List<Move> allPossibleMoves = MoveFinder.getAllMovesOptimiseAll(hexxagon);

    Iterable<Tuple2<Move, double>> allPossibleMovesEvaluated = allPossibleMoves.map((move)
    => evaluateMove(hexxagon, move));

    moveCallback(allPossibleMovesEvaluated
        .reduce((a, b)
    => a.item2 >= b.item2 ? a : b)
        .item1);
  }

  Tuple2<Move, double> evaluateMove(Hexxagon hexxagon, Move move)
  {
    TileType player = hexxagon.currentPlayer;
    TileType enemy = TileTypes.other(player);
    int enemyGoNear = 0;
    int selfGoNear = 0;
    bool goingToWall = false;
    move.target.forEachNeighbour(hexxagon, (neighbour)
    {
      TileType neighbourTile = hexxagon.get(neighbour);
      if (neighbourTile == enemy)
      {
        enemyGoNear++;
      }
      else if (neighbourTile == player)
      {
        selfGoNear++;
      }
      else if (neighbourTile == TileType.OUT_OF_FIELD)
      {
        goingToWall = true;
      }
    });
    int selfGoAway = 0;
    move.source.forEachNeighbour(hexxagon, (neighbour)
    {
      TileType neighbourTile = hexxagon.get(neighbour);
      if (neighbourTile == player)
      {
        selfGoAway++;
      }
    });

    return new Tuple2(move, enemyGoNear + _goNearCoef * selfGoNear + ((move.kindOf == "jump") ? (-selfGoAway * _goAwayCoef) : 1) + (goingToWall ? 0.05 : 0));
  }
}