import '../general/Move.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'Hexxagon.dart';

/// A possible Move on a Hexxagon Board
class HexxagonMove extends Move<Hexxagon>
{
  HexxagonMove(TilePosition source, TilePosition target) : super(source, target);

  @override
  String get kindOf {
    switch(from.getDistanceTo(to))
    {
      case 1: return "copy";
      case 2: return "jump";
      default: throw new Exception("Distance must be 1 or 2");
    }
  }

  @override
  Map<TilePosition, String> getChanges(Hexxagon hexxagonBeforeMove)
  {
    Map<TilePosition, String> changes = new Map<TilePosition, String>();
    changes[from] = kindOf;
    changes[to] = kindOf;
    to.forEachNeighbour(hexxagonBeforeMove, (neighbour)
    {
      TileType neighbourType = hexxagonBeforeMove.get(neighbour);
      if (neighbourType == hexxagonBeforeMove.notCurrentPlayer)
      {
        changes[neighbour] = "●";
      }
    });
    return changes;
  }
}