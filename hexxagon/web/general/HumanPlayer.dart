import 'Board.dart';
import 'Move.dart';
import 'Player.dart';
import 'TilePosition.dart';
import 'TileType.dart';

typedef void Callback();

class HumanPlayer<B extends Board> extends Player<B>
{
  bool get isHuman => true;

  String get name => "Human Player";

  void move(B board, int player, MoveCallback moveCallback)
  {

  }
}