import '../../general/Board.dart';
import '../../general/Intelligence.dart';
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

    Intelligence<Board> intelligenceplayerOne = props.gui.currentGameGui.getIntelligence(TileType.PLAYER_ONE);
    Intelligence<Board> intelligenceplayerTwo = props.gui.currentGameGui.getIntelligence(TileType.PLAYER_TWO);

    return (Dom.div()
      ..className = "sideInner clearfix"
    )(
        (Dom.div()
          ..className = "topInfoOverview"
        )(
            (Dom.div()
              ..className = "topInfoPart"
              ..title = intelligenceplayerOne.name
            )(
                (Dom.div()
                  ..className = "topInfoPartInner"
                  ..style =
                  {
                    "backgroundImage": "url('${intelligenceplayerOne.isHuman ? "human.png" : "robot-${intelligenceplayerOne.strength}.png"}')",
                  }
                  ..title = intelligenceplayerOne.name
                )()
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
                  ..style =
                  {
                    "backgroundImage": "url('${intelligenceplayerTwo.isHuman ? "human.png" : "robot-${intelligenceplayerTwo.strength}.png"}')",
                  }
                  ..title = intelligenceplayerTwo.name
                )()
            )
        )
    );
  }
}