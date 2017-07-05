import 'package:optional/optional.dart';

import 'Board.dart';
import 'Move.dart';
import 'Intelligence.dart';
import 'TileType.dart';

class Game<B extends Board>
{
  B _board;

  B get board
  => _board;

  Function changeListener;

  Intelligence _IntelligenceOne, _intelligenceTwo;

  Intelligence get currentIntelligence
  => _board.currentPlayer == TileType.PLAYER_ONE ? _IntelligenceOne : _intelligenceTwo;

  Intelligence get notCurrentIntelligence
  => _board.currentPlayer == TileType.PLAYER_ONE ? _intelligenceTwo : _IntelligenceOne;

  List<Move> _history;

  Optional<Move> get lastMove
  => _history.isNotEmpty ? new Optional.of(_history.last) : new Optional.empty();

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
      throw new Exception("ERROR: Tiletype is not a Player: ${TileTypeToName(player)}");
    }
  }

  Game(this._board, this._IntelligenceOne, this._intelligenceTwo)
  {
    _history = [];
    changeListener = ()
    => {};
  }

  void next()
  {
    if (!_board.isOver)
    {
      currentIntelligence.move(_board, move);
    }
  }

  void move(Move move)
  {
    _board.move(move.source, move.target);
    _history.add(move);
    changeListener();
  }

  Map<String, String> getStatsOf(TileType player)
  {
    return _board.getStatsOf(player);
  }
}