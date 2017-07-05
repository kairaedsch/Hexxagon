import 'dart:html';
import 'package:over_react/over_react.dart';

import '../../general/TileType.dart';

import '../GUI.dart';
import 'ReactPlayerState.dart';

@Factory()
UiFactory<ReactGameSidePanelProps> ReactGameSidePanel;

@Props()
class ReactGameSidePanelProps extends UiProps
{
  GUI gui;
}

@State()
class ReactGameSidePanelState extends UiState
{
}

@Component()
class ReactGameSidePanelComponent extends UiStatefulComponent<ReactGameSidePanelProps, ReactGameSidePanelState>
{
  void componentWillMount()
  {
    super.componentWillMount();
    props.gui.addGameChangeListener(()
    => setState(state));
    props.gui.addStateChangeListener(()
    => setState(state));

    querySelector('.button.abort').onClick.forEach((e)
    {
      props.gui.selectPlayer();
    });
  }

  ReactElement render()
  {
    if (props.gui.currentGameGui == null)
    {
      return Dom.div()();
    }

    return (Dom.div()
      ..className = "sideInner clearfix"
    )(
      (ReactPlayerState()
        ..gui = props.gui
        ..player = TileType.PLAYER_ONE)()
        ,
      (ReactPlayerState()
        ..gui = props.gui
        ..player = TileType.PLAYER_TWO)()
    );
  }
}