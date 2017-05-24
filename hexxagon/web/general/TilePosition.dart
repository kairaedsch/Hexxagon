import 'dart:math';

class TilePosition
{
  static final List<List<int>> neighbourDeltasOdd = [[0, -2], [1, -1], [1, 1], [0, 2], [0, -1], [0, 1]];
  static final List<List<int>> neighbourDeltasEven = [[0, -2], [0, -1], [0, 1], [0, 2], [-1, 1], [-1, -1]];
  final int x, y;

  TilePosition(this.x, this.y);

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
      for (List<int> neighbourDelta in y.isEven ? TilePosition.neighbourDeltasEven : TilePosition.neighbourDeltasOdd)
      {
        if (neighbourDelta[1].isOdd)
        {
          TilePosition position = new TilePosition(neighbourDelta[0] + x, neighbourDelta[1] + y);
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
}