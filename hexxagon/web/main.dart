import 'dart:html';

import 'game/Hexxagon.dart';
import 'game/ai/random/RandomHexxagonPlayer.dart';
import 'game/ai/minmax/MinMaxHexxagonPlayer.dart';
import 'game/ai/montecarlo/MonteCarloHexxagonPlayer.dart';
import 'game/ai/montecarlo/MonteCarloTreeSearchHexxagonPlayer.dart';
import 'general/HumanPlayer.dart';
import 'package:react/react_client.dart' as react_client;
import 'package:react/react_dom.dart' as react_dom;

import 'gui/GUI.dart';
import 'gui/ReactPlayerSelection.dart';
import 'gui/ReactPlayerStates.dart';
import 'gui/ReactTileGrid.dart';

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
