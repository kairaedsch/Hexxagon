import 'ReactTile.dart';

import 'package:optional/optional_internal.dart';

import '../../../general/Move.dart';
import '../../../general/TileType.dart';

/// Provides info about a ReactTileComponent.
class ReactTileInfo
{
  /// The ReactTileComponent where the info should be read from.
  ReactTileComponent _rtc;

  /// Create a new ReactTileInfo.
  ReactTileInfo(this._rtc);

  /// If the selected tile could make a move with this tile as target.
  bool get isPlayAbleNow => _rtc.props.gui.currentGameGui.isATileSelected
        && _rtc.props.gui.currentGameGui.possibleMoves.any((Move move)
        => move.to.equals(_rtc.props.position));

  /// If this tile is dragged by the cursor.
  bool get isDragging => (_rtc.state.positionOffset.x.abs() > 20 || _rtc.state.positionOffset.y.abs() > 20);

  /// If there is text to be displayed on this tile.
  bool get isLabeled => _rtc.props.gui.currentGameGui.lastMoveChanges.isPresent && _rtc.props.gui.currentGameGui.lastMoveChanges.value.containsKey(_rtc.props.position);

  /// Tooltip for this tile.
  String get tooltip
  {
    if (tileType == TileType.OUT_OF_FIELD)
    {
      return "";
    }
    if (tileType == TileType.BLOCKED)
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

  /// Get the move from the selected tile to this tile (if one exists).
  Optional<Move> get getMovefromSelectedToHere
  {
    if (_rtc.props.gui.currentGameGui.isATileSelected)
    {
      return new Optional.ofNullable(_rtc.props.gui.currentGameGui.possibleMoves.firstWhere((Move move)
      => move.to.equals(_rtc.props.position), orElse: ()
      => null));
    }
    else
    {
      return new Optional.empty();
    }
  }

  /// If this tile is selected.
  bool get isSelected => _rtc.props.gui.currentGameGui.isATileSelected && _rtc.props.gui.currentGameGui.selectedPosition.equals(_rtc.props.position);

  /// If this tile could be moved by the current player.
  bool get playAble => _rtc.props.gui.currentGameGui.couldBeMoved(_rtc.props.position) && _rtc.props.gui.currentGameGui.currentIntelligence.isHuman;

  /// The tileType of this tile
  TileType get tileType => _rtc.props.gui.currentGameGui.get(_rtc.props.position);
}