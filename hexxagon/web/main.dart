import 'dart:html';

import 'logic/Hexxagon.dart';
import 'logic/ai/random/RandomHexxagonPlayer.dart';
import 'logic/ai/minmax/MinMaxHexxagonPlayer.dart';
import 'logic/ai/montecarlo/MonteCarloHexxagonPlayer.dart';
import 'logic/ai/montecarlo/MonteCarloTreeSearchHexxagonPlayer.dart';
import 'general/HumanPlayer.dart';
import 'package:react/react_client.dart' as react_client;
import 'package:react/react_dom.dart' as react_dom;

import 'gui/GUI.dart';
import 'gui/playerselection/ReactPlayerSelection.dart';
import 'gui/gamestate/ReactPlayerStates.dart';
import 'gui/tiles/ReactTileGrid.dart';

void main()
{
  // Initialize React within our Dart app
  react_client.setClientConfiguration();

  GUI<Hexxagon> gui = new GUI<Hexxagon>(() => new Hexxagon(4));

  react_dom.render(
      (ReactTileGrid()
        ..gui = gui
      )(),
      querySelector('.tileGridContainer')
  );
  react_dom.render(
      (ReactPlayerSelection()
        ..gui = gui
        ..players = [new HumanPlayer(), new MinMaxHexxagonPlayer(), new RandomHexxagonPlayer(), new MonteCarloTreeSearchHexxagonPlayer(), new MonteCarloHexxagonPlayer()]
      )(),
      querySelector('.playerSelection')
  );
  react_dom.render(
      (ReactPlayerStates()
        ..gui = gui
      )(),
      querySelector('.side')
  );
  querySelector('.start').onClick.listen((e)
  => gui.startNewGame());
}
