import 'TilePosition.dart';
import 'package:optional/optional.dart';

import 'Board.dart';
import 'Move.dart';
import 'Intelligence.dart';
import 'TileType.dart';
import 'package:tuple/tuple.dart';

/// A Game of two intelligences who play on a board.
class Game<B extends Board<B>>
{
  /// The board on which will be played.
  B _board;

  /// The board on which will be played.
  B get board => _board;

  /// The changeListener which will be triggered, if the a intelligence does a move.
  Function changeListener;

  /// The first intelligence who plays on this board.
  Intelligence _IntelligenceOne;

  /// The second intelligence who plays on this board.
  Intelligence _intelligenceTwo;

  /// The current intelligence who has to do a move.
  Intelligence get currentIntelligence => _board.currentPlayer == TileType.PLAYER_ONE ? _IntelligenceOne : _intelligenceTwo;

  /// Not the current intelligence.
  Intelligence get notCurrentIntelligence => _board.currentPlayer == TileType.PLAYER_ONE ? _intelligenceTwo : _IntelligenceOne;

  /// The history of board states and moves made by the intelligences.
  List<Tuple2<B, Move<B>>> _history;

  /// Creates a new Game with a Board and two intelligences.
  Game(this._board, this._IntelligenceOne, this._intelligenceTwo)
  {
    _history = [];
    changeListener = () => {};
  }

  /// Changes on the board which were done by the last move of a intelligence.
  Optional<Map<TilePosition, String>> get lastMoveChanges
  {
    if (_history.isEmpty)
    {
      return new Optional.empty();
    }
    return new Optional.of(_history.last.item2.getChanges(_history.last.item1));
  }

  /// The intelligence which plays the given player.
  Intelligence<Board> getIntelligence(TileType player)
  {
    if (player == TileType.PLAYER_ONE)
    {
      return _IntelligenceOne;
    }
    else if (player == TileType.PLAYER_TWO)
    {
      return _intelligenceTwo;
    }
    else
    {
      throw new Exception("ERROR: Tiletype is not a Player: ${TileTypes.toName(player)}");
    }
  }

  /// Commands the current intelligence to make a move.
  void next()
  {
    if (!_board.isOver)
    {
      currentIntelligence.move(_board, move);
    }
  }

  /// Makes the given move on the board.
  void move(Move move)
  {
    _history.add(new Tuple2(board.cloneIt(), move));
    _board.move(move);
    changeListener();
  }

  /// The score of the given player.
  int scoreOfPlayer(TileType player) => _board.scoreOfPlayer(player);
}