import 'package:over_react/over_react.dart';

import '../../general/TileType.dart';

import '../GUI.dart';

@Factory()
UiFactory<ReactPlayerStateProps> ReactPlayerState;

@Props()
class ReactPlayerStateProps extends UiProps
{
  GUI gui;
  int player;
}

@State()
class ReactPlayerStateState extends UiState
{
}

@Component()
class ReactPlayerStateComponent extends UiStatefulComponent<ReactPlayerStateProps, ReactPlayerStateState>
{
  void componentWillMount()
  {
    super.componentWillMount();
    props.gui.addGameChangeListener(()
    => setState(state));
  }

  ReactElement render()
  {
    List<ReactElement> stats = [];

    props.gui.currentGameGui.getStatsOf(props.player).forEach((String name, String value)
    {
      stats.add(
          (Dom.div()
            ..className = "playerStatsEntry clearfix"
              ..key = name
          )(
            (Dom.div()
              ..className = "playerStatsEntryName"
            )(
                name
            ),
            (Dom.div()
              ..className = "playerStatsEntryValue"
            )(
                value
            ),
          )
      );
    });

    return (Dom.div()
      ..className = " playerStats"
          " ${props.player == TileType.PLAYER_ONE ? "PLAYER_ONE" : "PLAYER_TWO"}"
          " ${(!props.gui.currentGameGui.isOver && (props.gui.currentGameGui.currentPlayer == props.player)) ? "hisTurn" : ""}"
          " ${(props.gui.currentGameGui.isOver && (props.gui.currentGameGui.betterPlayer == props.player)) ? "won" : ""}"
    )(
      (Dom.div()
        ..className = "playerStatsName"
      )(
          props.gui.currentGameGui
              .getIntelligence(props.player)
              .name
      ),
      (Dom.div()
        ..className = "playerStatsList"
      )(
          stats
      ),
    );
  }
}