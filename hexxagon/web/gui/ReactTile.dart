import '../game/Hexxagon.dart';
import 'GameGUI.dart';
import '../general/Move.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'Hexagon.dart';
import 'ReactTileGrid.dart';
import 'dart:async';
import 'dart:html';
import 'package:optional/optional_internal.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' as react_client;
import 'package:over_react/over_react.dart';
import 'dart:async';

@Factory()
UiFactory<ReactTileProps> ReactTile;

@Props()
class ReactTileProps extends UiProps
{
  ReactTileGridComponent tileGrid;
  TilePosition position;
  GameGUI boardGUI;
  Hexagon hexagon;
}

@State()
class ReactTileState extends UiState
{
  Optional<Point<int>> lastMouseDownPos;
  Point<int> delta;
  bool firstTimeUp;
  bool mouseIsOver;
}

@Component()
class ReactTileComponent extends UiStatefulComponent<ReactTileProps, ReactTileState>
{
  StreamSubscription l1, l2, l3;

  bool get isPlayAbleNow
  {
    return props.boardGUI.isSomethingSelected
        && props.boardGUI.possibleMoves.any((Move move)
        => move.target.equals(props.position));
  }

  bool get isDragging
  {
    return (state.delta.x.abs() > 20 || state.delta.y.abs() > 20);
  }

  @override
  getInitialState()
  {
    return (newState()
      ..lastMouseDownPos = new Optional.empty()
      ..delta = new Point(0, 0)
      ..firstTimeUp = false
      ..mouseIsOver = false
    );
  }

  @override
  componentDidMount()
  {
    l3 = window.document.onMouseUp.listen((event)
    => onMouseUp());
    l1 = window.document.onMouseUp.listen((event)
    => endDrag(null));
    l2 = window.document.onMouseMove.listen((event)
    => mouseMoved(event.screen));
    l1.pause();
    l2.pause();
    l3.pause();
  }

  ReactElement render()
  {
    int tileType = props.boardGUI.get(props.position);
    bool playAble = props.boardGUI.couldBeMoved(props.position) && props.boardGUI.currentPlayer.isHuman;
    bool playAbleOfNotCurrentPlayer = !playAble && tileType == props.boardGUI.getNotCurrentPlayer();

    bool isSelected = false;
    Optional<Move> move = new Optional.empty();
    if (props.boardGUI.isSomethingSelected)
    {
      move = new Optional.ofNullable(props.boardGUI.possibleMoves.firstWhere((Move move)
      => move.target.equals(props.position), orElse: ()
      => null));
      isSelected = props.boardGUI.selectedPosition.equals(props.position);
    }

    bool isLastMoveSource = false;
    bool isLastMoveTarget = false;
    if (props.boardGUI.lastMove.isPresent)
    {
      isLastMoveSource = props.boardGUI.lastMove.value.source.equals(props.position);
      isLastMoveTarget = props.boardGUI.lastMove.value.target.equals(props.position);
    }
    bool isTranslated = state.delta.x != 0 || state.delta.y != 0;

    Map<String, String> textStyle =
    {
      "marginTop": "-${props.hexagon.tileHeight}px",
      "width": "${props.hexagon.tileWidth}px",
      "height": "${props.hexagon.tileHeight}px",
      "fontSize": "${props.hexagon.tileWidth / 5.5}px",
      "lineHeight": "${props.hexagon.tileHeight}px",
    };

    return (Dom.div()
      ..className = "hexagon "
          " ${isLastMoveSource ? "lastMoveSource" : ""}"
          " ${isLastMoveTarget ? "lastMoveTarget" : ""}"
          " ${move.isPresent ? move.value.kindOf : ""}"
          " ${playAble ? "playAble" : (playAbleOfNotCurrentPlayer ? "notPlayAble" : "")}"
          " ${isPlayAbleNow ? "playAbleNow playAbleNow${TileType.toName(props.boardGUI.getCurrentPlayer())}" : ""}"
          " ${TileType.toName(tileType)}"
          " ${isSelected ? "selected" : ""}"
          " ${state.mouseIsOver ? "mouseIsOver" : ""}"
          " ${isDragging ? "dragging" : ""}"
          " posy_${props.position.getMaxDistanceTo(TilePosition.get(0, 0))}"
      ..style =
      {
        "transform": (isTranslated ? "translate(${state.delta.x}px, ${state.delta.y}px)" : "none"),
        "marginLeft": "${props.hexagon.tileMarginLeft}px",
        "marginTop": "${props.hexagon.tileMarginTop}px",
        "width": "${props.hexagon.tileWidth}px",
        "height": "${props.hexagon.tileHeight}px"
      }
    )(
        (Dom.svg()
          ..version = "1.1"
          ..height = props.hexagon.tileHeight
          ..width = props.hexagon.tileWidth
          ..viewBox = "0 0 726 628"
          ..style =
          {
            "marginBottom": "${-props.hexagon.borderRows * 3}px",
          }
        )(
            (Dom.polygon()
              ..points = "723,314 543,625.769145 183,625.769145 3,314 183,2.230855 543,2.230855 723,314"
              ..className = "hexagonInner"
              ..onMouseDown = this.startDrag
              ..onMouseEnter = onMouseEnter
              ..onMouseLeave = onMouseLeave
            )()
        ),
        (Dom.div()
          ..className = "hexagonInnerText"
          ..style = textStyle
        )((isLastMoveSource || isLastMoveTarget) ? props.boardGUI.lastMove.value.kindOf : ""),
        (Dom.div()
          ..className = "hexagonInnerText positions"
          ..style = textStyle
        )("${props.position.x} - ${props.position.y}")
    );
  }

