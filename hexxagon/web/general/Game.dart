import 'package:optional/optional.dart';

import 'Board.dart';
import 'Move.dart';
import 'Player.dart';
import 'TilePosition.dart';
import 'TileType.dart';

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
    changeListener = ()
    => {};
  }

  void next()
  {
    if (!isOver)
    {
      currentPlayer.move(_board, move);
    }
  }

  void move(Move move)
  {
    _board.move(move.source, move.target);
    _history.add(move);
    changeListener();
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

  bool get isOver
  => _board.isOver;

  Map<String, String> getStatsOf(int player)
  {
    return _board.getStatsOf(player);
  }

  Player<Board> getPlayer(int player)
  {
    if (player == TileType.PLAYER_ONE)
    {
      return _playerOne;
    }
    else if (player == TileType.PLAYER_TWO)
    {
      return _playerTwo;
    }
    else
    {
      throw new Exception("ERROR");
    }
  }

  int get betterPlayer => _board.betterPlayer;
}