import '../../general/Intelligence.dart';
import '../Hexxagon.dart';

typedef void Callback();

abstract class ArtificialIntelligence extends Intelligence<Hexxagon>
{
  bool get isHuman
  {
    return false;
  }

  void move(Hexxagon board, MoveCallback moveCallback)
  {
    DateTime start = new DateTime.now();
    moveKI(board, moveCallback);
    print("$name: ${new DateTime.now().difference(start).inMilliseconds}ms");
  }

  void moveKI(Hexxagon board, MoveCallback moveCallback);
}