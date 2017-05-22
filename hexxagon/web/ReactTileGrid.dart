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
  int coloumCount;
  int height;
}


@Props()
class ReactTileGridState extends UiState
{
  List<Move> moves;
}

@Component()
class ReactTileGridComponent
    extends UiStatefulComponent<ReactTileGridProps, ReactTileGridState>
{
  ReactElement render()
  {
    List<ReactElement> tiles = [];
    for (int y = 0; y < props.height; y++)
    {
      tiles.add((ReactTileRow()
        ..coloumCount = props.coloumCount
        ..moves = state.moves
        ..y = y
      )());
    }
    return (Dom.div()
      ..className = "tileGrid clearfix"
    )(
        tiles
    );
  }

  void setMoves(List<Move> moves)
  {
    setState({"moves": moves});
  }
}