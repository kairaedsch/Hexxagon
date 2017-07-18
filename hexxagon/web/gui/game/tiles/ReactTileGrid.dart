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
  /// The GUI which always contains the current GUI state with data.
  GUI gui;
}

@State()
class ReactTileGridState extends UiState
{
}

/// React Component to display a grid of hexagon tiles.
@Component()
class ReactTileGridComponent extends UiStatefulComponent<ReactTileGridProps, ReactTileGridState>
{
  // TODO set as state
  int currentRows = 0;
  int currentColumns = 0;

  @override
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
    window.addEventListener("resize", (e) => setState(state));
  }

  @override
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
        ..gui = props.gui
        ..hexagonGrid = hexagonGrid
      )();
    }
    return (Dom.div()
      ..className = "tileGrid clearfix"
      ..style =
      {
        "width": "${hexagonGrid.gridWidth + 1}px",
        "height": "${hexagonGrid.gridHeight}px",
        "marginTop": "calc((81vh - ${hexagonGrid.gridHeight}px) / 2)",
        "marginLeft": "${(width - hexagonGrid.gridWidthIfRound) / 2}px"
      }
    )(
        tiles
    );
  }
}