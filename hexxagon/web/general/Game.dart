import 'Move.dart';
import 'Board.dart';
import 'TilePosition.dart';
import 'TileType.dart';
import 'package:optional/optional.dart';

class Game
{
  Board _board;
  Board get board => _board;

  List<Move> _history;
  Optional<Move> get lastMove
  => _history.isNotEmpty ? new Optional.of(_history.last) : new Optional.empty();

  int get width
  => _board.width;

  int get height
  => _board.height;

  Game(this._board)
  {
    _history = [];
  }

  void move(Move move)
  {
    _board.move(_board.getCurrentPlayer(), move.source, move.target);
    _history.add(move);
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