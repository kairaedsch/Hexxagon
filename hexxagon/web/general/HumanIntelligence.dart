import 'Board.dart';
import 'Intelligence.dart';

typedef void Callback();

class HumanIntelligence<B extends Board> extends Intelligence<B>
{
  bool get isHuman => true;

  String get name => "Human Player";

  int get strength => 0;

  void move(B board, MoveCallback moveCallback)
  {

  }
}