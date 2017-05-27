import 'Move.dart';
import 'Board.dart';
import 'Player.dart';
import 'TilePosition.dart';
import 'TileType.dart';
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
    next();
  }

  void next()
  {
    currentPlayer.move(_board, board.getCurrentPlayer(), move);
  }

  void move(Move move)
  {
    _board.move(_board.getCurrentPlayer(), move.source, move.target);
    _history.add(move);
    changeListener();
    next();
  }

  List<Move> getPossibleMoves(TileType player, TilePosition tilePosition)
  {
    return _board.getPossibleMoves(player, tilePosition);
  }

  bool couldBeMoved(TilePosition tilePosition)
  {
    return _board.couldBeMoved(tilePosition);
  }

  TileType get(TilePosition tilePosition)
  {
    return _board.get(tilePosition);
  }

  TileType getCurrentPlayer()
  {
    return _board.getCurrentPlayer();
  }

  TileType getNotCurrentPlayer()
  {
    return _board.getNotCurrentPlayer();
  }
}