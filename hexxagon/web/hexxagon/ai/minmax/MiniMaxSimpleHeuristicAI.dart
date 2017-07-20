import '../../../general/TileType.dart';
import '../../Hexxagon.dart';
import 'MiniMaxAI.dart';

typedef double Heuristic(Hexxagon hexxagon, TileType player);

/// A AI, which uses the MiniMax algorithm with a simple heuristic.
class MiniMaxSimpleHeuristicAI extends MiniMaxAI
{
  /// Create a new MiniMaxSimpleHeuristicAI with the given depth.
  MiniMaxSimpleHeuristicAI(int treeDepth) : super(treeDepth);

  /// A simple heuristic which is surprisingly strong.
  @override
  double heuristic(Hexxagon hexxagon, TileType player)
  {
    return hexxagon.countTilesOfType(player) - hexxagon.countTilesOfType(TileTypes.other(player)).roundToDouble();
  }
}