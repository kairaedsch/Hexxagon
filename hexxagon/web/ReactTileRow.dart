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
  int width;
}

@Component()
class ReactTileRowComponent extends UiComponent<ReactTileRowProps>
{
  ReactElement render()
  {
    List<ReactElement> tiles = [];
    for (int i = 0; i < props.width; i++)
    {
      tiles.add((ReactTile()..width = "10%")());
    }
    return (Dom.div()
      ..className = "tileRow"
    )(
        tiles
    );
  }
}