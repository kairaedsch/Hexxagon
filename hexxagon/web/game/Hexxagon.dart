import '../general/Array2D.dart';
import '../general/Board.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import '../gui/Move.dart';

class Hexxagon extends Board
{
  int _width, _height;
  Array2D<TileType> _tiles;
  TileType _currentPlayer;

  Hexxagon(this._width, this._height)
  {
    _tiles = new Array2D(_width, _height, TileType.EMPTY);
    _currentPlayer = TileType.PLAYER_ONE;

    _set(new TilePosition(0, 0), TileType.PLAYER_ONE);
    _set(new TilePosition(_width - 1, _height - 1), TileType.PLAYER_ONE);

    _set(new TilePosition(_width - 1, 0), TileType.PLAYER_TWO);
    _set(new TilePosition(0, _height - 1), TileType.PLAYER_TWO);
  }

  int get width => _width;
  int get height => _height;

  @override
  void move(TilePosition from, TilePosition to)
  {
    if (!isVaidMove(from, to))
    {
      throw new Exception("Invalid Move");
    }

    _set(to, _currentPlayer);
    int distance = from.getMaxDistanceTo(to);
    if (distance == 2)
    {
      _set(from, TileType.EMPTY);
    }

    for (int x = -1; x <= 1; x++)
    {
      for (int y = -1; y <= 1; y++)
      {
        if (x != 0 || y != 0)
        {
          TilePosition position = new TilePosition(x, y);
          if (get(position) != _currentPlayer &&
              get(position) != TileType.EMPTY)
          {
            _set(position, _currentPlayer);
          }
        }
      }
    }
  }

  bool isVaidMove(TilePosition from, TilePosition to)
  {
    if (get(from) != _currentPlayer || get(to) != TileType.EMPTY)
    {
      return false;
    }

    int distance = from.getMaxDistanceTo(to);
    if (distance != 1 && distance != 2)
    {
      return false;
    }

    return true;
  }

  void _set(TilePosition position, TileType type)
  {
    _tiles.array[position.x][position.y] = type;
  }

  @override
  List<Move> getPossibleMoves(TilePosition from)
  {
    List<Move> possibleMoves = [];
    for (int x = 0; x < _width; x++)
    {
      for (int y = 0; y < _height; y++)
      {
        TilePosition to = new TilePosition(x, y);
        if (isVaidMove(from, to))
        {
          possibleMoves.add(
              new Move(to, from.getMaxDistanceTo(to) == 1 ? "copy" : "jump"));
        }
      }
    }
    return possibleMoves;
  }

  @override
  bool couldBeMoved(TilePosition position)
  {
    return get(position) == _currentPlayer;
  }

  @override
  TileType get(TilePosition position)
  {
    return _tiles.array[position.x][position.y];
  }
}