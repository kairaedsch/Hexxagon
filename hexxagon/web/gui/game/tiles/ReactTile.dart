import 'ReactTileInfos.dart';
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

  ReactTileInfo rti;

  ReactTileComponent()
  {
    rti = new ReactTileInfo(this);
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
      if (currentIsPlayAbleNow != rti.isPlayAbleNow || rti.isPlayAbleNow == true)
      {
        setState(state);
      }
      else
      {
        bool isSelected = props.gui.currentGameGui.isATileSelected && props.gui.currentGameGui.selectedPosition.equals(props.position);
        if (currentIsSelected != isSelected)
        {
          setState(state);
        }
      }
    });

    props.gui.addGameChangeListener(()
    {
      if (!(currentTileType == rti.tileType && rti.tileType == TileType.BLOCKED))
      {
        setState(state);
      }
    });
  }

  @override
  ReactElement render()
  {
    Optional<Move> move = rti.getMovefromSelectedToHere;

    currentIsSelected = rti.isSelected;
    currentIsPlayAbleNow = rti.isPlayAbleNow;
    currentTileType = rti.tileType;

    bool isTranslated = state.delta.x != 0 || state.delta.y != 0;

    return (Dom.div()
      ..className = "hexagon "
          " ${rti.isLabeled ? "labeled" : ""}"
          " ${move.isPresent ? move.value.kindOf : ""}"
          " ${rti.playAble ? "playAble" : ""}"
          " ${rti.isPlayAbleNow ? "playAbleNow playAbleNow${TileTypes.toName(props.gui.currentGameGui.currentPlayer)}" : ""}"
          " ${TileTypes.toName(rti.tileType)}"
          " ${rti.isSelected ? "selected" : ""}"
          " ${state.mouseIsOver ? "mouseIsOver" : ""}"
          " ${rti.isDragging ? "dragging" : ""}"
          " posy_${props.position.getDistanceTo(TilePosition.get(0, 0))}"
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
              "animationDelay": rti.playAble ? "${0.15 * props.position.getDistanceTo(TilePosition.get(0, 0))}s" : ""
            }
          )(
              Dom.title()(rti.tooltip)
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
          rti.isLabeled ? props.gui.currentGameGui.lastMoveChanges.value[props.position] : ""
      ),
      /*
        (Dom.div()
          ..className = "hexagonInnerText positions"
          ..style = textStyle
        )("${props.position.x} - ${props.position.y}")
        */
    );
  }

  void select(SyntheticMouseEvent event)
  {
    Optional<Move> move = rti.getMovefromSelectedToHere;

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
      if (!props.gui.currentGameGui.isATileSelected || !props.gui.currentGameGui.selectedPosition.equals(props.position))
      {
        select(null);
        firstTimeUp = true;
      }
      if (props.gui.currentGameGui.isATileSelected && props.gui.currentGameGui.selectedPosition.equals(props.position))
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
        if (rti.isDragging || !reactTileState.firstTimeUp)
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
    if (rti.isPlayAbleNow)
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
    if (rti.isPlayAbleNow)
    {
      setState((newState()
        ..mouseIsOver = true
      ));
      l3.resume();
    }
  }

  onMouseLeave(SyntheticMouseEvent event)
  {
    if (rti.isPlayAbleNow)
    {
      setState((newState()
        ..mouseIsOver = false
      ));
      l3.pause();
    }
  }
}