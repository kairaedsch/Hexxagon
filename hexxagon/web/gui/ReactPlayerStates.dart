import '../game/Hexxagon.dart';
import '../general/Player.dart';
import '../general/TilePosition.dart';
import 'GUI.dart';
import 'GameGUI.dart';
import '../general/Move.dart';
import 'Hexagon.dart';
import 'ReactPlayerSelection.dart';
import 'ReactTileGrid.dart';
import '../general/TileType.dart';
import 'dart:html';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' as react_client;
import 'package:over_react/over_react.dart';
import 'ReactTile.dart';
import 'ReactPlayerState.dart';

@Factory()
UiFactory<ReactPlayerStatesProps> ReactPlayerStates;

@Props()
class ReactPlayerStatesProps extends UiProps
{
  GUI gui;
}

@State()
class ReactPlayerStatesState extends UiState
{
}

@Component()
class ReactPlayerStatesComponent extends UiStatefulComponent<ReactPlayerStatesProps, ReactPlayerStatesState>
{
  void componentWillMount()
  {
    super.componentWillMount();
    props.gui.addGameChangeListener(()
    => setState(state));
    props.gui.addStateChangeListener(()
    => setState(state));
  }

  ReactElement render()
  {
    if (props.gui.currentGameGui == null)
    {
      return Dom.div()();
    }

    return (Dom.div()
      ..className = "sideInner"
    )(
      (Dom.div()
        ..className = "title")(),
      (ReactPlayerState()
        ..gui = props.gui
        ..player = TileType.PLAYER_ONE)(),
      (ReactPlayerState()
        ..gui = props.gui
        ..player = TileType.PLAYER_TWO)(),
      (Dom.div()
        ..className = "button abort"
        ..onClick = (e)
        {
          props.gui.selectPlayer();
        }
      )(props.gui.isGameOver ? "Zurüch zum Hauptmenu" : "Spiel abbrechen"),
    );
  }
}