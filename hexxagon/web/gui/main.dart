import '../game/Hexxagon.dart';
import '../game/ai/montecarlo/MonteCarloHexxagonPlayer.dart';
import '../game/ai/montecarlo/MonteCarloTreeSearchHexxagonPlayer.dart';
import '../game/RandomHexxagonPlayer.dart';
import '../general/Game.dart';
import '../general/HumanPlayer.dart';
import 'GUI.dart';
import 'GameGUI.dart';
import 'dart:html';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' as react_client;
import 'package:over_react/over_react.dart';
import 'ReactTileGrid.dart';
import 'ReactPlayerSelection.dart';
import 'ReactPlayerStates.dart';

void main()
{
  // Initialize React within our Dart app
  react_client.setClientConfiguration();

  GUI gui = new GUI();

  react_dom.render(
      (ReactTileGrid()
        ..gui = gui
      )(),
      querySelector('.tileGridContainer')
  );
  react_dom.render(
      (ReactPlayerSelection()
        ..gui = gui
      )(),
      querySelector('.playerSelection')
  );
  react_dom.render(
      (ReactPlayerStates()
        ..gui = gui
      )(),
      querySelector('.side')
  );
  querySelector('.start').onClick.listen((e) => gui.startNewGame());
}
