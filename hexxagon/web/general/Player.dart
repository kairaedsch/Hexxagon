import '../game/montecarlo/MonteCarloHexxagonPlayer.dart';
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

  String get image;

  void move(B board, MoveCallback moveCallback);
}