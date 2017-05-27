import '../general/Move.dart';
import '../general/Player.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'Hexxagon.dart';
import 'dart:async';

class RandomHexxagonPlayer extends Player<Hexxagon>
{
  get isHuman => false;

  void move(Hexxagon hexxagon, TileType player, MoveCallback moveCallback)
  {
    List<TilePosition> canBeMoved = hexxagon.canBeMoved(player);
    TilePosition position = (canBeMoved..shuffle())[0];
    new Timer(new Duration(seconds: 1), ()
    {
      moveCallback((hexxagon.getPossibleMoves(player, position)
        ..shuffle())[0]);
    });
  }
}