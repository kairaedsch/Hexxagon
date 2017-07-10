import 'TilePosition.dart';

class Move
{
  final TilePosition source;
  final TilePosition target;
  final String kindOf;

  Move(this.source, this.target, this.kindOf);
}