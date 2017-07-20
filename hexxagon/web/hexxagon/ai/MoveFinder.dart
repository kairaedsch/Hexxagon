import '../../general/TilePosition.dart';
import '../../general/TileType.dart';
import '../board/Hexxagon.dart';
import '../board/HexxagonMove.dart';
import 'dart:collection';

/// Helps finding all relevant moves for artificial intelligences.
class MoveFinder
{
  /// Get all possible moves and ignore:
  /// * copies to the same position.
  /// Please note, that although some bad moves are filtered, this function will always return a Move, if any exists.
  static List<HexxagonMove> getAllMovesOptimiseOnlyCopies(Hexxagon hexxagon)
  {
    Map<TilePosition, HexxagonMove> possibleCopies = new HashMap<TilePosition, HexxagonMove>();
    List<HexxagonMove> moves = new List<HexxagonMove>();
    TilePosition.forEachOnBoard(hexxagon, (TilePosition from)
    {
      if (hexxagon.couldBeMoved(from))
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
  /// * ignore jumps if this jump would not capture any enemy tiles.
  /// Please note, that although some bad moves are filtered, this function will always return a Move, if any exists.
  static List<HexxagonMove> getAllMovesOptimiseAll(Hexxagon hexxagon)
  {
    Map<TilePosition, HexxagonMove> copyMoves = new HashMap<TilePosition, HexxagonMove>();
    List<HexxagonMove> jumpMoves = new List<HexxagonMove>();
    TilePosition.forEachOnBoard(hexxagon, (TilePosition from)
    {
      if (hexxagon.couldBeMoved(from))
      {
        _forEachCopyMoves(hexxagon, from, (move)
        {
          copyMoves[move.to] = move;
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
          if (hasEnemyNeihbours && !copyMoves.containsKey(move.to))
          {
            jumpMoves.add(move);
          }
        });
      }
    });
    jumpMoves.removeWhere((hexxagonMove) => copyMoves.containsKey(hexxagonMove));
    return jumpMoves..addAll(copyMoves.values);
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