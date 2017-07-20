import 'dart:html';

import 'hexxagon/Hexxagon.dart';
import 'hexxagon/ai/minmax/MiniMaxSimpleHeuristicAI.dart';
import 'hexxagon/ai/move/MoveAI.dart';
import 'hexxagon/ai/random/RandomAI.dart';
import 'hexxagon/ai/montecarlo/FlatMonteCarloAI.dart';
import 'hexxagon/ai/montecarlo/MonteCarloTreeSearchAI.dart';
import 'general/HumanIntelligence.dart';
import 'package:react/react_client.dart' as react_client;
import 'package:react/react_dom.dart' as react_dom;

import 'gui/game/logic/GUI.dart';
import 'gui/mainmenu/ReactTwoPlayerSelection.dart';
import 'gui/game/gamestate/ReactGameTopInfo.dart';
import 'gui/game/tiles/ReactTileGrid.dart';

/// The main method of Hexxagon.
void main()
{
  // Initialize React within our Dart app.
  react_client.setClientConfiguration();

  // Create a new GUI.
  GUI<Hexxagon> gui = new GUI<Hexxagon>(() => new Hexxagon(2));

  // Init react.
  react_dom.render(
      (ReactTileGrid()
        ..gui = gui
      )(),
      querySelector('.tileGridContainer')
  );
  react_dom.render(
      (ReactTwoPlayerSelection()
        ..gui = gui
        ..intelligences = [
          new HumanIntelligence(),
          new RandomAI(),
          new MonteCarloTreeSearchAI(3000),
          new FlatMonteCarloAI(3000),
          new MoveAI(),
          new MiniMaxSimpleHeuristicAI(1),
          new MiniMaxSimpleHeuristicAI(2),
          new MiniMaxSimpleHeuristicAI(3),
          new MiniMaxSimpleHeuristicAI(4)
        ]
      )(),
      querySelector('.playerSelection')
  );
  react_dom.render(
      (ReactGameTopInfo()
        ..gui = gui
      )(),
      querySelector('.side')
  );

  // Setup the start button.
  querySelector('.start').onClick.listen((e) => gui.startNewGame());
}
