import 'package:over_react/over_react.dart';

import '../../../general/TilePosition.dart';

import '../logic/GUI.dart';
import '../logic/GameGUI.dart';
import '../logic/Hexagon.dart';
import 'ReactTile.dart';
import 'ReactTileGrid.dart';

@Factory()
UiFactory<ReactTileRowProps> ReactTileRow;

@Props()
class ReactTileRowProps extends UiProps
{
  int y;
  GUI gui;
  ReactTileGridComponent tileGrid;
  Hexagon hexagon;
}

@Component()
class ReactTileRowComponent extends UiComponent<ReactTileRowProps>
{
  ReactElement render()
  {
    GameGUI gameGUI = props.gui.currentGameGui;
    List<ReactElement> tiles = new List(gameGUI.width);
    for (int x = 0; x < gameGUI.width; x++)
    {
      tiles[x] =
          (ReactTile()
            ..key = x
            ..tileGrid = props.tileGrid
            ..position = TilePosition.get(x, props.y)
            ..gui = props.gui
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