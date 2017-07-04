import 'dart:math';

import '../../../general/Player.dart';
import '../ComputerPlayer.dart';
import '../../Hexxagon.dart';

class RandomHexxagonPlayer extends ComputerPlayer
{
  String get name => "Random Player";

  String get image => "robot-1.png";

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    Random rng = new Random();
    moveCallback(hexxagon.getRandomMove(rng));
  }
}