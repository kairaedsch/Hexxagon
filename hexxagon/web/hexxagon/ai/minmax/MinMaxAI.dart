import '../../../general/Intelligence.dart';
import '../../../general/TileType.dart';
import '../../HexxagonHistory.dart';
import '../../HexxagonMove.dart';
import '../ArtificialIntelligence.dart';
import '../../Hexxagon.dart';
import '../MoveFinder.dart';

typedef double Heuristic(Hexxagon hexxagon, TileType player);

class MinMaxAI extends ArtificialIntelligence
{
  static final int WIN = 1000;

  int _treeDepth;

  @override
  String get name => "Min Max";

  @override
  int get strength => _treeDepth + 1;

  MinMaxAI(this._treeDepth);

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    List<HexxagonMove> allPossibleMoves = MoveFinder.getAllMovesOptimiseAll(hexxagon);

    HexxagonHistory hexxagonHistory = new HexxagonHistory.clone(hexxagon);

    HexxagonMove bestMove = null;
    double bestValue = double.NEGATIVE_INFINITY;
    for (HexxagonMove move in allPossibleMoves)
    {
      hexxagonHistory.move(move);
      double childValue = minimax(hexxagonHistory, _treeDepth, heuristic, hexxagon.currentPlayer, bestValue, double.INFINITY);
      hexxagonHistory.undoLastMove();
      if (childValue > bestValue)
      {
        bestValue = childValue;
        bestMove = move;
      }
    }

    moveCallback(bestMove);
  }

  double heuristic(Hexxagon hexxagon, TileType player)
  {
    return hexxagon.countTilesOfType(player) - hexxagon.countTilesOfType(TileTypes.other(player)).roundToDouble();
  }

  double minimax(HexxagonHistory hexxagonHistory, int depth, Heuristic heuristic, TileType player, double bestValue, double worstValue)
  {
    if (depth == 0)
    {
      return heuristic(hexxagonHistory, player);
    }

    List<HexxagonMove> allPossibleMoves = MoveFinder.getAllMovesOptimiseAll(hexxagonHistory);
    if (allPossibleMoves.length == 0)
    {
      return heuristic(hexxagonHistory, player) + (hexxagonHistory.betterPlayer == player ? WIN : -WIN);
    }

    if (hexxagonHistory.currentPlayer == player)
    {
      for (HexxagonMove move in allPossibleMoves)
      {
        hexxagonHistory.move(move);
        double childValue = minimax(hexxagonHistory, depth - 1, heuristic, player, bestValue, worstValue);
        hexxagonHistory.undoLastMove();
        if (childValue > bestValue)
        {
          bestValue = childValue;
        }
        if (bestValue >= worstValue)
        {
          return bestValue;
        }
      }

      return bestValue;
    }
    else
    {
      for (HexxagonMove move in allPossibleMoves)
      {
        hexxagonHistory.move(move);
        double childValue = minimax(hexxagonHistory, depth - 1, heuristic, player, bestValue, worstValue);
        hexxagonHistory.undoLastMove();
        if (childValue < worstValue)
        {
          worstValue = childValue;
        }
        if (worstValue <= bestValue)
        {
          return worstValue;
        }
      }

      return worstValue;
    }
  }
}