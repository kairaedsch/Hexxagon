import 'Board.dart';
import 'Move.dart';
import 'Player.dart';
import 'TilePosition.dart';
import 'TileType.dart';

typedef void Callback();

class HumanPlayer<B extends Board> extends Player<B>
{
  get isHuman => true;

  Callback callback;

  HumanPlayer();

  void move(B board, TileType player, MoveCallback moveCallback)
  {

  }
}