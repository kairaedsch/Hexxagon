import 'dart:async';
import 'dart:html';

import 'package:optional/optional_internal.dart';
import 'package:over_react/over_react.dart';

import '../../../general/Move.dart';
import '../../../general/TilePosition.dart';
import '../../../general/TileType.dart';

import '../logic/GUI.dart';
import '../logic/HexagonGrid.dart';
import 'ReactTileGrid.dart';

@Factory()
UiFactory<ReactTileProps> ReactTile;

@Props()
class ReactTileProps extends UiProps
{
  ReactTileGridComponent tileGrid;
  TilePosition position;
  GUI gui;
  HexagonGrid hexagonGrid;
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

  bool currentIsPlayAbleNow = false;
  bool currentIsSelected = false;
  TileType currentTileType = null;

  bool get isPlayAbleNow
  {
    return props.gui.currentGameGui.isSomethingSelected
        && props.gui.currentGameGui.possibleMoves.any((Move move)
        => move.target.equals(props.position));
  }

  bool get isDragging
  {
    return (state.delta.x.abs() > 20 || state.delta.y.abs() > 20);
  }

  bool get isLabeled
  {
    return props.gui.currentGameGui.lastMoveChanges.isPresent && props.gui.currentGameGui.lastMoveChanges.value.containsKey(props.position);
  }

  bool get isInfo
  {
    return (state.delta.x.abs() > 20 || state.delta.y.abs() > 20);
  }

  String get title
  {
    if (tileType == TileType.OUT_OF_FIELD)
    {
      return "";
    }
    if (tileType == TileType.FORBIDDEN)
    {
      return "This Tile is blocked";
    }
    if (tileType == TileType.EMPTY)
    {
      if (isPlayAbleNow)
      {
        Optional<Move> move = getMovefromSelectedToHere;
        return move.isPresent ? "Click, to ${move.value.kindOf} to this tile" : "ERROR";
      }
      else
      {
        return "This Tile is empty";
      }
    }
    if (tileType == TileType.PLAYER_ONE || tileType == TileType.PLAYER_TWO)
    {
      if (isSelected)
      {
        return "Now select a green tile to finish your move";
      }
      if (playAble)
      {
        return "Click, to make a move";
      }
      return "This tile belongs to the enemy";
    }
    return "";
  }

  Optional<Move> get getMovefromSelectedToHere
  {
    if (props.gui.currentGameGui.isSomethingSelected)
    {
      return new Optional.ofNullable(props.gui.currentGameGui.possibleMoves.firstWhere((Move move)
      => move.target.equals(props.position), orElse: ()
      => null));
    }
    else
    {
      return new Optional.empty();
    }
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

    props.gui.addGameGUIChangeListener(()
    {
      if (currentIsPlayAbleNow != isPlayAbleNow || isPlayAbleNow == true)
      {
        setState(state);
      }
      else
      {
        bool isSelected = props.gui.currentGameGui.isSomethingSelected && props.gui.currentGameGui.selectedPosition.equals(props.position);
        if (currentIsSelected != isSelected)
        {
          setState(state);
        }
      }
    });

    props.gui.addGameChangeListener(()
    {
      if (!(currentTileType == tileType && tileType == TileType.FORBIDDEN))
      {
        setState(state);
      }
    });
  }

  @override
  ReactElement render()
  {
    Optional<Move> move = getMovefromSelectedToHere;

    currentIsSelected = isSelected;
    currentIsPlayAbleNow = isPlayAbleNow;
    currentTileType = tileType;

    bool isTranslated = state.delta.x != 0 || state.delta.y != 0;

    return (Dom.div()
      ..className = "hexagon "
          " ${isLabeled ? "labeled" : ""}"
          " ${move.isPresent ? move.value.kindOf : ""}"
          " ${playAble ? "playAble" : (playAbleOfNotCurrentPlayer ? "notPlayAble" : "")}"
          " ${isPlayAbleNow ? "playAbleNow playAbleNow${TileTypes.toName(props.gui.currentGameGui.currentPlayer)}" : ""}"
          " ${TileTypes.toName(tileType)}"
          " ${isSelected ? "selected" : ""}"
          " ${state.mouseIsOver ? "mouseIsOver" : ""}"
          " ${isDragging ? "dragging" : ""}"
          " posy_${props.position.getMaxDistanceTo(TilePosition.get(0, 0))}"
      ..style =
      {
        "transform": (isTranslated ? "translate(${state.delta.x}px, ${state.delta.y}px)" : "none"),
        "marginLeft": "${props.hexagonGrid.tileMarginLeft}px",
        "marginTop": "${props.hexagonGrid.tileMarginTop}px",
        "width": "${props.hexagonGrid.tileWidth}px",
        "height": "${props.hexagonGrid.tileHeight}px"
      }
    )(
      (Dom.svg()
        ..version = "1.1"
        ..height = props.hexagonGrid.tileHeight
        ..width = props.hexagonGrid.tileWidth
        ..viewBox = "0 0 726 628"
        ..style =
        {
          "height": "${props.hexagonGrid.tileHeight}px",
        }
      )(
          (Dom.polygon()
            ..points = "723,314 543,625.769145 183,625.769145 3,314 183,2.230855 543,2.230855 723,314"
            ..className = "hexagonInner"
            ..onMouseDown = this.startDrag
            ..onMouseEnter = onMouseEnter
            ..onMouseLeave = onMouseLeave
            ..style =
            {
              "animationDelay": playAble ? "${0.15 * props.position.getMaxDistanceTo(TilePosition.get(0, 0))}s" : ""
            }
          )(
              Dom.title()(title)
          )
      ),
      (Dom.div()
        ..className = "hexagonInnerText"
        ..style = {
          "marginTop": "-${props.hexagonGrid.tileHeight + props.hexagonGrid.borderRows * 3}px",
          "width": "${props.hexagonGrid.tileWidth}px",
          "height": "${props.hexagonGrid.tileHeight}px",
          "fontSize": "${props.hexagonGrid.tileWidth / 5.5}px",
          "lineHeight": "${props.hexagonGrid.tileHeight}px",
        }
      )(
          isLabeled ? props.gui.currentGameGui.lastMoveChanges.value[props.position] : ""
      ),
      /*
        (Dom.div()
          ..className = "hexagonInnerText positions"
          ..style = textStyle
        )("${props.position.x} - ${props.position.y}")
        */
    );
  }

  bool get isSelected
  => props.gui.currentGameGui.isSomethingSelected && props.gui.currentGameGui.selectedPosition.equals(props.position);

  bool get playAbleOfNotCurrentPlayer
  => !playAble && tileType == props.gui.currentGameGui.notCurrentPlayer;

  bool get playAble
  => props.gui.currentGameGui.couldBeMoved(props.position) && props.gui.currentGameGui.currentIntelligence.isHuman;

  TileType get tileType
  => props.gui.currentGameGui.get(props.position);

  void select(SyntheticMouseEvent event)
  {
    Optional<Move> move = getMovefromSelectedToHere;

    if (move.isPresent)
    {
      props.gui.currentGameGui.move(move.value);
    }
    else
    {
      props.gui.currentGameGui.select(props.position);
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
    if (props.gui.currentGameGui.currentIntelligence.isHuman)
    {
      bool firstTimeUp = false;
      if (!props.gui.currentGameGui.isSomethingSelected || !props.gui.currentGameGui.selectedPosition.equals(props.position))
      {
        select(null);
        firstTimeUp = true;
      }
      if (props.gui.currentGameGui.isSomethingSelected && props.gui.currentGameGui.selectedPosition.equals(props.position))
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