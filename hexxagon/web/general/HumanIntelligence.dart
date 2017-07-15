import 'Board.dart';
import 'Intelligence.dart';

/// A Human intelligence. The move method is empty, as we have to use a real brain.
class HumanIntelligence<B extends Board> extends Intelligence<B>
{
  @override
  bool get isHuman => true;

  @override
  String get name => "Human";

  @override
  int get strength => 0;

  @override
  void move(B board, MoveCallback moveCallback)
  {

  }
}