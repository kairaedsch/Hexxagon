import '../../general/Move.dart';
import '../../general/TilePosition.dart';
import '../../general/TileType.dart';
import 'Hexxagon.dart';

/// The logical implementation of the two player Game Hexxagon which can undo moves by creating a history.
class HexxagonHistory extends Hexxagon
{
  /// The history of changes on this Hexxagon board,
  List<List<TilePosition>> _history;

  /// Create a new HexxagonHistory from a existing Hexxagon board.
  HexxagonHistory.clone(Hexxagon hexxagon) : super.clone(hexxagon)
  {
    _history = [];
  }

  @override
  void move(Move move)
  {
    if (!isValidMove(move))
    {
      throw new Exception("Invalid move");
    }

    List<TilePosition> changed = [];

    set(move.to, currentPlayer);
    changed.add(move.to);

    // Remove from old TilePosition if move is a jump.
    int distance = move.from.getDistanceTo(move.to);
    if (distance == 2)
    {
      set(move.from, TileType.EMPTY);
      changed.add(move.from);
    }

    // Capture neighbours.
    move.to.forEachNeighbour(this, (TilePosition neighbour)
    {
      if (get(neighbour) == notCurrentPlayer)
      {
        set(neighbour, currentPlayer);
        changed.add(neighbour);
      }
    });

    _history.add(changed);
    currentPlayer = notCurrentPlayer;
  }

  /// Undo the last move made.
  void undoLastMove()
  {
    if (_history.isEmpty)
    {
      throw new Exception();
    }

    List<TilePosition> changes = _history.removeLast();

    // The first changes is always the target of the move.
    set(changes[0], TileType.EMPTY);

    // Now iterate through all other changes.
    for (int i = 1; i < changes.length; i++)
    {
      TilePosition change = changes[i];
      // If the pos of change is now empty, it must been the jump.
      if (get(change) == TileType.EMPTY)
      {
        set(change, notCurrentPlayer);
      }
      // Else it must been a capture.
      else if (get(change) == notCurrentPlayer)
      {
        set(change, currentPlayer);
      }
      else
      {
        throw new Exception();
      }
    }

    currentPlayer = notCurrentPlayer;
  }
}