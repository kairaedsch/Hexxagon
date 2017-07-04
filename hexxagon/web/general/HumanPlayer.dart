import 'Board.dart';
import 'Player.dart';

typedef void Callback();

class HumanPlayer<B extends Board> extends Player<B>
{
  bool get isHuman => true;

  String get name => "Human Player";

  String get image => "human.png";

  void move(B board, MoveCallback moveCallback)
  {

  }
}