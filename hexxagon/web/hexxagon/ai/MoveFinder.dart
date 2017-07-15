import '../../general/Move.dart';
import '../../general/TilePosition.dart';
import '../../general/TileType.dart';
import '../Hexxagon.dart';
import '../HexxagonMove.dart';
import 'dart:collection';

import 'package:tuple/tuple.dart';

class MoveFinder
{
  static List<Move> getAllMovesOptimiseOnlyJumps(Hexxagon hexxagon)
  {
    Map<TilePosition, Move> possibleCopies = new HashMap<TilePosition, Move>();
    List<Move> moves = new List<Move>();
    for (int x = 0; x < hexxagon.width; x++)
    {
      for (int y = 0; y < hexxagon.height; y++)
      {
        TilePosition from = TilePosition.get(x, y);
        if (hexxagon.get(from) == hexxagon.currentPlayer)
        {
          _getPossibleCopyMoves(hexxagon, from, (move)
          {
            possibleCopies[move.to] = move;
          });
          _getPossibleJumpMoves(hexxagon, from, (move)
          {
            moves.add(move);
          });
        }
      }
    }
    return moves..addAll(possibleCopies.values);
  }

  static List<Move> getAllMovesOptimiseAll(Hexxagon hexxagon)
  {
    Map<TilePosition, Move> possibleMoves = new HashMap<TilePosition, Move>();
    for (int x = 0; x < hexxagon.width; x++)
    {
      for (int y = 0; y < hexxagon.height; y++)
      {
        TilePosition from = TilePosition.get(x, y);
        if (hexxagon.get(from) == hexxagon.currentPlayer)
        {
          _getPossibleCopyMoves(hexxagon, from, (move)
          {
            possibleMoves[move.to] = move;
          });
          _getPossibleJumpMoves(hexxagon, from, (move)
          {
            bool hasEnemyNeihbours = false;
            move.to.forEachNeighbour(hexxagon, (neighbour)
            {
              if (!hasEnemyNeihbours)
              {
                hasEnemyNeihbours = hexxagon.get(neighbour) == hexxagon.notCurrentPlayer;
              }
            });
            if (hasEnemyNeihbours)
            {
              possibleMoves.putIfAbsent(move.to, ()
              => move);
            }
          });
        }
      }
    }
    return possibleMoves.values.toList(growable: false);
  }

  static void _getPossibleCopyMoves(Hexxagon hexxagon, TilePosition from, void consumer(HexxagonMove move))
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

  static void _getPossibleJumpMoves(Hexxagon hexxagon, TilePosition from, void consumer(HexxagonMove move))
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