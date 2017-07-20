import '../../../general/Intelligence.dart';
import '../../../general/TileType.dart';
import '../../board/HexxagonMove.dart';
import '../ArtificialIntelligence.dart';
import '../../board/Hexxagon.dart';
import '../MoveFinder.dart';
import 'package:tuple/tuple.dart';

/// An artificial intelligence who chooses moves by evaluating the move and the tiles around it.
/// The evaluation is done like in Ataxxlet (http://www.linuxonly.nl/docs/4/95_Implementations.html).
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

  @override
  void moveAI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    List<HexxagonMove> allPossibleMoves = MoveFinder.getAllMovesOptimiseAll(hexxagon);

    Iterable<Tuple2<HexxagonMove, double>> allPossibleMovesEvaluated = allPossibleMoves.map((move) => new Tuple2(move, evaluateMove(hexxagon, move)));

    moveCallback(allPossibleMovesEvaluated
        .reduce((a, b) => a.item2 >= b.item2 ? a : b)
        .item1);
  }

  /// Calculate the value of a move. For more explanation see Ataxxlet (http://www.linuxonly.nl/docs/4/95_Implementations.html).
  double evaluateMove(Hexxagon hexxagon, HexxagonMove move)
  {
    TileType player = hexxagon.currentPlayer;
    TileType enemy = TileTypes.other(player);

    // Number of enemy pieces surrounding the destination of the move.
    int enemyGoNear = 0;
    // Number of own pieces surrounding the destination of the move.
    int selfGoNear = 0;
    // Number of neighbours.
    int neigbours = 0;
    move.to.forEachNeighbour(hexxagon, (neighbour)
    {
      neigbours++;
      TileType neighbourTile = hexxagon.get(neighbour);
      if (neighbourTile == enemy)
      {
        enemyGoNear++;
      }
      else if (neighbourTile == player)
      {
        selfGoNear++;
      }
    });
    // If there is a Wall at the destination.
    bool goingToWall = neigbours < 6;

    // Number of own pieces surrounding the origin of the move.
    int selfGoAway = 0;
    move.from.forEachNeighbour(hexxagon, (neighbour)
    {
      TileType neighbourTile = hexxagon.get(neighbour);
      if (neighbourTile == player)
      {
        selfGoAway++;
      }
    });

    // Put all together with some coefficients.
    return enemyGoNear + _goNearCoef * selfGoNear + ((move.kindOf == "jump") ? (-selfGoAway * _goAwayCoef) : 1) + (goingToWall ? 0.05 : 0);
  }
}