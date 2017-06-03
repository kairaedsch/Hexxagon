import 'Move.dart';
import 'Board.dart';
import 'Player.dart';
import 'TilePosition.dart';
import 'TileType.dart';
import 'dart:async';
import 'package:optional/optional.dart';

class Game<B extends Board>
{
  B _board;

  B get board
  => _board;

  Function changeListener;

  Player _playerOne, _playerTwo;

  Player get currentPlayer
  => _board.getCurrentPlayer() == TileType.PLAYER_ONE ? _playerOne : _playerTwo;

  List<Move> _history;

  Optional<Move> get lastMove
  => _history.isNotEmpty ? new Optional.of(_history.last) : new Optional.empty();

  int get width
  => _board.width;

  int get height
  => _board.height;

  Game(this._board, this._playerOne, this._playerTwo)
  {
    _history = [];
    changeListener = () => {};
    next();
  }

  void next()
  {
    currentPlayer.move(_board, move);
  }

  void move(Move move)
  {
    _board.move(move.source, move.target);
    _history.add(move);
    new Timer(new Duration(milliseconds: currentPlayer.isHuman ? 0 : 200), () {
      changeListener();
      new Timer(new Duration(milliseconds: currentPlayer.isHuman ? 0 : 200), next);
    });
  }

  List<Move> getPossibleMoves(TilePosition tilePosition)
  {
    return _board.getPossibleMoves(tilePosition);
  }

  bool couldBeMoved(TilePosition tilePosition)
  {
    return _board.couldBeMoved(tilePosition);
  }

  int get(TilePosition tilePosition)
  {
    return _board.get(tilePosition);
  }

  int getCurrentPlayer()
  {
    return _board.getCurrentPlayer();
  }

  int getNotCurrentPlayer()
  {
    return _board.getNotCurrentPlayer();
  }
}