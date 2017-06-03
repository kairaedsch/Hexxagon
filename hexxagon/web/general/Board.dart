import 'Move.dart';
import 'TilePosition.dart';
import 'TileType.dart';

abstract class Board
{
  int get width;
  int get height;
  void move(TilePosition from, TilePosition to);
  List<Move> getPossibleMoves(TilePosition tilePosition);
  bool couldBeMoved(TilePosition tilePosition);
  int get(TilePosition tilePosition);
  int getCurrentPlayer();
  int getNotCurrentPlayer();
  bool get isOver;
  int get betterPlayer;
}