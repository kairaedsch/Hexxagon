import '../general/Board.dart';
import '../general/Game.dart';
import '../general/Move.dart';
import '../general/Player.dart';
import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'dart:async';
import 'package:optional/optional.dart';
import 'package:tuple/tuple.dart';

enum GUIState
{
  PLAYER_SELECTION, GAME_RUNNING, GAME_OVER
}