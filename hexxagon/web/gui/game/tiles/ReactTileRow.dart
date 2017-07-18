import 'package:over_react/over_react.dart';

import '../../../general/TilePosition.dart';

import '../logic/GUI.dart';
import '../logic/GameGUI.dart';
import '../logic/HexagonGrid.dart';
import 'ReactTile.dart';

@Factory()
UiFactory<ReactTileRowProps> ReactTileRow;

@Props()
class ReactTileRowProps extends UiProps
{
  /// The y-pos of this row.
  int y;

  /// The GUI which always contains the current GUI state with data.
  GUI gui;

  /// The HexagonGrid for the sizes and margins.
  HexagonGrid hexagonGrid;
}

/// React Component to display a row of hexagon tiles.
@Component()
class ReactTileRowComponent extends UiComponent<ReactTileRowProps>
{
  @override
  ReactElement render()
  {
    GameGUI gameGUI = props.gui.currentGameGui;
    List<ReactElement> tiles = new List(gameGUI.width);
    for (int x = 0; x < gameGUI.width; x++)
    {
      tiles[x] =
          (ReactTile()
            ..key = x
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