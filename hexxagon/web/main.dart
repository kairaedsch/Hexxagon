import 'dart:html';

import 'logic/Hexxagon.dart';
import 'logic/HexxagonStats.dart';
import 'logic/ai/random/RandomAI.dart';
import 'logic/ai/minmax/MinMaxAI.dart';
import 'logic/ai/montecarlo/MonteCarloAI.dart';
import 'logic/ai/montecarlo/MonteCarloTreeSearchAI.dart';
import 'general/HumanIntelligence.dart';
import 'package:react/react_client.dart' as react_client;
import 'package:react/react_dom.dart' as react_dom;

import 'gui/GUI.dart';
import 'gui/playerselection/ReactPlayerSelection.dart';
import 'gui/gamestate/ReactGameSidePanel.dart';
import 'gui/tiles/ReactTileGrid.dart';

void main()
{
  // Initialize React within our Dart app
  react_client.setClientConfiguration();

  GUI<Hexxagon> gui = new GUI<Hexxagon>(() => new HexxagonWithStats(4));

  react_dom.render(
      (ReactTileGrid()
        ..gui = gui
      )(),
      querySelector('.tileGridContainer')
  );
  react_dom.render(
      (ReactPlayerSelection()
        ..gui = gui
        ..intelligences = [new HumanIntelligence(), new MinMaxAI(2), new MinMaxAI(3), new MinMaxAI(4), new MinMaxAI(5), new RandomAI(), new MonteCarloTreeSearchAI(), new MonteCarloAI()]
      )(),
      querySelector('.playerSelection')
  );
  react_dom.render(
      (ReactGameSidePanel()
        ..gui = gui
      )(),
      querySelector('.side')
  );
  querySelector('.start').onClick.listen((e)
  => gui.startNewGame());
}
