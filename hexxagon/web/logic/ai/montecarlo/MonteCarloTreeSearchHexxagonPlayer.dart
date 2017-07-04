import '../../../general/Player.dart';
import '../ComputerPlayer.dart';
import '../../Hexxagon.dart';
import 'GameNode.dart';

class MonteCarloTreeSearchHexxagonPlayer extends ComputerPlayer
{
  String get name => "MonteCarlo TreeSearch Player";

  int get strength => 1;

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    GameNode root = new GameNode.root(hexxagon);

    for (int r = 0; r < 2000; r++)
    {
      root.playRandom();
    }

    //print(root.toTree("", "", 2));

    moveCallback(root.getBestMove());
  }
}