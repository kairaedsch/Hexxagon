import 'dart:math';

import '../../../general/Intelligence.dart';
import '../ArtificialIntelligence.dart';
import '../../Hexxagon.dart';

class RandomAI extends ArtificialIntelligence
{
  String get name => "Random Player";

  int get strength => 1;

  void moveKI(Hexxagon hexxagon, MoveCallback moveCallback)
  {
    Random rng = new Random();
    moveCallback(hexxagon.getRandomMove(rng));
  }
}