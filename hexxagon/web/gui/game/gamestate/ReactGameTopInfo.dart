import '../../../general/Board.dart';
import '../../../general/Intelligence.dart';
import 'dart:html';
import 'package:over_react/over_react.dart';

import '../../../general/TileType.dart';

import '../logic/GUI.dart';

@Factory()
UiFactory<ReactGameTopInfoProps> ReactGameTopInfo;

@Props()
class ReactGameTopInfoProps extends UiProps
{
  GUI gui;
}

@State()
class ReactGameTopInfoState extends UiState
{
}

@Component()
class ReactGameTopInfoComponent extends UiStatefulComponent<ReactGameTopInfoProps, ReactGameTopInfoState>
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
            " ${props.gui.currentGameGui.isOver ? "won ${TileTypes.toName(props.gui.currentGameGui.betterPlayer)}" : "turn ${TileTypes.toName(props.gui.currentGameGui.currentPlayer)}"}"
        )(
            (Dom.div()
              ..className = "topInfoPart"
              ..title = intelligenceplayerOne.name
            )(
                (Dom.div()
                  ..className = "topInfoPartScore"
                  ..title = "Score"
                )(
                    props.gui.currentGameGui.countTilesOfType(TileType.PLAYER_ONE)
                ),
                (Dom.div()
                  ..className = "topInfoPartImage"
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
                  ..className = "topInfoPartImage"
                  ..style =
                  {
                    "backgroundImage": "url('${intelligenceplayerTwo.isHuman ? "human.png" : "robot-${intelligenceplayerTwo.strength}.png"}')",
                  }
                  ..title = intelligenceplayerTwo.name
                )(),
                (Dom.div()
                  ..className = "topInfoPartScore"
                  ..title = "Score"
                )(
                    props.gui.currentGameGui.countTilesOfType(TileType.PLAYER_TWO)
                )
            )
        )
    );
  }
}