import '../../../general/Intelligence.dart';
import '../ArtificialIntelligence.dart';
import '../../Hexxagon.dart';
import 'GameNode.dart';

class MonteCarloTreeSearchAI extends ArtificialIntelligence
{
  @override
  String get name => "MonteCarlo TreeSearch Player";

  @override
  int get strength => 1;

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    GameNode root = new GameNode.root(hexxagon);

    DateTime start = new DateTime.now();
    int rounds = 0;
    while (new DateTime.now().difference(start).inMilliseconds < 5000)
    {
      root.playRandom();
      rounds++;
    }
    print("AI: $rounds rounds");

    print(root.toTree("", "", 2));

    moveCallback(root.bestMove);
  }
}