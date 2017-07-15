import 'Board.dart';
import 'TilePosition.dart';

/// A possible Move on a Board.
abstract class Move<B extends Board>
{
  /// The TilePosition, where the tile to be moved lays.
  final TilePosition from;

  /// The TilePosition, where the tile will be moved, copied, or whatever the rules ove the board are.
  final TilePosition to;

  Move(this.from, this.to);

  /// The kind of this move.
  ///
  /// For example: "jump" or "copy"
  String get kindOf;

  /// The TilePositions, which will be changed by this move combined with the kind of change.
  ///
  /// For example: {(1, 10): "jump", (2, 10): "switched"}
  Map<TilePosition, String> getChanges(B boardBeforeMove);
}