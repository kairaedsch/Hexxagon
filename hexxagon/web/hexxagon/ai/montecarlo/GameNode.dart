import '../MoveFinder.dart';
import '../random/RandomAI.dart';
import 'dart:math';

import '../../../general/Move.dart';
import '../../../general/GameResult.dart';
import '../../Hexxagon.dart';

class GameNode
{
  List<GameNode> _children;
  GameNode _parent;

  Hexxagon _hexxagon;
  Move _move;
  int _looses;
  int _draws;
  int _wins;

  GameNode(this._parent, this._hexxagon, this._move)
  {
    _looses = 0;
    _draws = 0;
    _wins = 0;
    _children = [];
  }

  GameNode.root(this._hexxagon)
  {
    _looses = 0;
    _draws = 0;
    _wins = 0;
    _children = [];
    _parent = this;
    _move = null;
  }

  GameResult playRandom()
  {
    GameResult result;
    if (_children.isNotEmpty)
    {
      GameNode bestChild = _getNextChild();
      result = bestChild.playRandom();
    }
    else if (_shouldExpand())
    {
      List<Move> possibleMoves = MoveFinder.getAllMovesOptimiseAll(_hexxagon);
      if (possibleMoves.isEmpty)
      {
        result = _hexxagon.getResult(_hexxagon.notCurrentPlayer);
      }
      else
      {
        for (Move move in possibleMoves)
        {
          Hexxagon childBoard = new Hexxagon.clone(_hexxagon);
          childBoard.move(move);
          _children.add(new GameNode(this, childBoard, move));
        }
        GameNode bestChild = _getNextChild();
        result = bestChild.playRandom();
      }
    }
    else
    {
      Random rng = new Random();
      Hexxagon clone = new Hexxagon.clone(_hexxagon);
      Move move;
      while ((move = RandomAI.getRandomMove(clone, rng)) != null)
      {
        clone.move(move);
      }
      result = clone.getResult(clone.notCurrentPlayer);
    }

    if (result == GameResult.WIN)
    {
      _wins++;
      return GameResult.LOST;
    }
    else if (result == GameResult.LOST)
    {
      _looses++;
      return GameResult.WIN;
    }
    else
    {
      _draws++;
      return GameResult.DRAW;
    }
  }

  GameNode _getNextChild()
  {
    return _children.reduce((gn1, gn2)
    => gn1.childNextValue > gn2.childNextValue ? gn1 : gn2);
  }

  bool _shouldExpand()
  {
    return simulations >= 10;
  }

  Move getBestMove()
  {
    return _children
        .reduce((gn1, gn2)
    => gn1.simulations > gn2.simulations ? gn1 : gn2)
        ._move;
  }

  int get simulations
  {
    return _looses + _draws + _wins;
  }

  double get childNextValue
  {
    return simulations == 0 ? (_parent.simulations.roundToDouble()) : ((_wins / simulations) + sqrt(2) * sqrt(log(_parent.simulations) / simulations));
  }

  double get winRate
  {
    return _wins / simulations;
  }

  @override
  String toTree(String left, String left2, int maxDepth)
  {
    String out = left2 + '${(_children.isNotEmpty && maxDepth > 0) ? "┬" : "─"}${winRate.toStringAsFixed(2)}% ($_wins, $_draws, $_looses)${_move != null ? " (${_move.source.x} - ${_move.source.y}) => (${_move.target.x} - ${_move.target.y})" : ""}';
    if (maxDepth > 0)
    {
      for (int c = 0; c < _children.length; c++)
      {
        var notLast = c < _children.length - 1;
        out += "\n$left${notLast ? "├" : "└"}─${_children[c].toTree(left + "${notLast ? "│" : " "} ", left2 + "", maxDepth - 1)}";
      }
    }
    return out;
  }
}