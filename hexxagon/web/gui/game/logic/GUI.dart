import '../../../general/Board.dart';
import '../../../general/Game.dart';
import '../../../general/Intelligence.dart';

import 'GameGUI.dart';

/// Creates new Boards.
typedef Board BoardCreater();

/// The state of the GUI.
enum GUIState
{
  /// Player selection state.
  PLAYER_SELECTION,

  /// Game is running state.
  GAME_RUNNING,

  /// Game is over state.
  GAME_OVER
}

/// The complete state of the GUI.
class GUI<B extends Board<B>>
{
  /// The state of the GUI.
  GUIState _guiState;

  /// The BoardCreater to create a new Board after players where selected.
  BoardCreater _boardCreater;

  /// If we are currently at the player selection.
  bool get isPlayerSelection => _guiState == GUIState.PLAYER_SELECTION;

  /// If we are currently playing a game.
  bool get isGameRunning => _guiState == GUIState.GAME_RUNNING;

  /// If we had played a game which is now over.
  bool get isGameOver => _guiState == GUIState.GAME_OVER;

  /// The current GameGUI being played.
  GameGUI _currentGameGui;

  /// The current GameGUI being played.
  GameGUI get currentGameGui => _currentGameGui;

  /// Listeners to be notified if the GUI state changes.
  List<Function> _GUIStateChangedListener;

  /// Listeners to be notified if the game changes.
  List<Function> _gameChangedListener;

  /// Listeners to be notified if the game GUI changes.
  List<Function> _gameGUIChangedListener;

  /// The intelligence who will play as player one.
  Intelligence<B> playerOne;

  /// The intelligence who will play as player two.
  Intelligence<B> playerTwo;

  /// Create a new GUI with a given Board creator.
  GUI(this._boardCreater)
  {
    _GUIStateChangedListener = [];
    _gameChangedListener = [];
    _gameGUIChangedListener = [];
    _guiState = GUIState.PLAYER_SELECTION;
  }

  /// Start a new game.
  void startNewGame()
  {
    if (isPlayerSelection)
    {
      _currentGameGui = new GameGUI(new Game<B>(_boardCreater(), playerOne, playerTwo));
      _guiState = GUIState.GAME_RUNNING;
      _currentGameGui.gameChangeListener = _gameChanged;
      _currentGameGui.gameGUIChangeListener = _gameGUIChanged;
      _notifyGameChanged();
      _notifyGUIStateChanged();
    }
  }

  /// Will be called, when the game has changed.
  void _gameChanged()
  {
    if (isGameRunning)
    {
      _notifyGameChanged();
      if (_currentGameGui.isOver)
      {
        _guiState = GUIState.GAME_OVER;
        _notifyGUIStateChanged();
      }
    }
  }

  /// Will be called, when the game GUI has changed.
  void _gameGUIChanged()
  {
    if (isGameRunning)
    {
      _notifyGameGUIChanged();
    }
  }

  /// Switch to main menu.
  void showMainMenu()
  {
    _guiState = GUIState.PLAYER_SELECTION;
    _currentGameGui.abort();
    _notifyGameChanged();
    _notifyGUIStateChanged();
  }

  /// Notify all GUI state listeners.
  void _notifyGUIStateChanged()
  {
    _GUIStateChangedListener.toList().forEach((f) => f());
  }

  /// Notify all game listeners.
  void _notifyGameChanged()
  {
    _gameChangedListener.toList().forEach((f) => f());
  }

  /// Notify all game GUI listeners.
  void _notifyGameGUIChanged()
  {
    _gameGUIChangedListener.toList().forEach((f) => f());
  }

  /// Add listener to be notified if gui state changes.
  void addGUIStateChangeListener(Function f)
  {
    _GUIStateChangedListener.add(f);
  }

  /// Add listener to be notified if game changes.
  void addGameChangeListener(Function f)
  {
    _gameChangedListener.add(f);
  }

  /// Add listener to be notified if game gui changes.
  void addGameGUIChangeListener(Function f)
  {
    _gameGUIChangedListener.add(f);
  }
}