import 'Board.dart';
import 'Move.dart';
import 'TilePosition.dart';
import 'TileType.dart';

typedef void MoveCallback(Move move);

abstract class Player<B extends Board>
{
  get isHuman;

  void move(B board, TileType player, MoveCallback moveCallback);
}