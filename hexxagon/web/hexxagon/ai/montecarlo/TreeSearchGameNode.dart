import '../MoveFinder.dart';
import '../random/RandomAI.dart';
import 'dart:math';

import '../../../general/Move.dart';
import '../../../general/GameResult.dart';
import '../../Hexxagon.dart';

/// GameNode for the Monte carlo tree search algorithm.
class TreeSearchGameNode
{
  /// Minimal amount of simulations on this node to expand it.
  static int minimumSimulationsToExpand = 10;

  /// Children of this node.
  List<TreeSearchGameNode> _children;

  /// Parent node of this node.
  TreeSearchGameNode _parent;

  /// The Hexxagon Board after the move in this node was made.
  Hexxagon _hexxagon;

  /// The move for this node.
  Move _move;

  /// Number of simulated losses for this move on this node or its children.
  int _looses;

  /// Number of simulated draws for this move on this node or its children.
  int _draws;

  /// Number of simulated wins for this move on this node or its children.
  int _wins;

  /// If this node is a leave.
  bool _isOver;

  /// Create an new GameNode which has a parent node.
  TreeSearchGameNode(this._parent, this._hexxagon, this._move)
  {
    _looses = 0;
    _draws = 0;
    _wins = 0;
    _children = [];
    _isOver = _hexxagon.isOver;
  }

  /// Create a new root GameNode with no parent.
  TreeSearchGameNode.root(this._hexxagon)
  {
    _looses = 0;
    _draws = 0;
    _wins = 0;
    _children = [];
    _parent = this;
    _move = null;
    _isOver = _hexxagon.isOver;
  }

  /// Plays a random game on this node or on one of its children and updates the wins/looses/draws values of all affected nodes. This method may also expand a node.
  GameResult playRandom()
  {
    GameResult result;

    // If the game is already over, check how it ended.
    if (_isOver)
    {
      result = _hexxagon.getResult(_hexxagon.notCurrentPlayer);
    }
    // Else if there are enough simulations on this node, select one child to playRandom.
    else if (simulations >= minimumSimulationsToExpand)
    {
      // Check if the children have to be generated first (expand).
      if (_children.isEmpty)
      {
        List<Move> possibleMoves = MoveFinder.getAllMovesOptimiseAll(_hexxagon);
        for (Move move in possibleMoves)
        {
          Hexxagon childBoard = new Hexxagon.clone(_hexxagon);
          childBoard.move(move);
          _children.add(new TreeSearchGameNode(this, childBoard, move));
        }
      }
      // Select the child with the best childNextValue to playRandom.
      TreeSearchGameNode bestChild = _children.reduce((gn1, gn2) => gn1.childNextValue > gn2.childNextValue ? gn1 : gn2);
      result = bestChild.playRandom();
    }
    // Otherwise play a random game on this node.
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

    // Evaluate the result and return the opposite to the parent.
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

  /// The best move so far.
  Move get bestMove =>
      _children
          .reduce((gn1, gn2) => gn1.simulations > gn2.simulations ? gn1 : gn2)
          ._move;

  /// Number of simulations on this node and its children.
  int get simulations => _looses + _draws + _wins;

  /// The value of a child, which is high for unexplored nodes with good win rates.
  double get childNextValue => simulations == 0 ? (_parent.simulations.roundToDouble()) : ((_wins / simulations) + sqrt(2) * sqrt(log(_parent.simulations) / simulations));

  /// The current win-rate of this node.
  double get winRate => _wins / simulations;

  /// Returns the tree as text format for debug purpose.
  String toTree(String left, String left2, int maxDepth)
  {
    String out = left2 +
        '${(_children.isNotEmpty && maxDepth > 0) ? "┬" : "─"}${(winRate * 100).toStringAsFixed(0)}% '
            '($_wins, $_draws, $_looses)${_move != null ? " (${_move.from.x} - ${_move.from.y}) => (${_move.to.x} - ${_move.to.y})" : ""}';
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