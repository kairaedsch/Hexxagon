import '../../../general/Intelligence.dart';
import '../../../general/TileType.dart';
import '../../HexxagonMove.dart';
import '../ArtificialIntelligence.dart';
import '../../Hexxagon.dart';
import '../MoveFinder.dart';
import 'package:tuple/tuple.dart';

/// An artificial intelligence who chooses moves by evaluating the move and the tiles around it.
class MoveAI extends ArtificialIntelligence
{
  /// Coefficient for capturing enemy tiles.
  final double _goNearCoef = 0.2;

  /// Coefficient for not leaving own tiles alone.
  final double _goAwayCoef = 0.2;

  @override
  String get name => "Move";

  @override
  int get strength => 2;

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    List<HexxagonMove> allPossibleMoves = MoveFinder.getAllMovesOptimiseAll(hexxagon);

    Iterable<Tuple2<HexxagonMove, double>> allPossibleMovesEvaluated = allPossibleMoves.map((move) => new Tuple2(move, evaluateMove(hexxagon, move)));

    moveCallback(allPossibleMovesEvaluated
        .reduce((a, b) => a.item2 >= b.item2 ? a : b)
        .item1);
  }

  /// Calculate the value of a move.
  double evaluateMove(Hexxagon hexxagon, HexxagonMove move)
  {
    TileType player = hexxagon.currentPlayer;
    TileType enemy = TileTypes.other(player);
    int enemyGoNear = 0;
    int selfGoNear = 0;
    bool goingToWall = false;
    move.to.forEachNeighbour(hexxagon, (neighbour)
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
    move.from.forEachNeighbour(hexxagon, (neighbour)
    {
      TileType neighbourTile = hexxagon.get(neighbour);
      if (neighbourTile == player)
      {
        selfGoAway++;
      }
    });

    return enemyGoNear + _goNearCoef * selfGoNear + ((move.kindOf == "jump") ? (-selfGoAway * _goAwayCoef) : 1) + (goingToWall ? 0.05 : 0);
  }
}