import 'Board.dart';
import 'dart:math';

class TilePosition
{
  static final List<List<int>> neighbourDeltasOdd = [[0, -2], [1, -1], [1, 1], [0, 2], [0, 1], [0, -1]];
  static final List<List<int>> neighbourDeltasEven = [[0, -2], [0, -1], [0, 1], [0, 2], [-1, 1], [-1, -1]];

  static final List<List<int>> neighbourSecondRingDeltasOdd = [[0, -4], [1, -3], [1, -2], [1, 0], [1, 2], [1, 3], [0, 4], [0, 3], [-1, 2], [-1, 0], [-1, -2], [0, -3]];
  static final List<List<int>> neighbourSecondRingDeltasEven = [[0, -4], [0, -3], [1, -2], [1, 0], [1, 2], [0, 3], [0, 4], [-1, 3], [-1, 2], [-1, 0], [-1, -2], [-1, -3]];

  List<List<int>> get neighbourDeltas
  {
    return y.isEven ? neighbourDeltasEven : neighbourDeltasOdd;
  }

  List<List<int>> get neighbourSecondRing
  {
    return y.isEven ? neighbourSecondRingDeltasEven : neighbourSecondRingDeltasOdd;
  }

  void forEachNeighbour(void consumer(TilePosition neighbour))
  {
    for (List<int> neighbourDelta in neighbourDeltas)
    {
      TilePosition neighbour = TilePosition.get(neighbourDelta[0] + x, neighbourDelta[1] + y);
      consumer(neighbour);
    }
  }

  void forEachValidNeighbour(Board board, void consumer(TilePosition neighbour))
  {
    forEachNeighbour((neighbour)
    {
      if (neighbour.isValid(board.width, board.height))
      {
        consumer(neighbour);
      }
    });
  }

  void forEachValidNeighbourSecondRing(Board board, void consumer(TilePosition neighbour))
  {
    for (List<int> neighbourDelta in neighbourSecondRing)
    {
      TilePosition neighbour = TilePosition.get(neighbourDelta[0] + x, neighbourDelta[1] + y);
      if (neighbour.isValid(board.width, board.height))
      {
        consumer(neighbour);
      }
    }
  }

  static TilePosition get(int x, int y)
  {
    return new TilePosition(x, y);
  }

  final int _x, _y;

  int get x
  => _x;

  int get y
  => _y;

  TilePosition(this._x, this._y);

  int getMaxDistanceTo(TilePosition other)
  {
    int dy = (other.y - y).abs();
    int dx = (other.x - x).abs();
    if (dy.isEven)
    {
      var xGo = dx * 2;
      var yGo = (dy / 2).floor() - dx;
      return xGo + max(yGo, 0);
    }
    else
    {
      int minDistance = 1000;
      for (List<int> neighbourDelta in neighbourDeltas)
      {
        if (neighbourDelta[1].isOdd)
        {
          TilePosition position = TilePosition.get(neighbourDelta[0] + x, neighbourDelta[1] + y);
          int distance = position.getMaxDistanceTo(other);
          if (distance < minDistance)
          {
            minDistance = distance;
          }
        }
      }
      return minDistance + 1;
    }
  }

  bool equals(TilePosition position)
  {
    return x == position.x && position.y == y;
  }

  bool isValid(int width, int height)
  {
    return x >= 0 && y >= 0 && x < width && y < height;
  }

  TilePosition next(int width, int height)
  {
    return TilePosition.get((x + 1) % width, ((x + 1) == width) ? ((y + 1) % height) : y);
  }

  @override
  bool operator ==(Object other)
  =>
      identical(this, other) ||
          other is TilePosition &&
              runtimeType == other.runtimeType &&
              _x == other._x &&
              _y == other._y;

  @override
  int get hashCode
  =>
      _x.hashCode ^
      _y.hashCode;

}