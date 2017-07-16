import '../../general/Intelligence.dart';
import '../Hexxagon.dart';

/// An artificial intelligence who can make a move on a board by calculating stuff.
abstract class ArtificialIntelligence extends Intelligence<Hexxagon>
{
  @override
  bool get isHuman
  {
    return false;
  }

  @override
  void move(Hexxagon board, MoveCallback moveCallback)
  {
    DateTime start = new DateTime.now();
    moveKI(board, moveCallback);
    print("AI $strengthName - $name: ${new DateTime.now().difference(start).inMilliseconds}ms");
  }

  /// Let this artificial intelligence calculate a good move for the current player and calls the given moveCallback method, when it has found a good move on the given board.
  void moveKI(Hexxagon board, MoveCallback moveCallback);
}