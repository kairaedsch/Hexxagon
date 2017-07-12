import 'dart:html';

import 'package:over_react/over_react.dart';

import '../logic/GUI.dart';
import '../logic/GameGUI.dart';
import '../logic/HexagonGrid.dart';
import 'ReactTileRow.dart';

@Factory()
UiFactory<ReactTileGridProps> ReactTileGrid;

@Props()
class ReactTileGridProps extends UiProps
{
  GUI gui;
}

@State()
class ReactTileGridState extends UiState
{
}

@Component()
class ReactTileGridComponent extends UiStatefulComponent<ReactTileGridProps, ReactTileGridState>
{
  int currentRows = 0;
  int currentColumns = 0;

  void componentWillMount()
  {
    super.componentWillMount();
    props.gui.addGameChangeListener(()
    {
      GameGUI gameGUI = props.gui.currentGameGui;

      if (currentRows != gameGUI.height || currentColumns != gameGUI.width)
      {
        setState(state);
      }
    });
    window.addEventListener("resize", (e)
    => setState(state));
  }

  ReactElement render()
  {
    var container = querySelector(".tileGridContainer");
    if (props.gui.currentGameGui == null)
    {
      return Dom.div()();
    }
    GameGUI gameGUI = props.gui.currentGameGui;

    currentRows = gameGUI.height;
    currentColumns = gameGUI.width;

    var width = container.offsetWidth;
    var height = container.offsetHeight;
    List<ReactElement> tiles = new List(gameGUI.height);
    HexagonGrid hexagonGrid = new HexagonGrid(width, height, gameGUI.width, gameGUI.height);
    for (int y = 0; y < gameGUI.height; y++)
    {
      tiles[y] = (ReactTileRow()
        ..key = y
        ..y = y
        ..tileGrid = this
        ..gui = props.gui
        ..hexagonGrid = hexagonGrid
      )();
    }
    return (Dom.div()
      ..className = "tileGrid clearfix"
      ..style =
      {
        "width": "${hexagonGrid.gridWidth}px",
        "height": "${hexagonGrid.gridHeight}px",
        "marginTop": "calc((81vh - ${hexagonGrid.gridHeight}px) / 2)",
        "marginLeft": "${(width - hexagonGrid.gridWidthIfRound) / 2}px"
      }
    )(
        tiles
    );
  }
}