import '../../../general/Board.dart';
import '../../../general/Intelligence.dart';
import '../logic/GameGUI.dart';
import 'package:over_react/over_react.dart';

import '../../../general/TileType.dart';

import '../logic/GUI.dart';

@Factory()
UiFactory<ReactGameTopInfoProps> ReactGameTopInfo;

@Props()
class ReactGameTopInfoProps extends UiProps
{
  /// The GUI which always contains the current GUI state with data.
  GUI gui;
}

@State()
class ReactGameTopInfoState extends UiState
{
}

/// React Component to display the top info with player and score during the game.
@Component()
class ReactGameTopInfoComponent extends UiStatefulComponent<ReactGameTopInfoProps, ReactGameTopInfoState>
{
  @override
  void componentWillMount()
  {
    super.componentWillMount();
    props.gui.addGameChangeListener(() => setState(state));
    props.gui.addGUIStateChangeListener(() => setState(state));
  }

  @override
  ReactElement render()
  {
    GameGUI gameGui = props.gui.currentGameGui;
    if (gameGui == null)
    {
      return Dom.div()();
    }

    Intelligence<Board> intelligenceplayerOne = gameGui.getIntelligence(TileType.PLAYER_ONE);
    Intelligence<Board> intelligenceplayerTwo = gameGui.getIntelligence(TileType.PLAYER_TWO);
    TileType betterPlayer = gameGui.betterPlayer;
    bool draw = betterPlayer == TileType.EMPTY;

    return (Dom.div()
      ..className = "sideInner clearfix"
    )(
        (Dom.div()
          ..className = "topInfoOverview"
              " ${gameGui.isOver ? "gameIsOver ${TileTypes.toName(betterPlayer)}" : "turn ${TileTypes.toName(gameGui.currentPlayer)}"}"
        )(
            (Dom.div()
              ..className = "topInfoPart"
              ..title = intelligenceplayerOne.name
            )(
                (Dom.div()
                  ..className = "topInfoPartScore"
                  ..title = "Score of the blue player"
                )(
                    gameGui.scoreOfPlayer(TileType.PLAYER_ONE)
                ),
                (Dom.div()
                  ..className = "topInfoPartImage"
                  ..style =
                  {
                    "backgroundImage": "url('images/${intelligenceplayerOne.isHuman ? "human.png" : "robot-${intelligenceplayerOne.strength}.png"}')",
                  }
                  ..title = intelligenceplayerOne.isHuman ? "Human" : "AI ${intelligenceplayerOne.strengthName} - ${intelligenceplayerOne.name}"
                )()
            )
            ,
            (Dom.div()
              ..className = "topInfoBetween"
            )(
                (Dom.div()
                  ..className = "topInfoBetweenInner"
                )(
                    !gameGui.isOver ? "VS" : (draw ? "" : (betterPlayer == TileType.PLAYER_ONE ? "BLUE" : "ORANGE")),
                    !gameGui.isOver ? "" : Dom.br()(),
                    !gameGui.isOver ? "" : (draw ? "DRAW" : "WON")
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
                    "backgroundImage": "url('images/${intelligenceplayerTwo.isHuman ? "human.png" : "robot-${intelligenceplayerTwo.strength}.png"}')",
                  }
                  ..title = intelligenceplayerTwo.isHuman ? "Human" : "AI ${intelligenceplayerTwo.strengthName} - ${intelligenceplayerTwo.name}"
                )(),
                (Dom.div()
                  ..className = "topInfoPartScore"
                  ..title = "Score of the orange player"
                )(
                    gameGui.scoreOfPlayer(TileType.PLAYER_TWO)
                )
            )
        ),
        (Dom.div()
          ..className = "abort button"
          ..title = "Back to main menu"
        )(
            (Dom.div()
              ..className = "abortInner"
                ..onClick = (e) => props.gui.showMainMenu()
            )()
        )
    );
  }
}