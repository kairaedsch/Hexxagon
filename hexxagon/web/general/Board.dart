import 'Move.dart';
import 'TilePosition.dart';

abstract class Board
{
  int get width;
  int get height;
  void move(TilePosition from, TilePosition to);
  List<Move> getPossibleMoves(TilePosition tilePosition);
  bool couldBeMoved(TilePosition tilePosition);
  int get(TilePosition tilePosition);
  int get currentPlayer;
  int get notCurrentPlayer;
  bool get isOver;
  int get betterPlayer;
  Map<String, String> getStatsOf(int player) => {};
}