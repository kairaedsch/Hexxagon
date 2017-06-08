import '../game/Hexxagon.dart';
import '../game/MonteCarloHexxagonPlayer.dart';
import '../game/MonteCarloHexxagonPlayer.dart';
import '../game/MonteCarloTreeSearchHexxagonPlayer.dart';
import '../game/RandomHexxagonPlayer.dart';
import '../general/HumanPlayer.dart';
import '../general/Player.dart';
import '../general/TilePosition.dart';
import 'GUI.dart';
import 'GameGUI.dart';
import '../general/Move.dart';
import 'Hexagon.dart';
import 'ReactTileGrid.dart';
import '../general/TileType.dart';
import 'dart:html';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' as react_client;
import 'package:over_react/over_react.dart';
import 'ReactTile.dart';
import 'ReactPlayerSelect.dart';

@Factory()
UiFactory<ReactPlayerSelectionProps> ReactPlayerSelection;

@Props()
class ReactPlayerSelectionProps extends UiProps
{
  GUI gui;
}

@State()
class ReactPlayerSelectionState extends UiState
{
  int selectedPlayerOne;
  int selectedPlayerTwo;
}

@Component()
class ReactPlayerSelectionComponent extends UiStatefulComponent<ReactPlayerSelectionProps, ReactPlayerSelectionState>
{
  List<Player> players = [new HumanPlayer(), new RandomHexxagonPlayer(), new MonteCarloTreeSearchHexxagonPlayer(), new MonteCarloHexxagonPlayer()];

  @override
  getInitialState()
  {
    return (newState()
      ..selectedPlayerOne = 0
      ..selectedPlayerTwo = 1
    );
  }

  void componentWillMount()
  {
    super.componentWillMount();
    props.gui.addStateChangeListener(()
    => setState(state));
  }

  ReactElement render()
  {
    props.gui.playerOne = players[state.selectedPlayerOne];
    props.gui.playerTwo = players[state.selectedPlayerTwo];
    if (props.gui.isPlayerSelection)
    {
      querySelector(".mainMenuOverlay").classes
        ..remove("hide")
        ..add("unhide");
    }
    else
    {
      querySelector(".mainMenuOverlay").classes
        ..add("hide")
        ..remove("unhide");
    }
    return (Dom.div()
      ..className = "playerSelectionContainer"
    )(
        (Dom.div()
          ..className = "player playerOne"
        )(
            (ReactPlayerSelect()
              ..players = players
              ..selected = state.selectedPlayerOne
              ..father = this
              ..playerOne = true)()),
        (Dom.div()
          ..className = "playerBetween"
        )(
            "VS"
        ),
        (Dom.div()
          ..className = "player playerTwo"
        )(
            (ReactPlayerSelect()
              ..players = players
              ..selected = state.selectedPlayerTwo
              ..father = this
              ..playerOne = false)()
        )
    );
  }

  void changePlayerOne(int delta)
  {
    this.setState((Map prevState, Map props)
    {
      ReactPlayerSelectionState state = newState()
        ..addAll(prevState);
      state.selectedPlayerOne = (state.selectedPlayerOne + delta) % players.length;
      return state;
    });
  }

  void changePlayerTwo(int delta)
  {
    this.setState((Map prevState, Map props)
    {
      ReactPlayerSelectionState state = newState()
        ..addAll(prevState);
      state.selectedPlayerTwo = (state.selectedPlayerTwo + delta) % players.length;
      return state;
    });
  }
}