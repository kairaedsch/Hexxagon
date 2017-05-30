import '../general/Array2D.dart';
import '../general/Board.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import '../general/Move.dart';
import 'package:dartson/dartson.dart';

@Entity()
class Hexxagon extends Board
{
  int width, height;
  Array2D tiles;
  int currentPlayer;

  Hexxagon();

  Hexxagon.normal(this.width, this.height)
  {
    tiles = new Array2D.normal(width, height, TileType.EMPTY);
    currentPlayer = TileType.PLAYER_ONE;

    _set(new TilePosition.normal(0, 0), TileType.PLAYER_ONE);
    _set(new TilePosition.normal(width - 1, height - 1), TileType.PLAYER_ONE);

    _set(new TilePosition.normal(width - 1, 0), TileType.PLAYER_TWO);
    _set(new TilePosition.normal(0, height - 1), TileType.PLAYER_TWO);

    TilePosition pos = new TilePosition.normal((width / 2).floor() - 1, (height / 2).floor());
    _set(pos, TileType.FORBIDDEN);
  }

  Hexxagon.clone(Hexxagon hexxagon) {
    width = hexxagon.width;
    height = hexxagon.height;
    tiles = new Array2D.normal(width, height, TileType.EMPTY);
    for (int x = 0; x < width; x++)
    {
      for (int y = 0; y < height; y++)
      {
        TilePosition pos = new TilePosition.normal(x, y);
        tiles[x][y] = hexxagon.get(pos);
      }
    }
    currentPlayer = hexxagon.getCurrentPlayer();
  }

  @override
  void move(int player, TilePosition from, TilePosition to)
  {
    if (!isVaidMove(player, from, to))
    {
      throw new Exception("Invalid Move");
    }

    _set(to, currentPlayer);
    int distance = from.getMaxDistanceTo(to);
    if (distance == 2)
    {
      _set(from, TileType.EMPTY);
    }

    for (List<int> neighbourDelta in to.y.isEven ? TilePosition.neighbourDeltasEven : TilePosition.neighbourDeltasOdd)
    {
      TilePosition position = new TilePosition.normal(neighbourDelta[0] + to.x, neighbourDelta[1] + to.y);
      if (position.isValid(width, height) && get(position) == getNotCurrentPlayer())
      {
        _set(position, currentPlayer);
      }
    }

    currentPlayer = getNotCurrentPlayer();
  }

  bool isVaidMove(int player, TilePosition from, TilePosition to)
  {
    if (player != currentPlayer || get(from) != currentPlayer || get(to) != TileType.EMPTY)
    {
      return false;
    }

    int distance = from.getMaxDistanceTo(to);
    if (distance != 1 && distance != 2)
    {
      return false;
    }

    return true;
  }

  void _set(TilePosition position, int type)
  {
    tiles.array[position.x][position.y] = type;
  }

  @override
  List<Move> getPossibleMoves(int player, TilePosition from)
  {
    List<Move> possibleMoves = [];
    for (int x = 0; x < width; x++)
    {
      for (int y = 0; y < height; y++)
      {
        TilePosition to = new TilePosition.normal(x, y);
        if (isVaidMove(player, from, to))
        {
          possibleMoves.add(
              new Move.normal(from, to, from.getMaxDistanceTo(to) == 1 ? "copy" : "jump"));
        }
      }
    }
    return possibleMoves;
  }

  @override
  bool couldBeMoved(TilePosition position)
  {
    return get(position) == currentPlayer;
  }

  @override
  List<TilePosition> canBeMoved(int player)
  {
    List<TilePosition> possibleMoves = [];
    for (int x = 0; x < width; x++)
    {
      for (int y = 0; y < height; y++)
      {
        TilePosition from = new TilePosition.normal(x, y);
        if (getPossibleMoves(player, from).isNotEmpty)
        {
          possibleMoves.add(from);
        }
      }
    }
    return possibleMoves;
  }

  @override
  int get(TilePosition position)
  {
    return tiles.array[position.x][position.y];
  }

  @override
  int getCurrentPlayer()
  {
    return currentPlayer;
  }

  @override
  int getNotCurrentPlayer()
  {
    return (currentPlayer == TileType.PLAYER_ONE ? TileType.PLAYER_TWO : TileType.PLAYER_ONE);
  }

  @override
  bool get isOver
  => canBeMoved(getCurrentPlayer()).isEmpty;

  @override
  int get betterPlayer
  {
    int playerOne = 0,
        playerTwo = 0;
    for (int x = 0; x < width; x++)
    {
      for (int y = 0; y < height; y++)
      {
        int type = get(new TilePosition.normal(x, y));
        if (type == TileType.PLAYER_ONE)
        {
          playerOne++;
        }
        else if (type == TileType.PLAYER_TWO)
        {
          playerTwo++;
        }
      }
    }
    return playerOne > playerTwo ? TileType.PLAYER_ONE : playerOne < playerTwo ? TileType.PLAYER_TWO : TileType.EMPTY;
  }
}