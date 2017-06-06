import '../game/Hexxagon.dart';
import '../general/TilePosition.dart';
import 'GameGUI.dart';
import '../general/Move.dart';
import 'Hexagon.dart';
import 'ReactTileGrid.dart';
import '../general/TileType.dart';
import 'dart:html';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' as react_client;
import 'package:over_react/over_react.dart';
import 'ReactTile.dart';

@Factory()
UiFactory<ReactTileRowProps> ReactTileRow;

@Props()
class ReactTileRowProps extends UiProps
{
  int y;
  GameGUI gameGUI;
  ReactTileGridComponent tileGrid;
  Hexagon hexagon;
}

@Component()
class ReactTileRowComponent extends UiComponent<ReactTileRowProps>
{
  ReactElement render()
  {
    List<ReactElement> tiles = new List(props.gameGUI.width);
    for (int x = 0; x < props.gameGUI.width; x++)
    {
      tiles[x] =
          (ReactTile()
            ..key = x
            ..tileGrid = props.tileGrid
            ..position = TilePosition.get(x, props.y)
            ..boardGUI = props.gameGUI
            ..hexagon = props.hexagon
          )();
    }
    return (Dom.div()
      ..className = "tileRow"
      ..style =
      {
        "marginLeft": (props.y % 2) == 0 ? "${props.hexagon.rowEvenMarginLeft}px" : "${props.hexagon.rowOddMarginLeft}px",
      }
    )(
        tiles
    );
  }
}