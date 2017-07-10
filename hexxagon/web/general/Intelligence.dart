import 'Board.dart';
import 'Move.dart';

typedef void MoveCallback(Move move);

abstract class Intelligence<B extends Board>
{
  bool get isHuman;

  String get name;

  int get strength;

  String get strengthName
  {
    switch(strength)
    {
      case 1: return "easy";
      case 2: return "medium";
      case 3: return "hard";
      case 4: return "extrem";
    }
  }

  void move(B board, MoveCallback moveCallback);
}