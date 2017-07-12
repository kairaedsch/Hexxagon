import 'Board.dart';
import 'TilePosition.dart';

abstract class Move<B extends Board>
{
  final TilePosition source;
  final TilePosition target;
  String get kindOf;

  Move(this.source, this.target);

  Map<TilePosition, String> getChanges(B boardBeforeMove);
}