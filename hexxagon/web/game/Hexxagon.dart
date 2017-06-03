import '../general/Array2D.dart';
import '../general/Board.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import '../general/Move.dart';
import 'dart:math';

class Hexxagon extends Board
{
  int _width, _height;
  int get width => _width;
  int get height => _height;

  Array2D _tiles;
  int _currentPlayer;

  Hexxagon();

  Hexxagon.normal(this._width, this._height)
  {
    _tiles = new Array2D(_width, _height, TileType.EMPTY);
    _currentPlayer = TileType.PLAYER_ONE;

    _set(TilePosition.get(0, 0), TileType.PLAYER_ONE);
    _set(TilePosition.get(_width - 1, _height - 1), TileType.PLAYER_ONE);

    _set(TilePosition.get(_width - 1, 0), TileType.PLAYER_TWO);
    _set(TilePosition.get(0, _height - 1), TileType.PLAYER_TWO);

    TilePosition pos = TilePosition.get((_width / 2).floor() - 1, (_height / 2).floor());
    _set(pos, TileType.FORBIDDEN);
  }

  Hexxagon.clone(Hexxagon hexxagon) {
    _width = hexxagon._width;
    _height = hexxagon._height;
    _tiles = new Array2D(_width, _height, TileType.EMPTY);
    for (int x = 0; x < _width; x++)
    {
      for (int y = 0; y < _height; y++)
      {
        TilePosition pos = TilePosition.get(x, y);
        _tiles[x][y] = hexxagon.get(pos);
      }
    }
    _currentPlayer = hexxagon.getCurrentPlayer();
  }

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

    for (List<int> neighbourDelta in to.y.isEven ? TilePosition.neighbourDeltasEven : TilePosition.neighbourDeltasOdd)
    {
      TilePosition position = TilePosition.get(neighbourDelta[0] + to.x, neighbourDelta[1] + to.y);
      if (position.isValid(_width, _height) && get(position) == getNotCurrentPlayer())
      {
        _set(position, _currentPlayer);
      }
    }

    _currentPlayer = getNotCurrentPlayer();
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

  void _set(TilePosition position, int type)
  {
    _tiles.array[position.x][position.y] = type;
  }

  @override
  List<Move> getPossibleMoves(TilePosition from)
  {
    if (get(from) != _currentPlayer)
    {
      return new List(0);
    }
    List<Move> possibleMoves = [];
    for (List<int> neighbourDelta in from.y.isEven ? TilePosition.neighbourDeltasEven : TilePosition.neighbourDeltasOdd)
    {
      TilePosition to = TilePosition.get(neighbourDelta[0] + from.x, neighbourDelta[1] + from.y);
      if (to.isValid(_width, _height) && get(to) == TileType.EMPTY)
      {
        possibleMoves.add(new Move(from, to, "copy"));
      }
    }
    for (List<int> neighbourDelta in from.y.isEven ? TilePosition.neighbourSecondRingDeltasEven : TilePosition.neighbourSecondRingDeltasOdd)
    {
      TilePosition to = TilePosition.get(neighbourDelta[0] + from.x, neighbourDelta[1] + from.y);
      if (to.isValid(_width, _height) && get(to) == TileType.EMPTY)
      {
        possibleMoves.add(new Move(from, to, "jump"));
      }
    }
    return possibleMoves;
  }

  @override
  bool couldBeMoved(TilePosition position)
  {
    return get(position) == _currentPlayer;
  }

  Move getRandomMove(Random rng)
  {
    TilePosition start = TilePosition.get(rng.nextInt(_width), rng.nextInt(_height));
    TilePosition loop = start;

    do
    {
      if (get(loop) == _currentPlayer)
      {
        List<Move> possibleMoves = getPossibleMoves(loop);
        if (possibleMoves.isNotEmpty)
        {
          return possibleMoves[rng.nextInt(possibleMoves.length)];
        }
      }
      loop = loop.next(_width, _height);
    }
    while (!loop.equals(start));

    return null;
  }

  List<TilePosition> canBeMoved()
  {
    List<TilePosition> possibleMoves = [];
    for (int x = 0; x < _width; x++)
    {
      for (int y = 0; y < _height; y++)
      {
        TilePosition from = TilePosition.get(x, y);
        if (getPossibleMoves(from).isNotEmpty)
        {
          possibleMoves.add(from);
        }
      }
    }
    return possibleMoves;
  }

  @override
  int get(TilePosition position)
  {
    return _tiles.array[position.x][position.y];
  }

  @override
  int getCurrentPlayer()
  {
    return _currentPlayer;
  }

  @override
  int getNotCurrentPlayer()
  {
    return (_currentPlayer == TileType.PLAYER_ONE ? TileType.PLAYER_TWO : TileType.PLAYER_ONE);
  }

  @override
  bool get isOver
  {
    for (int x = 0; x < _width; x++)
    {
      for (int y = 0; y < _height; y++)
      {
        TilePosition from = TilePosition.get(x, y);
        if (getPossibleMoves(from).isNotEmpty)
        {
          return false;
        }
      }
    }
    return true;
  }

  @override
  int get betterPlayer
  {
    int playerOne = 0,
        playerTwo = 0;
    for (int x = 0; x < _width; x++)
    {
      for (int y = 0; y < _height; y++)
      {
        int type = get(TilePosition.get(x, y));
        if (type == TileType.PLAYER_ONE)
        {
          playerOne++;
        }
        else if (type == TileType.PLAYER_TWO)
        {
          playerTwo++;
        }
      }
    }
    return playerOne > playerTwo ? TileType.PLAYER_ONE : playerOne < playerTwo ? TileType.PLAYER_TWO : TileType.EMPTY;
  }
}