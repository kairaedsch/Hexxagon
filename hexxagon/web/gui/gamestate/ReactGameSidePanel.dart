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
        (Dom.div()
          ..className = "topInfoOverview topInfoPlayerOverview"
        )(
            (Dom.div()
              ..className = "topInfoPart"
            )(
                (Dom.div()
                  ..className = "topInfoPartInner"
                )(
                    props.gui.currentGameGui
                        .getIntelligence(TileType.PLAYER_ONE)
                        .name
                )
            )
            ,
            (Dom.div()
              ..className = "topInfoBetween"
            )(
                (Dom.div()
                  ..className = "topInfoBetweenInner"
                )(
                    "VS"
                )
            )
            ,
            (Dom.div()
              ..className = "topInfoPart"
            )(
                (Dom.div()
                  ..className = "topInfoPartInner"
                )(
                    props.gui.currentGameGui
                        .getIntelligence(TileType.PLAYER_TWO)
                        .name
                )
            )
        ),
        (Dom.div()
          ..className = "topInfoOverview topInfoPointsOverview"
        )(
            (Dom.div()
              ..className = "topInfoPart"
            )(
                (Dom.div()
                  ..className = "topInfoPartInner"
                )(
                    props.gui.currentGameGui.getStatsOf(TileType.PLAYER_ONE)["Steine"]
                )
            )
            ,
            (Dom.div()
              ..className = "topInfoBetween"
            )(
                (Dom.div()
                  ..className = "topInfoBetweenInner"
                )(
                    "-"
                )
            )
            ,
            (Dom.div()
              ..className = "topInfoPart"
            )(
                (Dom.div()
                  ..className = "topInfoPartInner"
                )(
                    props.gui.currentGameGui.getStatsOf(TileType.PLAYER_TWO)["Steine"]
                )
            )
        )
    );
  }
}