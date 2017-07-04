import 'Board.dart';
import 'Move.dart';

typedef void MoveCallback(Move move);

abstract class Player<B extends Board>
{
  bool get isHuman;

  String get name;

  int get strength;

  void move(B board, MoveCallback moveCallback);
}