  void select(SyntheticMouseEvent event)
  {
    Optional<Move> move;
    if (props.boardGUI.isSomethingSelected)
    {
      move = new Optional.ofNullable(props.boardGUI.possibleMoves.firstWhere((Move move)
      => move.target.equals(props.position), orElse: ()
      => null));
    }
    else
    {
      move = new Optional.empty();
    }

    if (move.isPresent)
    {
      props.boardGUI.move(move.value);
    }
    else
    {
      props.boardGUI.select(props.position);
    }
  }

  mouseMoved(Point screenPos)
  {
    this.setState((Map prevState, Map props)
    {
      ReactTileState reactTileState = newState()
        ..addAll(prevState);
      if (reactTileState.lastMouseDownPos.isPresent)
      {
        Point<int> lastMouseDownPos = reactTileState.lastMouseDownPos.value;
        Point<int> newMouseDownPos = new Point(screenPos.x, screenPos.y);
        //print("de ${lastMouseDownPos} ${newMouseDownPos}");
        return (newState()
          ..lastMouseDownPos = new Optional.of(newMouseDownPos)
          ..delta = reactTileState.delta + newMouseDownPos - lastMouseDownPos);
      }
      else
      {
        return prevState;
      }
    });
  }

  startDrag(SyntheticMouseEvent event)
  {
    if (props.boardGUI.currentPlayer.isHuman)
    {
      bool firstTimeUp = false;
      if (!props.boardGUI.isSomethingSelected || !props.boardGUI.selectedPosition.equals(props.position))
      {
        select(null);
        firstTimeUp = true;
      }
      if (props.boardGUI.isSomethingSelected && props.boardGUI.selectedPosition.equals(props.position))
      {
        l1.resume();
        l2.resume();
        setState((newState()
          ..lastMouseDownPos = new Optional.of(new Point(event.screenX, event.screenY))
          ..delta = new Point(0, 0)
          ..firstTimeUp = firstTimeUp
        ));
      }
    }
  }

  endDrag(Point screenPos)
  {
    Timer.run(()
    {
      l1.pause();
      l2.pause();
      this.setState((Map prevState, Map props)
      {
        ReactTileState reactTileState = newState()
          ..addAll(prevState);
        if (isDragging || !reactTileState.firstTimeUp)
        {
          select(null);
        }
        return (newState()
          ..lastMouseDownPos = new Optional.empty()
          ..delta = new Point(0, 0)
          ..firstTimeUp = false);
      });
    });
  }

  onMouseUp()
  {
    if (isPlayAbleNow)
    {
      select(null);
    }
    setState((newState()
      ..mouseIsOver = false
    ));
    l3.pause();
  }

  onMouseEnter(SyntheticMouseEvent event)
  {
    if (isPlayAbleNow)
    {
      setState((newState()
        ..mouseIsOver = true
      ));
      l3.resume();
    }
  }

  onMouseLeave(SyntheticMouseEvent event)
  {
    if (isPlayAbleNow)
    {
      setState((newState()
        ..mouseIsOver = false
      ));
      l3.pause();
    }
  }
}