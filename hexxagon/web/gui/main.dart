import 'dart:html';

import 'package:react/react_client.dart' as react_client;
import 'package:react/react_dom.dart' as react_dom;

import 'GUI.dart';
import 'ReactPlayerSelection.dart';
import 'ReactPlayerStates.dart';
import 'ReactTileGrid.dart';

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
