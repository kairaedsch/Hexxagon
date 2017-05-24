import '../general/Board.dart';
import '../gui/Move.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'package:optional/optional.dart';

class BoardGUI
{
  Board _board;
  Function changeListener;

  int get width
  => _board.width;

  int get height
  => _board.height;

  Optional<TilePosition> _selectedPosition;

  TilePosition get selectedPosition
  => _selectedPosition.value;

  bool get isSomethingSelected
  => _selectedPosition.isPresent;

  Optional<List<Move>> _possibleMoves;

  List<Move> get possibleMoves
  => _possibleMoves.value;

  BoardGUI(this._board)
  {
    changeListener = () => {};
    unselect();
  }

  void select(TilePosition position)
  {
    if (_board.couldBeMoved(position) && (!isSomethingSelected || !position.equals(selectedPosition)))
    {
      _selectedPosition = new Optional.of(position);
      _possibleMoves = new Optional.of(_board.getPossibleMoves(_board.getCurrentPlayer(), position));
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
    _possibleMoves = new Optional.empty();
    changeListener();
  }

  void move(TilePosition to)
  {
    _board.move(_board.getCurrentPlayer(), selectedPosition, to);
    unselect();
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