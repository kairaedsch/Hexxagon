import 'GameResult.dart';
import 'Move.dart';
import 'TilePosition.dart';
import 'TileType.dart';

/// An abstract Two Player board on a Hexagon Field.
abstract class Board<B>
{
  /// Clone this board.
  B cloneIt();

  /// The width of this board (columns).
  int get width;

  /// The height of this board (rows).
  int get height;

  /// Make a move on this board.
  void move(Move move);

  /// Get all possible Moves, which the current Player can do at the moment.
  List<Move> getPossibleMoves(TilePosition tilePosition);

  /// Checks, if the current Player could do a move with the given tile.
  bool couldBeMoved(TilePosition tilePosition);

  /// The Type of Tile at the given TilePosition.
  TileType get(TilePosition tilePosition);

  /// The current Player who has to do a move, if the game is not already over.
  TileType get currentPlayer;

  /// Not the current Player.
  TileType get notCurrentPlayer => (currentPlayer == TileType.PLAYER_ONE ? TileType.PLAYER_TWO : TileType.PLAYER_ONE);

  /// If the game is over.
  bool get isOver;

  /// The score of the given player.
  int scoreOfPlayer(TileType player);

  /// The player who would be the winner, if the game would be over now.
  TileType get betterPlayer
  {
    int scorePlayerOne = scoreOfPlayer(TileType.PLAYER_ONE);
    int scorePlayerTwo = scoreOfPlayer(TileType.PLAYER_TWO);
    if (scorePlayerOne > scorePlayerTwo)
    {
      return TileType.PLAYER_ONE;
    }
    else
    {
      return (scorePlayerOne < scorePlayerTwo ? TileType.PLAYER_TWO : TileType.EMPTY);
    }
  }

  /// The GameResult of this board.
  GameResult getResult(TileType player)
  {
    TileType betterPlayer = this.betterPlayer;
    if (betterPlayer == player)
    {
      return GameResult.WIN;
    }
    else if (betterPlayer == TileType.EMPTY)
    {
      return GameResult.DRAW;
    }
    else
    {
      return GameResult.LOST;
    }
  }
}