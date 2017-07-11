import 'Board.dart';
import 'TilePosition.dart';

abstract class Move<B extends Board>
{
  final TilePosition source;
  final TilePosition target;
  final String kindOf;

  Move(this.source, this.target, this.kindOf);

  Map<TilePosition, String> getChanges(B boardBeforeMove);
}