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

@Factory()
UiFactory<ReactTileProps> ReactTile;

@Props()
class ReactTileProps extends UiProps
{
  /// The position of the tile.
  TilePosition position;

  /// The GUI which always contains the current GUI state with data.
  GUI gui;

  /// The HexagonGrid for the sizes and margins.
  HexagonGrid hexagonGrid;
}

@State()
class ReactTileState extends UiState
{
  /// The last pos, where the mouse was down (If this tile is currently dragged)
  Optional<Point<int>> lastMouseDownPos;

  /// The offset of this tile from its original position, when it is being dragged.
  Point<int> positionOffset;

  /// If the mouse went up the first time.
  bool firstTimeMouseUp;

  /// If the mouse is over this tile.
  bool mouseIsOver;

  /// Last value of a ReactTileInfo value.
  bool currentIsPlayAbleNow;

  /// Last value of a ReactTileInfo value.
  bool currentIsSelected;

  /// Last value of a ReactTileInfo value.
  TileType currentTileType;
}

/// React Component to display a hexagon tile.
@Component()
class ReactTileComponent extends UiStatefulComponent<ReactTileProps, ReactTileState>
{
  /// StreamSubscription to listen to mouse-events.
  StreamSubscription l1, l2, l3;

  /// ReactTileInfo to provide info about this ReactTileComponent.
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
      ..positionOffset = new Point(0, 0)
      ..firstTimeMouseUp = false
      ..mouseIsOver = false
      ..currentIsPlayAbleNow = false
      ..currentIsSelected = false
      ..currentTileType = null
    );
  }

  @override
  componentDidMount()
  {
    l3 = window.document.onMouseUp.listen((event) => onMouseUp());
    l1 = window.document.onMouseUp.listen((event) => endDrag(null));
    l2 = window.document.onMouseMove.listen((event) => mouseMoved(event.screen));

    l1.pause();
    l2.pause();
    l3.pause();

    props.gui.addGameGUIChangeListener(()
    {
      bool update = false;
      if (state.currentIsPlayAbleNow != rti.isPlayAbleNow || rti.isPlayAbleNow == true)
      {
        update = true;
      }
      else
      {
        bool isSelected = props.gui.currentGameGui.isATileSelected && props.gui.currentGameGui.selectedPosition.equals(props.position);
        if (state.currentIsSelected != isSelected)
        {
          update = true;
        }
      }
      if (update)
      {
        setState((newState()
          ..currentIsSelected = rti.isSelected
          ..currentIsPlayAbleNow = rti.isPlayAbleNow
          ..currentTileType = rti.tileType
        ));
      }
    });

    props.gui.addGameChangeListener(()
    {
      if (!(state.currentTileType == rti.tileType && rti.tileType == TileType.BLOCKED))
      {
        setState((newState()
          ..currentIsSelected = rti.isSelected
          ..currentIsPlayAbleNow = rti.isPlayAbleNow
          ..currentTileType = rti.tileType
        ));
      }
    });
  }

  @override
  ReactElement render()
  {
    Optional<Move> move = rti.getMovefromSelectedToHere;

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
        "transform": ((state.positionOffset.x != 0 || state.positionOffset.y != 0) ? "translate(${state.positionOffset.x}px, ${state.positionOffset.y}px)" : "none"),
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

  /// Select this tile.
  void select()
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

  /// The mouse was moved over this tile.
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
          ..positionOffset = reactTileState.positionOffset + newMouseDownPos - lastMouseDownPos);
      }
      else
      {
        return prevState;
      }
    });
  }

  /// The mouse started dragging over this tile.
  startDrag(SyntheticMouseEvent event)
  {
    if (props.gui.currentGameGui.currentIntelligence.isHuman)
    {
      bool firstTimeUp = false;
      if (!props.gui.currentGameGui.isATileSelected || !props.gui.currentGameGui.selectedPosition.equals(props.position))
      {
        select();
        firstTimeUp = true;
      }
      if (props.gui.currentGameGui.isATileSelected && props.gui.currentGameGui.selectedPosition.equals(props.position))
      {
        l1.resume();
        l2.resume();
        setState((newState()
          ..lastMouseDownPos = new Optional.of(new Point(event.screenX, event.screenY))
          ..positionOffset = new Point(0, 0)
          ..firstTimeMouseUp = firstTimeUp
        ));
      }
    }
  }

  /// The mouse ended dragging over this tile.
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
        if (rti.isDragging || !reactTileState.firstTimeMouseUp)
        {
          select();
        }
        return (newState()
          ..lastMouseDownPos = new Optional.empty()
          ..positionOffset = new Point(0, 0)
          ..firstTimeMouseUp = false);
      });
    });
  }

  /// The mouse went up on this tile.
  onMouseUp()
  {
    if (rti.isPlayAbleNow)
    {
      select();
    }
    setState((newState()
      ..mouseIsOver = false
    ));
    l3.pause();
  }

  /// The mouse entered this tile.
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

  /// The mouse leaved this tile.
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