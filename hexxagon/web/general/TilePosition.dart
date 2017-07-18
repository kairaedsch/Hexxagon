import 'Board.dart';
import 'dart:math';

/// The position of a tile on a board.
class TilePosition
{
  /// Delta-values to be added to a odd TilePosition to get all direct neighbours of a TilePosition.
  static final List<List<int>> neighbourDeltasOdd = [[0, -2], [1, -1], [1, 1], [0, 2], [0, 1], [0, -1]];

  /// Delta-values to be added to a even TilePosition to get all direct neighbours of a TilePosition.
  static final List<List<int>> neighbourDeltasEven = [[0, -2], [0, -1], [0, 1], [0, 2], [-1, 1], [-1, -1]];

  /// Delta-values to be added to a odd TilePosition to get all tiles with a distance of 1 to a TilePosition.
  static final List<List<int>> neighbourSecondRingDeltasOdd = [[0, -4], [1, -3], [1, -2], [1, 0], [1, 2], [1, 3], [0, 4], [0, 3], [-1, 2], [-1, 0], [-1, -2], [0, -3]];

  /// Delta-values to be added to a even TilePosition to get all tiles with a distance of 1 to a TilePosition.
  static final List<List<int>> neighbourSecondRingDeltasEven = [[0, -4], [0, -3], [1, -2], [1, 0], [1, 2], [0, 3], [0, 4], [-1, 3], [-1, 2], [-1, 0], [-1, -2], [-1, -3]];

  /// Calls the given consumer for each TilePosition on the given board.
  static void forEachOnBoard(Board board, void consumer(TilePosition tileposition))
  {
    for (int x = 0; x < board.width; x++)
    {
      for (int y = 0; y < board.height; y++)
      {
        TilePosition pos = TilePosition.get(x, y);
        consumer(pos);
      }
    }
  }

  /// TODO Calls the given consumer for each TilePosition on the given board.
  static void forEachOnBoardWhileTrue(Board board, bool consumer(TilePosition tileposition))
  {
    for (int x = 0; x < board.width; x++)
    {
      for (int y = 0; y < board.height; y++)
      {
        TilePosition pos = TilePosition.get(x, y);
        bool con = consumer(pos);
        if (!con)
        {
          return;
        }
      }
    }
  }

  /// A new TilePosition at the given position.
  static TilePosition get(int x, int y)
  {
    return new TilePosition(x, y);
  }

  /// The X-position of this TilePosition.
  final int _x;

  /// The Y-position of this TilePosition.
  final int _y;

  /// The X-position of this TilePosition.
  int get x => _x;

  /// The Y-position of this TilePosition.
  int get y => _y;

  /// Create a new TilePosition at the given position.
  TilePosition(this._x, this._y);

  /// Delta-values to be added to this TilePosition to get all direct neighbours.
  List<List<int>> get neighbourDeltas
  {
    return y.isEven ? neighbourDeltasEven : neighbourDeltasOdd;
  }

  /// Delta-values to be added to this TilePosition to get all tiles with a distance of 1 to this TilePosition.
  List<List<int>> get neighbourSecondRing
  {
    return y.isEven ? neighbourSecondRingDeltasEven : neighbourSecondRingDeltasOdd;
  }

  /// Calls the given consumer method for all direct neighbours of this TilePosition.
  void forEachNeighbour(Board board, void consumer(TilePosition neighbour))
  {
    for (List<int> neighbourDelta in neighbourDeltas)
    {
      TilePosition position = TilePosition.get(neighbourDelta[0] + x, neighbourDelta[1] + y);
      if (position.isValid(board))
      {
        consumer(position);
      }
    }
  }

  /// Calls the given consumer method for all tiles with a distance of 1 to this TilePosition.
  void forEachNeighbourSecondRing(Board board, void consumer(TilePosition neighbour))
  {
    for (List<int> neighbourDelta in neighbourSecondRing)
    {
      TilePosition position = TilePosition.get(neighbourDelta[0] + x, neighbourDelta[1] + y);
      if (position.isValid(board))
      {
        consumer(position);
      }
    }
  }

  /// The distance of this TilePosition to the given TilePosition.
  int getDistanceTo(TilePosition other)
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
          int distance = position.getDistanceTo(other);
          if (distance < minDistance)
          {
            minDistance = distance;
          }
        }
      }
      return minDistance + 1;
    }
  }

  /// If this TilePosition is equal to the give one.
  bool equals(TilePosition other)
  {
    return x == other.x && other.y == y;
  }

  /// If this TilePosition is on the field of the given board.
  bool isValid(Board board)
  {
    return x >= 0 && y >= 0 && x < board.width && y < board.height;
  }

  /// The right neighbour TilePosition to this TilePosition or, if the right neighbour does not exist, the first TilePosition in the row under the row of this TilePosition.
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