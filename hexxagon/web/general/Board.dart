import 'GameResult.dart';
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
  TileType get(TilePosition tilePosition);
  TileType get currentPlayer;
  TileType get notCurrentPlayer;
  bool get isOver;
  TileType get betterPlayer;
  int countTilesOfType(TileType player);
  GameResult getResult(TileType player);
}