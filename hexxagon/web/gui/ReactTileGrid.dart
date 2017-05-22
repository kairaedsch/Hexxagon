import '../game/Hexxagon.dart';
import '../general/TilePosition.dart';
import 'Move.dart';
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
  Hexxagon hexxagon;
}

@Component()
class ReactTileGridComponent extends UiComponent<ReactTileGridProps>
{
  ReactElement render()
  {
    List<ReactElement> tiles = new List(props.hexxagon.height);
    for (int y = 0; y < props.hexxagon.height; y++)
    {
      tiles[y] = (ReactTileRow()
        ..y = y
        ..tileGrid = this
        ..hexxagon = props.hexxagon
      )();
    }
    return (Dom.div()
      ..className = "tileGrid clearfix"
    )(
        tiles
    );
  }

  void setSelected(TilePosition tileposition)
  {
    props.children.forEach((row)
    => row.setSelected(props.hexxagon.getPossibleMoves(tileposition)));
  }
}