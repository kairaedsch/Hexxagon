import '../game/Hexxagon.dart';
import '../general/TilePosition.dart';
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
  GameGUI gameGUI;
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
    props.gameGUI.changeListener = ()
    => setState(state);
    window.addEventListener("resize", (e)
    => setState(state));
  }

  ReactElement render()
  {
    var container = querySelector(".tileGridContainer");
    var width = container.offsetWidth;
    var height = container.offsetHeight;
    List<ReactElement> tiles = new List(props.gameGUI.height);
    Hexagon hexagon = new Hexagon(width, height, props.gameGUI.width * 2, props.gameGUI.height);
    for (int y = 0; y < props.gameGUI.height; y++)
    {
      tiles[y] = (ReactTileRow()
        ..key = y
        ..y = y
        ..tileGrid = this
        ..gameGUI = props.gameGUI
        ..hexagon = hexagon
      )();
    }
    return (Dom.div()
      ..className = "tileGrid clearfix"
      ..style =
      {
        "width": "${width}px",
        "paddingTop": "${hexagon.gridPaddingTop}px",
      }
    )(
        tiles
    );
  }
}