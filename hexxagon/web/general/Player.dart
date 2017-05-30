import '../game/MonteCarloHexxagonPlayer.dart';
import '../game/RandomHexxagonPlayer.dart';
import 'Board.dart';
import 'Move.dart';
import 'TilePosition.dart';
import 'TileType.dart';

typedef void MoveCallback(Move move);

abstract class Player<B extends Board>
{
  bool get isHuman;

  String get name;

  void move(B board, int player, MoveCallback moveCallback);
}