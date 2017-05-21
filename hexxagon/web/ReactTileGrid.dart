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
  int width;
  int height;
}

@Component()
class ReactTileGridComponent extends UiComponent<ReactTileGridProps>
{
  ReactElement render()
  {
    List<ReactElement> tiles = [];
    for (int h = 0; h < props.height; h++)
    {
      tiles.add((ReactTileRow()..width = props.width)());
    }
    return (Dom.div()
      ..className = "tileGrid clearfix"
    )(
        tiles
    );
  }
}