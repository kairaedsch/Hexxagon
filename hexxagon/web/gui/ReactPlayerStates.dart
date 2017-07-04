import 'package:over_react/over_react.dart';

import '../general/TileType.dart';

import 'GUI.dart';
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
        ..className = "title")()

        ,

      (ReactPlayerState()
        ..gui = props.gui
        ..player = TileType.PLAYER_ONE)()

        ,

      (ReactPlayerState()
        ..gui = props.gui
        ..player = TileType.PLAYER_TWO)()

        ,

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