import '../general/Array2D.dart';
import '../general/Board.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import '../general/Move.dart';

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

    TilePosition pos = new TilePosition((_width / 2).floor() - 1, (_height / 2).floor());
    _set(pos, TileType.FORBIDDEN);
  }

  int get width
  => _width;

  int get height
  => _height;

  @override
  void move(TileType player, TilePosition from, TilePosition to)
  {
    if (!isVaidMove(player, from, to))
    {
      throw new Exception("Invalid Move");
    }

    _set(to, _currentPlayer);
    int distance = from.getMaxDistanceTo(to);
    if (distance == 2)
    {
      _set(from, TileType.EMPTY);
    }

    for (List<int> neighbourDelta in to.y.isEven ? TilePosition.neighbourDeltasEven : TilePosition.neighbourDeltasOdd)
    {
      TilePosition position = new TilePosition(neighbourDelta[0] + to.x, neighbourDelta[1] + to.y);
      if (position.isValid(_width, _height) && get(position) == getNotCurrentPlayer())
      {
        _set(position, _currentPlayer);
      }
    }

    _currentPlayer = getNotCurrentPlayer();
  }

  bool isVaidMove(TileType player, TilePosition from, TilePosition to)
  {
    if (player != _currentPlayer || get(from) != _currentPlayer || get(to) != TileType.EMPTY)
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
  List<Move> getPossibleMoves(TileType player, TilePosition from)
  {
    List<Move> possibleMoves = [];
    for (int x = 0; x < _width; x++)
    {
      for (int y = 0; y < _height; y++)
      {
        TilePosition to = new TilePosition(x, y);
        if (isVaidMove(player, from, to))
        {
          possibleMoves.add(
              new Move(from, to, from.getMaxDistanceTo(to) == 1 ? "copy" : "jump"));
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
  List<TilePosition> canBeMoved(TileType player)
  {
    List<TilePosition> possibleMoves = [];
    for (int x = 0; x < _width; x++)
    {
      for (int y = 0; y < _height; y++)
      {
        TilePosition from = new TilePosition(x, y);
        if (getPossibleMoves(player, from).isNotEmpty)
        {
          possibleMoves.add(from);
        }
      }
    }
    return possibleMoves;
  }

  @override
  TileType get(TilePosition position)
  {
    return _tiles.array[position.x][position.y];
  }

  @override
  TileType getCurrentPlayer()
  {
    return _currentPlayer;
  }

  @override
  TileType getNotCurrentPlayer()
  {
    return (_currentPlayer == TileType.PLAYER_ONE ? TileType.PLAYER_TWO : TileType.PLAYER_ONE);
  }
}