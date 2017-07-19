import 'dart:html';

import 'hexxagon/Hexxagon.dart';
import 'hexxagon/ai/move/MoveAI.dart';
import 'hexxagon/ai/random/RandomAI.dart';
import 'hexxagon/ai/minmax/MinMaxAI.dart';
import 'hexxagon/ai/montecarlo/MonteCarloAI.dart';
import 'hexxagon/ai/montecarlo/MonteCarloTreeSearchAI.dart';
import 'general/HumanIntelligence.dart';
import 'package:react/react_client.dart' as react_client;
import 'package:react/react_dom.dart' as react_dom;

import 'gui/game/logic/GUI.dart';
import 'gui/mainmenu/ReactTwoPlayerSelection.dart';
import 'gui/game/gamestate/ReactGameTopInfo.dart';
import 'gui/game/tiles/ReactTileGrid.dart';

void main()
{
  // Initialize React within our Dart app
  react_client.setClientConfiguration();

  GUI<Hexxagon> gui = new GUI<Hexxagon>(() => new Hexxagon(5));

  react_dom.render(
      (ReactTileGrid()
        ..gui = gui
      )(),
      querySelector('.tileGridContainer')
  );
  react_dom.render(
      (ReactTwoPlayerSelection()
        ..gui = gui
        ..intelligences = [new HumanIntelligence(), new RandomAI(), new MonteCarloTreeSearchAI(), new MonteCarloAI(), new MoveAI(), new MinMaxAI(1), new MinMaxAI(2), new MinMaxAI(3), new MinMaxAI(4)]
      )(),
      querySelector('.playerSelection')
  );
  react_dom.render(
      (ReactGameTopInfo()
        ..gui = gui
      )(),
      querySelector('.side')
  );
  querySelector('.start').onClick.listen((e)
  => gui.startNewGame());
}
