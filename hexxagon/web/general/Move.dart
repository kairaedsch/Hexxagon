import '../general/TilePosition.dart';

class Move
{
  TilePosition source;
  TilePosition target;
  String kindOf;

  Move(this.source, this.target, this.kindOf);
}