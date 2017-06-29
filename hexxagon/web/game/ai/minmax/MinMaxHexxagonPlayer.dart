import '../../ComputerPlayer.dart';
import '../../../general/Move.dart';
import '../../../general/Player.dart';
import '../../../general/TilePosition.dart';
import '../../../general/TileType.dart';
import '../../Hexxagon.dart';
import '../../RandomHexxagonPlayer.dart';
import 'dart:async';

import 'dart:math';
import 'package:tuple/tuple.dart';

typedef double Heuristic(Hexxagon hexxagon, int player);

class MinMaxHexxagonPlayer extends ComputerPlayer
{
  String get name
  => "Min Max Player";

  String get image
  => "robot-2.png";

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    List<Move> allPossibleMoves = hexxagon.getAllPossibleMoves();

    Move bestMove = null;
    double bestValue = double.NEGATIVE_INFINITY;
    for (Move move in allPossibleMoves)
    {
      Hexxagon childHexxagon = new Hexxagon.clone(hexxagon);
      childHexxagon.move(move.source, move.target);
      double childValue = minimax(childHexxagon, 4, heuristic, hexxagon.getCurrentPlayer(), bestValue);
      if (childValue > bestValue)
      {
        bestValue = childValue;
        bestMove = move;
      }
    }

    moveCallback(bestMove);
  }

  double heuristic(Hexxagon hexxagon, int player)
  {
    return hexxagon.countTilesOfType(player).roundToDouble();
  }

  double minimax(Hexxagon hexxagon, int depth, Heuristic heuristic, int player, double bestNeighbour)
  {
    if (depth == 0)
    {
      return heuristic(hexxagon, player);
    }

    List<Move> allPossibleMoves = hexxagon.getAllPossibleMoves();
    if (allPossibleMoves.length == 0)
    {
      return heuristic(hexxagon, player);
    }

    if (hexxagon.getCurrentPlayer() == player)
    {
      double bestValue = double.NEGATIVE_INFINITY;
      for (Move move in allPossibleMoves)
      {
        Hexxagon childHexxagon = new Hexxagon.clone(hexxagon);
        childHexxagon.move(move.source, move.target);
        double childValue = minimax(childHexxagon, depth - 1, heuristic, player, bestValue);
        if (childValue > bestValue)
        {
          bestValue = childValue;
        }
        if (bestValue > bestNeighbour)
        {
          return bestValue;
        }
      }

      return bestValue;
    }
    else
    {
      double bestValue = double.INFINITY;
      for (Move move in allPossibleMoves)
      {
        Hexxagon childHexxagon = new Hexxagon.clone(hexxagon);
        childHexxagon.move(move.source, move.target);
        double childValue = minimax(childHexxagon, depth - 1, heuristic, player, bestValue);
        if (childValue < bestValue)
        {
          bestValue = childValue;
        }
        if (bestValue < bestNeighbour)
        {
          return bestValue;
        }
      }

      return bestValue;
    }
  }
}