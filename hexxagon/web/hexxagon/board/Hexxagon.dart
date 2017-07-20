import 'HexxagonMove.dart';

import '../../general/Array2D.dart';
import '../../general/Board.dart';
import '../../general/Move.dart';
import '../../general/TilePosition.dart';
import '../../general/TileType.dart';
import 'package:meta/meta.dart';

/// The logical implementation of the two player Game Hexxagon.
class Hexxagon extends Board<Hexxagon>
{
  /// The width of this Hexxagon board (columns).
  int _width;

  /// The height of this Hexxagon board (rows).
  int _height;

  @override
  int get width => _width;

  @override
  int get height => _height;

  /// The tiles of this Hexxagon board.
  Array2D<TileType> _tiles;

  /// The current Player who has to do a move, if the game is not already over.
  TileType _currentPlayer;

  /// Creates a new Hexxagon Board with the given radius.
  Hexxagon(int radius)
  {
    _width = radius + 1;
    _height = (radius * 2 + 1) * 2;

    _tiles = new Array2D(_width, _height, TileType.EMPTY);
    _currentPlayer = TileType.PLAYER_ONE;

    // Create round field.
    TilePosition center = TilePosition.get((radius / 2).floor(), (_height / 2).floor());
    TilePosition.forEachOnBoard(this, (TilePosition pos)
    {
      var distance = center.getDistanceTo(pos);
      if (distance > radius)
      {
        set(pos, TileType.OUT_OF_FIELD);
      }
    });

    // Setup start tiles.
    _setTileAroundTile(radius, center, 0, TileType.PLAYER_ONE);
    _setTileAroundTile(radius, center, 1, TileType.PLAYER_TWO);
    _setTileAroundTile(radius, center, 2, TileType.PLAYER_ONE);
    _setTileAroundTile(radius, center, 3, TileType.PLAYER_TWO);
    _setTileAroundTile(radius, center, 4, TileType.PLAYER_ONE);
    _setTileAroundTile(radius, center, 5, TileType.PLAYER_TWO);

    _setTileAroundTile(1, center, 0, TileType.BLOCKED);
    _setTileAroundTile(1, center, 2, TileType.BLOCKED);
    _setTileAroundTile(1, center, 4, TileType.BLOCKED);
  }

  /// Calculates a position by going the given amount of steps in the given direction, starting from the given start position.
  /// This position is then set to the given tile.
  void _setTileAroundTile(int steps, TilePosition start, int direction, TileType tile)
  {
    TilePosition end = start;
    for (int i = 0; i < steps; i++)
    {
      end = new TilePosition(end.x + end.neighbourDeltas[direction][0], end.y + end.neighbourDeltas[direction][1]);
    }
    set(end, tile);
  }

  /// Clone this Hexxagon board.
  Hexxagon.clone(Hexxagon hexxagon) {
    _width = hexxagon._width;
    _height = hexxagon._height;
    _currentPlayer = hexxagon.currentPlayer;

    _tiles = new Array2D.empty(_width, _height);
    TilePosition.forEachOnBoard(this, (TilePosition pos) => _tiles[pos.x][pos.y] = hexxagon.get(pos));
  }

  @override
  Hexxagon cloneIt()
  {
    return new Hexxagon.clone(this);
  }

  @override
  void move(Move move)
  {
    if (!isValidMove(move))
    {
      throw new Exception("Invalid move");
    }

    set(move.to, _currentPlayer);

    // Remove from old TilePosition if move is a jump.
    int distance = move.from.getDistanceTo(move.to);
    if (distance == 2)
    {
      set(move.from, TileType.EMPTY);
    }

    // Capture neighbours.
    move.to.forEachNeighbour(this, (TilePosition neighbour)
    {
      if (get(neighbour) == notCurrentPlayer)
      {
        set(neighbour, _currentPlayer);
      }
    });

    _currentPlayer = notCurrentPlayer;
  }

  /// If the given move is a valid move on the current state of this Hexxagon game.
  @protected
  bool isValidMove(Move move)
  {
    if (get(move.from) != _currentPlayer || get(move.to) != TileType.EMPTY)
    {
      return false;
    }

    // Must be a jump or a copy.
    int distance = move.from.getDistanceTo(move.to);
    if (distance != 1 && distance != 2)
    {
      return false;
    }

    return true;
  }

  @override
  List<Move> getPossibleMoves(TilePosition from)
  {
    if (get(from) != _currentPlayer)
    {
      return new List(0);
    }
    List<Move> possibleMoves = [];

    // Collect all copy moves.
    from.forEachNeighbour(this, (neighbour)
    {
      if (get(neighbour) == TileType.EMPTY)
      {
        possibleMoves.add(new HexxagonMove(from, neighbour));
      }
    });

    // Collect all jump moves.
    from.forEachNeighbourSecondRing(this, (neighbour)
    {
      if (get(neighbour) == TileType.EMPTY)
      {
        possibleMoves.add(new HexxagonMove(from, neighbour));
      }
    });

    return possibleMoves;
  }

  @override
  bool get isOver
  {
    for (int x = 0; x < _width; x++)
    {
      for (int y = 0; y < _height; y++)
      {
        TilePosition from = TilePosition.get(x, y);
        if (getPossibleMoves(from).isNotEmpty)
        {
          return false;
        }
      }
    }
    return true;
  }

  /// Count the tiles of the given player on the game field.
  int countTilesOfType(TileType player)
  {
    int count = 0;
    TilePosition.forEachOnBoard(this, (TilePosition pos)
    {
      if (get(pos) == player)
      {
        count++;
      }
    });
    return count;
  }

  /// Sets the given position to the given tile.
  @protected
  void set(TilePosition position, TileType type)
  {
    _tiles.array[position.x][position.y] = type;
  }

  @override
  TileType get(TilePosition position)
  {
    return _tiles.array[position.x][position.y];
  }

  @override
  TileType get currentPlayer => _currentPlayer;

  /// Sets the current Player.
  @protected
  void set currentPlayer(TileType currentPlayer) {
    _currentPlayer = currentPlayer;
  }

  @override
  bool couldBeMoved(TilePosition position) => get(position) == _currentPlayer;

  @override
  scoreOfPlayer(TileType player) => countTilesOfType(player);
}