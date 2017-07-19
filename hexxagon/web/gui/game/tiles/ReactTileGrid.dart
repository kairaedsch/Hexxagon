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
  /// The current amount of tile rows displayed.
  int currentRows;

  /// The current amount of tile columns displayed.
  int currentColumns;
}

/// React Component to display a grid of hexagon tiles.
@Component()
class ReactTileGridComponent extends UiStatefulComponent<ReactTileGridProps, ReactTileGridState>
{
  @override
  void componentWillMount()
  {
    super.componentWillMount();
    props.gui.addGameChangeListener(()
    {
      GameGUI gameGUI = props.gui.currentGameGui;

      if (state.currentRows != gameGUI.height || state.currentColumns != gameGUI.width)
      {
        setState((newState()
          ..currentRows = gameGUI.height
          ..currentColumns = gameGUI.width
        ));
      }
    });
    window.addEventListener("resize", (e) => setState(state));
  }

  @override
  getInitialState()
  {
    return (newState()
      ..currentRows = 0
      ..currentColumns = 0
    );
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