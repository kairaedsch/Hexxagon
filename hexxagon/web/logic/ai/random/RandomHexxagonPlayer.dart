import 'dart:math';

import '../../../general/Player.dart';
import '../ComputerPlayer.dart';
import '../../Hexxagon.dart';

class RandomHexxagonPlayer extends ComputerPlayer
{
  String get name => "Random Player";

  int get strength => 1;

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    Random rng = new Random();
    moveCallback(hexxagon.getRandomMove(rng));
  }
}