import 'package:over_react/over_react.dart';

import '../../../general/TilePosition.dart';

import '../logic/GUI.dart';
import '../logic/GameGUI.dart';
import '../logic/HexagonGrid.dart';
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
  HexagonGrid hexagonGrid;
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
            ..hexagonGrid = props.hexagonGrid
          )();
    }
    return (Dom.div()
      ..className = "tileRow"
      ..style =
      {
        "marginLeft": (props.y % 2) == 0 ? "${props.hexagonGrid.rowEvenMarginLeft}px" : "${props.hexagonGrid.rowOddMarginLeft}px",
      }
    )(
        tiles
    );
  }
}