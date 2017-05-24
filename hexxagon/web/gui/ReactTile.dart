import '../game/Hexxagon.dart';
import 'BoardGUI.dart';
import 'Move.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'ReactTileGrid.dart';
import 'dart:html';
import 'package:optional/optional_internal.dart';
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
  BoardGUI boardGUI;
}

@Component()
class ReactTileComponent extends UiComponent<ReactTileProps>
{
  ReactElement render()
  {
    TileType tileType = props.boardGUI.get(props.position);
    bool playAble = props.boardGUI.couldBeMoved(props.position);
    bool playAbleOfNotCurrentPlayer = !playAble && tileType == props.boardGUI.getNotCurrentPlayer();

    bool playAbleNow;
    bool isSelected;
    Optional<Move> move;
    if (props.boardGUI.isSomethingSelected)
    {
      move = new Optional.ofNullable(props.boardGUI.possibleMoves.firstWhere((Move move)
      => move.tilePosition.equals(props.position), orElse: ()
      => null));
      playAbleNow = move.isPresent;
      isSelected = props.boardGUI.selectedPosition.equals(props.position);
    }
    else
    {
      move = new Optional.empty();
      playAbleNow = move.isPresent;
      isSelected = false;
    }

    return (Dom.div()
      ..className = "hexagon ${move.isPresent ? move.value.kindOf : ""} ${playAble ? "playAble" : (playAbleOfNotCurrentPlayer ? "notPlayAble" : "")} ${playAbleNow ? "playAbleNow" : ""} ${tileType.toString().replaceAll(".", " ")} ${isSelected ? "selected" : ""}"
      ..onClick = this.select
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
    Optional<Move> move;
    if (props.boardGUI.isSomethingSelected)
    {
      move = new Optional.ofNullable(props.boardGUI.possibleMoves.firstWhere((Move move)
      => move.tilePosition.equals(props.position), orElse: ()
      => null));
    }
    else
    {
      move = new Optional.empty();
    }

    if (move.isPresent)
    {
      props.boardGUI.move(props.position);
    }
    else
    {
      props.boardGUI.select(props.position);
    }
  }
}