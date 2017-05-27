import '../general/Board.dart';
import '../general/Game.dart';
import '../general/Move.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'package:optional/optional.dart';
import 'package:tuple/tuple.dart';

class GameGUI
{
  Game _game;
  Function changeListener;

  int get width
  => _game.width;

  int get height
  => _game.height;

  Optional<Tuple2<TilePosition, List<Move>>> _selectedPosition;

  TilePosition get selectedPosition
  => _selectedPosition.value.item1;

  List<Move> get possibleMoves
  => _selectedPosition.value.item2;

  bool get isSomethingSelected
  => _selectedPosition.isPresent;

  Optional<Move> get lastMove
  => _game.lastMove;

  GameGUI(this._game)
  {
    changeListener = () => {};
    _selectedPosition = new Optional.empty();
  }

  void select(TilePosition position)
  {
    if (_game.couldBeMoved(position) && (!isSomethingSelected || !position.equals(selectedPosition)))
    {
      _selectedPosition = new Optional.of(new Tuple2(position, _game.getPossibleMoves(_game.getCurrentPlayer(), position)));
      changeListener();
    }
    else
    {
      unselect();
    }
  }

  void unselect()
  {
    _selectedPosition = new Optional.empty();
    changeListener();
  }

  void move(Move move)
  {
    _game.move(move);
    unselect();
  }

  bool couldBeMoved(TilePosition tilePosition)
  {
    return _game.couldBeMoved(tilePosition);
  }

  TileType get(TilePosition tilePosition)
  {
    return _game.get(tilePosition);
  }

  TileType getCurrentPlayer()
  {
    return _game.getCurrentPlayer();
  }

  TileType getNotCurrentPlayer()
  {
    return _game.getNotCurrentPlayer();
  }
}