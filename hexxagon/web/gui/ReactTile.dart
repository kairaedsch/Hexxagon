import '../game/Hexxagon.dart';
import 'Move.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'ReactTileGrid.dart';
import 'dart:html';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' as react_client;
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactTileProps> ReactTile;

@Props()
class ReactTileProps extends UiProps
{
  ReactTileGridComponent tileGrid;
  TilePosition position;
  Hexxagon hexxagon;
}

@State()
class ReactTileState extends UiState
{
  TileType tileType;
  bool playAble;
  bool playAbleNow;
  Move move;
}

@Component()
class ReactTileComponent
    extends UiStatefulComponent<ReactTileProps, ReactTileState>
{
  @override
  void componentDidMount() {
    state.tileType = props.hexxagon.get(props.position);
    state.playAble = false;
    state.playAbleNow = false;
    state.move = null;
  }

  ReactElement render()
  {
    return (Dom.div()
      ..className = "hexagon ${state.move != null ? state.move.kindOf : ""}"
      ..onMouseEnter = this.select
    )(
        (Dom.svg()
          ..version = "1.1"
          ..height = 104
          ..width = 120
          ..viewBox = "0 0 726 628"
        )(
            (Dom.polygon()
              ..points = "723,314 543,625.769145 183,625.769145 3,314 183,2.230855 543,2.230855 723,314"
              ..className = "hexagonInner"
            )()
        )
    );
  }

  void select(SyntheticMouseEvent event)
  {
    if (state.playAbleNow)
    {
      props.hexxagon.move(state.move.tilePosition, props.position);
    }
    else
    {
      props.tileGrid.setSelected(props.position);
    }
  }

  void setSelected(List<Move> possibleMoves)
  {
    var move = possibleMoves.firstWhere((move)
    => move.tilePosition.equals(props.position), orElse: ()
    => null);

    if (move != null)
    {
      setState({"tileType": props.hexxagon.get(props.position), "playAbleNow": true, "move": move});
    }
    else
    {
      setState({"tileType": props.hexxagon.get(props.position), "playAbleNow": false});
    }
  }
}