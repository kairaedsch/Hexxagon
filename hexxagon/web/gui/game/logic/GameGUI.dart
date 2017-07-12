import '../../../general/TileType.dart';
import 'dart:async';

import 'package:optional/optional.dart';
import 'package:tuple/tuple.dart';

import '../../../general/Board.dart';
import '../../../general/Game.dart';
import '../../../general/Move.dart';
import '../../../general/Intelligence.dart';
import '../../../general/TilePosition.dart';

class GameGUI
{
  bool aborted;

  int _delay;

  Game _game;
  List<Function> _GameChangeListener;
  List<Function> _GameGUIChangeListener;

  int get width
  => _game.board.width;

  int get height
  => _game.board.height;

  Optional<Tuple2<TilePosition, List<Move>>> _selectedPosition;

  TilePosition get selectedPosition
  => _selectedPosition.value.item1;

  List<Move> get possibleMoves
  => _selectedPosition.value.item2;

  bool get isSomethingSelected
  => _selectedPosition.isPresent;

  Optional<Map<TilePosition, String>> get lastMoveChanges
  {
    return _game.lastMoveChanges;
  }

  GameGUI(this._game, this._delay)
  {
    _GameChangeListener = [];
    _GameGUIChangeListener = [];
    aborted = false;
    _game.changeListener = ()
    {
      if (!aborted)
      {
        notifyGameChange();
        if (!_game.board.isOver)
        {
          if (!_game.currentIntelligence.isHuman)
          {
            new Timer(new Duration(milliseconds: (500 + _delay)), _game.next);
          }
        }
      }
    };
    _selectedPosition = new Optional.empty();
    _game.next();
  }

  void notifyGameChange()
  {
    _GameChangeListener.forEach((f)
    => f());
  }

  void notifyGameGUIChange()
  {
    _GameGUIChangeListener.forEach((f)
    => f());
  }

  void addGameChangeListener(Function f)
  {
    _GameChangeListener.add(f);
  }

  void addGameGUIChangeListener(Function f)
  {
    _GameGUIChangeListener.add(f);
  }

  void select(TilePosition position)
  {
    if (!_game.board.isOver && _game.board.couldBeMoved(position) && (!isSomethingSelected || !position.equals(selectedPosition)))
    {
      _selectedPosition = new Optional.of(new Tuple2(position, _game.board.getPossibleMoves(position)));
      notifyGameGUIChange();
    }
    else
    {
      unselect();
    }
  }

  void unselect()
  {
    _selectedPosition = new Optional.empty();
    notifyGameGUIChange();
  }

  void move(Move move)
  {
    _game.move(move);
    unselect();
  }

  bool couldBeMoved(TilePosition tilePosition)
  {
    return _game.board.couldBeMoved(tilePosition);
  }

  TileType get(TilePosition tilePosition)
  {
    return _game.board.get(tilePosition);
  }

  TileType get currentPlayer
  => _game.board.currentPlayer;

  TileType get notCurrentPlayer
  => _game.board.notCurrentPlayer;

  Intelligence get currentIntelligence
  => _game.currentIntelligence;

  bool get isOver
  => _game.board.isOver;

  int countTilesOfType(TileType player)
  => _game.countTilesOfType(player);

  Intelligence<Board> getIntelligence(TileType player)
  {
    return _game.getIntelligence(player);
  }

  void abort()
  {
    aborted = true;
  }

  TileType get betterPlayer
  => _game.board.betterPlayer;
}