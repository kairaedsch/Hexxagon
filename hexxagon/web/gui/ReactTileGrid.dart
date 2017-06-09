import '../game/Hexxagon.dart';
import '../general/TilePosition.dart';
import 'GUI.dart';
import 'GameGUI.dart';
import '../general/Move.dart';
import 'Hexagon.dart';
import 'dart:html';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' as react_client;
import 'package:over_react/over_react.dart';
import 'ReactTile.dart';
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
  void componentWillMount()
  {
    super.componentWillMount();
    props.gui.addGameChangeListener(()
    => setState(state));
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
    var width = container.offsetWidth;
    var height = container.offsetHeight;
    List<ReactElement> tiles = new List(gameGUI.height);
    Hexagon hexagon = new Hexagon(width, height, gameGUI.width * 2, gameGUI.height);
    for (int y = 0; y < gameGUI.height; y++)
    {
      tiles[y] = (ReactTileRow()
        ..key = y
        ..y = y
        ..tileGrid = this
        ..gameGUI = gameGUI
        ..hexagon = hexagon
      )();
    }
    return (Dom.div()
      ..className = "tileGrid clearfix"
      ..style =
      {
        "width": "${hexagon.gridWidth}px",
        "paddingTop": "calc((100vh - 100px * 2 - ${hexagon.gridheight}px) / 2)",
      }
    )(
        tiles
    );
  }
}