import '../gui/Move.dart';
import 'TilePosition.dart';
import 'TileType.dart';

abstract class Board
{
  void move(TilePosition from, TilePosition to);
  List<Move> getPossibleMoves(TilePosition tilePosition);
  bool couldBeMoved(TilePosition tilePosition);
  TileType get(TilePosition tilePosition);
}