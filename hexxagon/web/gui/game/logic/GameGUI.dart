import '../../../general/TileType.dart';
import 'dart:async';

import 'package:optional/optional.dart';
import 'package:tuple/tuple.dart';

import '../../../general/Board.dart';
import '../../../general/Game.dart';
import '../../../general/Move.dart';
import '../../../general/Intelligence.dart';
import '../../../general/TilePosition.dart';

/// A Game with additional selecting possibilities for the GUI.
class GameGUI
{
  /// The the game was aborted.
  bool aborted;

  /// The game.
  Game _game;

  /// The listener to be called if the game changes.
  Function gameChangeListener;

  /// The listener to be called if the this game GUI changes.
  Function gameGUIChangeListener;

  /// The width of the board (amount of columns).
  int get width => _game.board.width;

  /// The height of the board (amount of rows).
  int get height => _game.board.height;

  /// Currently selected tile (if any tile is selected) with possible moves with this tile.
  Optional<Tuple2<TilePosition, List<Move>>> _selectedPosition;

  /// Currently selected tile (if any tile is selected).
  TilePosition get selectedPosition => _selectedPosition.value.item1;

  /// Possible moves which could be done with the tile currently selected.
  List<Move> get possibleMoves => _selectedPosition.value.item2;

  /// If a tile is selected.
  bool get isATileSelected => _selectedPosition.isPresent;

  /// The last changes done by the last move made on the board.
  Optional<Map<TilePosition, String>> get lastMoveChanges => _game.lastMoveChanges;

  /// Create a new GameGUI with a given Game.
  GameGUI(this._game)
  {
    gameChangeListener = () => {};
    gameGUIChangeListener = () => {};
    aborted = false;
    _game.changeListener = ()
    {
      if (!aborted)
      {
        gameChangeListener();
        if (!_game.board.isOver)
        {
          if (!_game.currentIntelligence.isHuman)
          {
            new Timer(new Duration(milliseconds: (500)), _game.next);
          }
        }
      }
    };
    _selectedPosition = new Optional.empty();
    _game.next();
  }

  /// Select the given tile.
  void select(TilePosition position)
  {
    if (!_game.board.isOver && _game.board.couldBeMoved(position) && (!isATileSelected || !position.equals(selectedPosition)))
    {
      _selectedPosition = new Optional.of(new Tuple2(position, _game.board.getPossibleMoves(position)));
      gameGUIChangeListener();
    }
    else
    {
      deselect();
    }
  }

  /// Deselect the tile.
  void deselect()
  {
    _selectedPosition = new Optional.empty();
    gameGUIChangeListener();
  }

  /// Make a move in the game.
  void move(Move move)
  {
    _game.move(move);
    deselect();
  }

  /// Abort the game.
  void abort()
  {
    aborted = true;
  }

  /// Checks, if the current Player could do a move with the given tile.
  bool couldBeMoved(TilePosition tilePosition) => _game.board.couldBeMoved(tilePosition);

  /// The Type of Tile at the given TilePosition.
  TileType get(TilePosition tilePosition) => _game.board.get(tilePosition);

  /// The current Player who has to do a move, if the game is not already over.
  TileType get currentPlayer => _game.board.currentPlayer;

  /// Not the current Player.
  TileType get notCurrentPlayer => _game.board.notCurrentPlayer;

  /// The current intelligence who has to do a move.
  Intelligence get currentIntelligence => _game.currentIntelligence;

  /// If the game is over.
  bool get isOver => _game.board.isOver;

  /// The score of the given player.
  int scoreOfPlayer(TileType player) => _game.scoreOfPlayer(player);

  /// The intelligence which plays the given player.
  Intelligence<Board> getIntelligence(TileType player) => _game.getIntelligence(player);

  /// The player who would be the winner, if the game would be over now.
  TileType get betterPlayer => _game.board.betterPlayer;
}