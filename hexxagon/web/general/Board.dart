import 'GameResult.dart';
import 'Move.dart';
import 'TilePosition.dart';
import 'TileType.dart';

abstract class Board<B>
{
  B cloneIt();
  int get width;
  int get height;
  void move(Move move);
  List<Move> getPossibleMoves(TilePosition tilePosition);
  bool couldBeMoved(TilePosition tilePosition);
  TileType get(TilePosition tilePosition);
  TileType get currentPlayer;
  TileType get notCurrentPlayer => (currentPlayer == TileType.PLAYER_ONE ? TileType.PLAYER_TWO : TileType.PLAYER_ONE);
  bool get isOver;
  TileType get betterPlayer;
  int countTilesOfType(TileType player);
  GameResult getResult(TileType player);
}