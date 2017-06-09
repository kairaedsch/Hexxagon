import '../general/Board.dart';
import '../general/Game.dart';
import '../general/Move.dart';
import '../general/Player.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'dart:async';
import 'package:optional/optional.dart';
import 'package:tuple/tuple.dart';

class GameGUI
{
  bool aborted;

  int _delay;

  Game _game;
  List<Function> _changeListener;

  int get width
  => _game.width;

  int get height
  => _game.height;

  Optional<Tuple2<TilePosition, List<Move>>> _selectedPosition;

  TilePosition get selectedPosition
  => _selectedPosition.value.item1;

  List<Move> get possibleMoves
  => _selectedPosition.value.item2;

  bool get isSomethingSelected
  => _selectedPosition.isPresent;

  Optional<Move> get lastMove
  => _game.lastMove;

  GameGUI(this._game, this._delay)
  {
    _changeListener = [];
    aborted = false;
    _game.changeListener = ()
    {
      if (!aborted)
      {
        new Timer(new Duration(milliseconds: currentPlayer.isHuman ? 0 : (250 + _delay / 2).floor()), ()
        {
          notify();
          new Timer(new Duration(milliseconds: currentPlayer.isHuman ? 0 : (250 + _delay / 2).floor()), _game.next);
        });
      }
    };
    _selectedPosition = new Optional.empty();
    _game.next();
  }

  void notify()
  {
    _changeListener.forEach((f)
    => f());
  }

  void addChangeListener(Function f)
  {
    _changeListener.add(f);
  }

  void select(TilePosition position)
  {
    if (_game.couldBeMoved(position) && (!isSomethingSelected || !position.equals(selectedPosition)))
    {
      _selectedPosition = new Optional.of(new Tuple2(position, _game.getPossibleMoves(position)));
      notify();
    }
    else
    {
      unselect();
    }
  }

  void unselect()
  {
    _selectedPosition = new Optional.empty();
    notify();
  }

  void move(Move move)
  {
    _game.move(move);
    unselect();
  }

  bool couldBeMoved(TilePosition tilePosition)
  {
    return _game.couldBeMoved(tilePosition);
  }

  int get(TilePosition tilePosition)
  {
    return _game.get(tilePosition);
  }

  int getCurrentPlayer()
  {
    return _game.getCurrentPlayer();
  }

  int getNotCurrentPlayer()
  {
    return _game.getNotCurrentPlayer();
  }

  Player get currentPlayer
  => _game.currentPlayer;

  bool get isOver
  => _game.isOver;

  Map<String, String> getStatsOf(int player)
  {
    return _game.getStatsOf(player);
  }

  Player<Board> getPlayer(int player)
  {
    return _game.getPlayer(player);
  }

  void abort()
  {
    aborted = true;
  }

  int get betterPlayer => _game.betterPlayer;
}