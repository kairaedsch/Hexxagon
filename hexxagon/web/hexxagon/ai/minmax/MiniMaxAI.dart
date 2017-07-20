import '../../../general/Intelligence.dart';
import '../../../general/TileType.dart';
import '../../board/HexxagonHistory.dart';
import '../../board/HexxagonMove.dart';
import '../ArtificialIntelligence.dart';
import '../../board/Hexxagon.dart';
import '../MoveFinder.dart';

/// A AI, which uses the MiniMax algorithm and alpha beta pruning.
abstract class MiniMaxAI extends ArtificialIntelligence
{
  /// The factor added, if a game is over and won.
  static final int WIN = 1000;

  /// The depth of the tree when searching.
  int _treeDepth;

  @override
  String get name => "Min Max";

  @override
  int get strength => _treeDepth + 2;

  /// Create a new MiniMaxAI with the given depth (must be greater or equal to 1).
  MiniMaxAI(this._treeDepth);

  @override
  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    // The HexxagonHistory is used, to save memory and time wasted for cloning a whole Hexxagon board, by reusing the Hexxagon array by undoing moves.
    HexxagonHistory hexxagonHistory = new HexxagonHistory.clone(hexxagon);

    List<HexxagonMove> allPossibleMoves = MoveFinder.getAllMovesOptimiseAll(hexxagon);

    HexxagonMove bestMove = null;
    double bestValue = double.NEGATIVE_INFINITY;
    for (HexxagonMove move in allPossibleMoves)
    {
      // Start the recursion.
      hexxagonHistory.move(move);
      double childValue = minimax(hexxagonHistory, _treeDepth - 1, hexxagon.currentPlayer, bestValue, double.INFINITY);
      hexxagonHistory.undoLastMove();

      // Check if a new best move was found.
      if (childValue > bestValue)
      {
        bestValue = childValue;
        bestMove = move;
      }
    }

    moveCallback(bestMove);
  }

  /// The heuristic to be used.
  double heuristic(Hexxagon hexxagon, TileType player);

  double minimax(HexxagonHistory hexxagonHistory, int depth, TileType player, double minBestValue, double maxWorstValue)
  {
    // If the depth is 0, it is time to abort the recursion.
    if (depth <= 0)
    {
      return heuristic(hexxagonHistory, player);
    }

    List<HexxagonMove> allPossibleMoves = MoveFinder.getAllMovesOptimiseAll(hexxagonHistory);

    // Is there are no moves, the game must be over.
    if (allPossibleMoves.length == 0)
    {
      return heuristic(hexxagonHistory, player) + (hexxagonHistory.betterPlayer == player ? WIN : -WIN);
    }

    // If we have the to get the best move => MAX.
    if (hexxagonHistory.currentPlayer == player)
    {
      for (HexxagonMove move in allPossibleMoves)
      {
        // Do the recursion.
        hexxagonHistory.move(move);
        double childValue = minimax(hexxagonHistory, depth - 1, player, minBestValue, maxWorstValue);
        hexxagonHistory.undoLastMove();

        // If we have found a new best child, update the bestValue.
        if (childValue > minBestValue)
        {
          minBestValue = childValue;

          // If we have found a child, which is too good, we can abort (alpha beta pruning).
          if (minBestValue >= maxWorstValue)
          {
            return minBestValue;
          }
        }
      }

      return minBestValue;
    }
    // Or the worst move => MIN.
    else
    {
      for (HexxagonMove move in allPossibleMoves)
      {
        // Do the recursion.
        hexxagonHistory.move(move);
        double childValue = minimax(hexxagonHistory, depth - 1, player, minBestValue, maxWorstValue);
        hexxagonHistory.undoLastMove();

        // If we have found a new worst child, update the worstValue.
        if (childValue < maxWorstValue)
        {
          maxWorstValue = childValue;

          // If we have found a child, which is too bad, we can abort (alpha beta pruning).
          if (maxWorstValue <= minBestValue)
          {
            return maxWorstValue;
          }
        }
      }

      return maxWorstValue;
    }
  }
}