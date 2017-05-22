import '../game/Hexxagon.dart';
import '../general/TilePosition.dart';
import 'Move.dart';
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
  Hexxagon hexxagon;
  ReactTileGridComponent tileGrid;
}

@Component()
class ReactTileRowComponent extends UiComponent<ReactTileRowProps>
{
  ReactElement render()
  {
    List<ReactElement> tiles = new List(props.hexxagon.width);
    for (int x = 0; x < props.hexxagon.width; x++)
    {
      tiles[x] =
          (ReactTile()
            ..tileGrid = props.tileGrid
            ..position = new TilePosition(x, props.y)
            ..hexxagon = props.hexxagon
          )();
    }
    return (Dom.div()
      ..className = "tileRow"
    )(
        tiles
    );
  }

  void setSelected(List<Move> possibleMoves)
  {
    props.children.forEach((tile) => tile.setSelected(possibleMoves));
  }
}