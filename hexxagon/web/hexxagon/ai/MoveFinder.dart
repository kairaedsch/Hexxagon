import '../../general/Move.dart';
import '../../general/TilePosition.dart';
import '../../general/TileType.dart';
import '../Hexxagon.dart';
import '../HexxagonMove.dart';
import 'dart:collection';

/// Helps finding all relevant moves for artificial intelligences.
class MoveFinder
{
  /// Get all possible moves and ignore:
  /// * copies to the same position.
  static List<Move> getAllMovesOptimiseOnlyCopies(Hexxagon hexxagon)
  {
    Map<TilePosition, Move> possibleCopies = new HashMap<TilePosition, Move>();
    List<Move> moves = new List<Move>();
    TilePosition.forEachOnBoard(hexxagon, (TilePosition from)
    {
      if (hexxagon.get(from) == hexxagon.currentPlayer)
      {
        _forEachCopyMoves(hexxagon, from, (move)
        {
          possibleCopies[move.to] = move;
        });
        _forEachJumpMoves(hexxagon, from, (move)
        {
          moves.add(move);
        });
      }
    });
    return moves..addAll(possibleCopies.values);
  }

  /// Get all possible moves and ignore:
  /// * copies to the same position.
  /// * jumps if you can also copy to the target of the jump.
  /// * ignore jumps if this jump would not capture any enemy tiles..
  static List<Move> getAllMovesOptimiseAll(Hexxagon hexxagon)
  {
    Map<TilePosition, Move> possibleMoves = new HashMap<TilePosition, Move>();
    List<Move> moves = new List<Move>();
    TilePosition.forEachOnBoard(hexxagon, (TilePosition from)
    {
      if (hexxagon.get(from) == hexxagon.currentPlayer)
      {
        _forEachCopyMoves(hexxagon, from, (move)
        {
          possibleMoves[move.to] = move;
        });
        _forEachJumpMoves(hexxagon, from, (move)
        {
          bool hasEnemyNeihbours = false;
          move.to.forEachNeighbour(hexxagon, (neighbour)
          {
            if (!hasEnemyNeihbours)
            {
              hasEnemyNeihbours = hexxagon.get(neighbour) == hexxagon.notCurrentPlayer;
            }
          });
          if (hasEnemyNeihbours && !possibleMoves.containsKey(move.to))
          {
            moves.add(move);
          }
        });
      }
    });
    return moves..addAll(possibleMoves.values);
  }

  /// Calls the given consumer method for each possible copy move from the given location on the given Hexxagon board.
  static void _forEachCopyMoves(Hexxagon hexxagon, TilePosition from, void consumer(HexxagonMove move))
  {
    if (hexxagon.get(from) != hexxagon.currentPlayer)
    {
      return;
    }
    from.forEachNeighbour(hexxagon, (neighbour)
    {
      if (hexxagon.get(neighbour) == TileType.EMPTY)
      {
        consumer(new HexxagonMove(from, neighbour));
      }
    });
  }

  /// Calls the given consumer method for each possible jump move from the given location on the given Hexxagon board.
  static void _forEachJumpMoves(Hexxagon hexxagon, TilePosition from, void consumer(HexxagonMove move))
  {
    if (hexxagon.get(from) != hexxagon.currentPlayer)
    {
      return;
    }
    from.forEachNeighbourSecondRing(hexxagon, (neighbour)
    {
      if (hexxagon.get(neighbour) == TileType.EMPTY)
      {
        consumer(new HexxagonMove(from, neighbour));
      }
    });
  }
}