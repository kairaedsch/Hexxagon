import 'dart:collection';
import 'dart:math';

import '../general/Array2D.dart';
import '../general/Board.dart';
import '../general/Move.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'GameResult.dart';

class Hexxagon extends Board
{
  int _width, _height;

  int get width
  => _width;

  int get height
  => _height;

  Array2D _tiles;
  int _currentPlayer;

  Hexxagon(int size)
  {
    _width = size + 1;
    _height = (size * 2 + 1) * 2;

    _tiles = new Array2D(_width, _height, TileType.EMPTY);
    _currentPlayer = TileType.PLAYER_ONE;

    TilePosition center = TilePosition.get((_width / 2).floor(), (_height / 2).floor());
    for (int x = 0; x < _width; x++)
    {
      for (int y = 0; y < _height; y++)
      {
        TilePosition pos = TilePosition.get(x, y);
        var distance = center.getMaxDistanceTo(pos);
        if (distance > size)
        {
          _set(pos, TileType.OUT_OF_FIELD);
        }
      }
    }

    setStartTiles(size, center, 0, TileType.PLAYER_ONE);
    setStartTiles(size, center, 1, TileType.PLAYER_TWO);
    setStartTiles(size, center, 2, TileType.PLAYER_ONE);
    setStartTiles(size, center, 3, TileType.PLAYER_TWO);
    setStartTiles(size, center, 4, TileType.PLAYER_ONE);
    setStartTiles(size, center, 5, TileType.PLAYER_TWO);

    setStartTiles(1, center, 0, TileType.FORBIDDEN);
    setStartTiles(1, center, 2, TileType.FORBIDDEN);
    setStartTiles(1, center, 4, TileType.FORBIDDEN);
  }

  void setStartTiles(int size, TilePosition center, int direction, int tile) {
    TilePosition toTarget = center;
    for(int i = 0; i < size; i++)
    {
      List<List<int>> neighbourDeltas = toTarget.y.isEven ? TilePosition.neighbourDeltasEven : TilePosition.neighbourDeltasOdd;
      toTarget = new TilePosition(toTarget.x + neighbourDeltas[direction][0], toTarget.y + neighbourDeltas[direction][1]);
    }
    _set(toTarget, tile);
  }

  Hexxagon.clone(Hexxagon hexxagon) {
    _width = hexxagon._width;
    _height = hexxagon._height;

    _tiles = new Array2D.empty(_width, _height);
    for (int x = 0; x < _width; x++)
    {
      for (int y = 0; y < _height; y++)
      {
        TilePosition pos = TilePosition.get(x, y);
        _tiles[x][y] = hexxagon.get(pos);
      }
    }
    _currentPlayer = hexxagon.currentPlayer;
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
      if (position.isValid(_width, _height) && get(position) == notCurrentPlayer)
      {
        _set(position, _currentPlayer);
      }
    }

    _currentPlayer = notCurrentPlayer;
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
    _getPossibleCopyMoves(from, possibleMoves.add);
    _getPossibleJumpMoves(from, possibleMoves.add);
    return possibleMoves;
  }

  List<Move> getAllPossibleMoves()
  {
    Map<TilePosition, Move> possibleMoves = new HashMap<TilePosition, Move>();
    for (int x = 0; x < _width; x++)
    {
      for (int y = 0; y < _height; y++)
      {
        TilePosition from = TilePosition.get(x, y);
        if (get(from) == _currentPlayer)
        {
          _getPossibleCopyMoves(from, (move){
            possibleMoves[move.target] = move;
          });
          _getPossibleJumpMoves(from, (move){
            possibleMoves.putIfAbsent(move.target, () => move);
          });
        }
      }
    }
    return possibleMoves.values.toList(growable: false);
  }

  void _getPossibleCopyMoves(TilePosition from, Function f)
  {
    if (get(from) != _currentPlayer)
    {
      return;
    }
    for (List<int> neighbourDelta in from.y.isEven ? TilePosition.neighbourDeltasEven : TilePosition.neighbourDeltasOdd)
    {
      TilePosition to = TilePosition.get(neighbourDelta[0] + from.x, neighbourDelta[1] + from.y);
      if (to.isValid(_width, _height) && get(to) == TileType.EMPTY)
      {
        f(new Move(from, to, "copy"));
      }
    }
  }

  void _getPossibleJumpMoves(TilePosition from, Function f)
  {
    if (get(from) != _currentPlayer)
    {
      return;
    }
    for (List<int> neighbourDelta in from.y.isEven ? TilePosition.neighbourSecondRingDeltasEven : TilePosition.neighbourSecondRingDeltasOdd)
    {
      TilePosition to = TilePosition.get(neighbourDelta[0] + from.x, neighbourDelta[1] + from.y);
      if (to.isValid(_width, _height) && get(to) == TileType.EMPTY)
      {
        f(new Move(from, to, "jump"));
      }
    }
    return;
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

  @override
  int get(TilePosition position)
  {
    return _tiles.array[position.x][position.y];
  }

  @override
  int get currentPlayer => _currentPlayer;

  @override
  int get notCurrentPlayer => (_currentPlayer == TileType.PLAYER_ONE ? TileType.PLAYER_TWO : TileType.PLAYER_ONE);

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

  GameResult getResult(int player)
  {
    int betterPlayer = this.betterPlayer;
    if (betterPlayer == player)
    {
      return GameResult.WIN;
    }
    else if (betterPlayer == TileType.EMPTY)
    {
      return GameResult.DRAW;
    }
    else
    {
      return GameResult.LOST;
    }
  }

  int countTilesOfType(int player) {
    int count = 0;
    for (int x = 0; x < _width; x++)
    {
      for (int y = 0; y < _height; y++)
      {
        int type = get(TilePosition.get(x, y));
        if (type == player)
        {
          count++;
        }
      }
    }
    return count;
  }
}