import 'Move.dart';
import 'TilePosition.dart';
import 'TileType.dart';

abstract class Board
{
  int get width;
  int get height;
  void move(TileType player, TilePosition from, TilePosition to);
  List<Move> getPossibleMoves(TileType player, TilePosition tilePosition);
  bool couldBeMoved(TilePosition tilePosition);
  TileType get(TilePosition tilePosition);
  TileType getCurrentPlayer();
  TileType getNotCurrentPlayer();
}