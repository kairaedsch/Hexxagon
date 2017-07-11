import 'TilePosition.dart';
import 'package:optional/optional.dart';

import 'Board.dart';
import 'Move.dart';
import 'Intelligence.dart';
import 'TileType.dart';

class Game<B extends Board<B>>
{
  B _board;

  B get board
  => _board;

  Optional<B> _lastBoard;

  Function changeListener;

  Intelligence _IntelligenceOne, _intelligenceTwo;

  Intelligence get currentIntelligence
  => _board.currentPlayer == TileType.PLAYER_ONE ? _IntelligenceOne : _intelligenceTwo;

  Intelligence get notCurrentIntelligence
  => _board.currentPlayer == TileType.PLAYER_ONE ? _intelligenceTwo : _IntelligenceOne;

  List<Move<B>> _history;

  Optional<Map<TilePosition, String>> get lastMoveChanges
  {
    if (!_lastBoard.isPresent || _history.isEmpty)
    {
      return new Optional.empty();
    }
    return new Optional.of(_history.last.getChanges(_lastBoard.value));
  }

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

  Game(this._board, this._IntelligenceOne, this._intelligenceTwo)
  {
    _history = [];
    _lastBoard = new Optional.empty();
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
    _lastBoard = new Optional.of(_board.cloneIt());
    _board.move(move.source, move.target);
    _history.add(move);
    changeListener();
  }

  int countTilesOfType(TileType player)
  => _board.countTilesOfType(player);
}