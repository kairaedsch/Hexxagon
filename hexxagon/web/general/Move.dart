import '../general/TilePosition.dart';
import 'package:dartson/dartson.dart';

@Entity()
class Move
{
  TilePosition source;
  TilePosition target;
  String kindOf;

  Move();
  Move.normal(this.source, this.target, this.kindOf);
}