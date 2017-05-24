import '../game/Hexxagon.dart';
import '../general/TilePosition.dart';
import 'BoardGUI.dart';
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
  BoardGUI boardGUI;
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
    props.boardGUI.changeListener = () => setState(state);
  }

  ReactElement render()
  {
    List<ReactElement> tiles = new List(props.boardGUI.height);
    for (int y = 0; y < props.boardGUI.height; y++)
    {
      tiles[y] = (ReactTileRow()
        ..key = y
        ..y = y
        ..tileGrid = this
        ..boardGUI = props.boardGUI
      )();
    }
    return (Dom.div()
      ..className = "tileGrid clearfix"
    )(
        tiles
    );
  }
}