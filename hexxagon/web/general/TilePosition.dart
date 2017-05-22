import 'dart:math';

class TilePosition
{
  final int x, y;

  TilePosition(this.x, this.y);

  int getMaxDistanceTo(TilePosition other)
  {
    return max((x - other.x).abs(), (y - other.y).abs());
  }

  bool equals(TilePosition position) {
    return x == position.x && position.y == y;
  }
}