import '../general/Move.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'Hexxagon.dart';

class HexxagonMove extends Move<Hexxagon>
{
  HexxagonMove(TilePosition source, TilePosition target) : super(source, target);

  String get kindOf {
    switch(source.getMaxDistanceTo(target))
    {
      case 1: return "copy";
      case 2: return "jump";
      default: throw new Exception("Distance must be 1 or 2");
    }
  }

  Map<TilePosition, String> getChanges(Hexxagon hexxagonBeforeMove)
  {
    Map<TilePosition, String> changes = new Map<TilePosition, String>();
    changes[source] = kindOf;
    changes[target] = kindOf;
    target.forEachNeighbour(hexxagonBeforeMove, (neighbour)
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