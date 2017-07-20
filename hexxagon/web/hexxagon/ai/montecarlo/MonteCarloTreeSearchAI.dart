import '../../../general/Intelligence.dart';
import '../ArtificialIntelligence.dart';
import '../../board/Hexxagon.dart';
import 'TreeSearchGameNode.dart';

class MonteCarloTreeSearchAI extends ArtificialIntelligence
{
  @override
  String get name => "MonteCarlo TreeSearch";

  @override
  int get strength => 1;

  /// The time budget for each calculation.
  int _timeBudget;

  /// Create a new MonteCarloTreeSearchAI with the given time budget.
  MonteCarloTreeSearchAI(this._timeBudget);

  @override
  void moveAI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    // Create the root node of our tree.
    TreeSearchGameNode root = new TreeSearchGameNode.root(hexxagon);

    // Execute the loop while we have not exited our time budget.
    DateTime start = new DateTime.now();
    int rounds = 0;
    while (new DateTime.now().difference(start).inMilliseconds < _timeBudget)
    {
      root.playRandom();
      rounds++;
    }
    print("AI: $rounds rounds");

    //print(root.toTree("", "", 2));

    moveCallback(root.bestMove);
  }
}