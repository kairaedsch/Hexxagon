import '../general/Move.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'Hexxagon.dart';

class HexxagonMove extends Move<Hexxagon>
{
  HexxagonMove(TilePosition source, TilePosition target, String kindOf) : super(source, target, kindOf);

  Map<TilePosition, String> getChanges(Hexxagon hexxagonBeforeMove)
  {
    Map<TilePosition, String> changes = new Map<TilePosition, String>();
    List<String> arrows = ["↑",  "↗", "↘", "↓", "↙", "↖"];
    changes[source] = "↘";
    changes[target] = "o";
    var iterator = arrows.iterator;
    target.forEachNeighbour((neighbour)
    {
      iterator.moveNext();
      if (neighbour.isValid(hexxagonBeforeMove.width, hexxagonBeforeMove.height))
      {
        TileType neighbourType = hexxagonBeforeMove.get(neighbour);
        if (neighbourType == hexxagonBeforeMove.notCurrentPlayer)
        {
          changes[neighbour] = iterator.current;
        }
      }

    });
    return changes;
  }
}