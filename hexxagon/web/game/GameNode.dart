import '../general/Move.dart';
import 'GameResult.dart';
import 'Hexxagon.dart';
import 'dart:math';

class GameNode
{
  List<GameNode> _children;

  Hexxagon _board;
  Move _move;
  int _looses;
  int _draws;
  int _wins;
  int _player;

  GameNode(this._board, this._move, this._player)
  {
    _looses = 0;
    _draws = 0;
    _wins = 0;
    _children = [];
  }

  GameResult playRandom()
  {
    GameResult result;
    if (!_children.isEmpty)
    {
      GameNode bestChild = _getNextChild();
      result = bestChild.playRandom();
    }
    else if (_shouldExpand())
    {
      List<Move> possibleMoves = _board.getAllPossibleMoves();
      if (possibleMoves.isEmpty)
      {
        result = _board.getResult(_player);
      }
      else
      {
        for (Move move in possibleMoves)
        {
          Hexxagon childBoard = new Hexxagon.clone(_board);
          childBoard.move(move.source, move.target);
          _children.add(new GameNode(childBoard, move, _player));
        }
        GameNode bestChild = _getNextChild();
        result = bestChild.playRandom();
      }
    }
    else
    {
      Random rng = new Random();
      Hexxagon clone = new Hexxagon.clone(_board);
      Move move;
      while ((move = clone.getRandomMove(rng)) != null)
      {
        clone.move(move.source, move.target);
      }
      result = clone.getResult(_player);
    }

    if (result == GameResult.WIN)
    {
      _wins++;
    }
    else if (result == GameResult.LOST)
    {
      _looses++;
    }
    else
    {
      _draws++;
    }
    return result;
  }

  GameNode _getNextChild()
  {
    Random rng = new Random();
    return _children[rng.nextInt(_children.length)];
  }

  bool _shouldExpand()
  {
    return value > 10;
  }

  Move getBestMove()
  {
    return _children.reduce((gn1, gn2) => gn1.winRate > gn2.winRate ? gn1 : gn2)._move;
  }

  int get value
  {
    return _looses + _draws + _wins;
  }

  double get winRate
  {
    return _wins / _looses;
  }
}