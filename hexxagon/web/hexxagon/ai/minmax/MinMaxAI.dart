import '../../../general/Move.dart';
import '../../../general/Intelligence.dart';
import '../../../general/TileType.dart';
import '../../HexxagonHistory.dart';
import '../ArtificialIntelligence.dart';
import '../../Hexxagon.dart';
import '../MoveFinder.dart';

typedef double Heuristic(Hexxagon hexxagon, TileType player);

class MinMaxAI extends ArtificialIntelligence
{
  static final int WIN = 1000;

  int _treeDepth;
  bool _preferCopies;

  String get name
  => "Min Max${_preferCopies ? "" : " no pref"}";

  int get strength
  => (_treeDepth - 1);

  MinMaxAI(this._treeDepth, [bool preferCopies = true])
  {
    this._preferCopies = preferCopies;
  }

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    List<Move> allPossibleMoves = MoveFinder.getAllMovesOptimiseAll(hexxagon);

    HexxagonHistory hexxagonHistory = new HexxagonHistory.clone(hexxagon);

    Move bestMove = null;
    double bestValue = double.NEGATIVE_INFINITY;
    for (Move move in allPossibleMoves)
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
    return (hexxagon.countTilesOfType(player) - hexxagon.countTilesOfType(TileTypes.other(player))).roundToDouble();
  }

  double minimax(HexxagonHistory hexxagonHistory, int depth, Heuristic heuristic, TileType player, double bestValue, double worstValue)
  {
    if (depth == 0)
    {
      return heuristic(hexxagonHistory, player);
    }

    List<Move> allPossibleMoves = _preferCopies ? MoveFinder.getAllMovesOptimiseAll(hexxagonHistory) : MoveFinder.getAllMovesOptimiseOnlyJumps(hexxagonHistory);
    if (allPossibleMoves.length == 0)
    {
      return heuristic(hexxagonHistory, player) + (hexxagonHistory.currentPlayer == player ? WIN : -WIN);
    }

    if (hexxagonHistory.currentPlayer == player)
    {
      for (Move move in allPossibleMoves)
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
      for (Move move in allPossibleMoves)
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