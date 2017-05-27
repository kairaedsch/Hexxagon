import '../game/Hexxagon.dart';
import '../general/Game.dart';
import 'GameGUI.dart';
import 'dart:html';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' as react_client;
import 'package:over_react/over_react.dart';
import 'ReactTileGrid.dart';

void main()
{
  // Initialize React within our Dart app
  react_client.setClientConfiguration();

  // Mount / render your component.
  react_dom.render(
      (ReactTileGrid()
        ..gameGUI = new GameGUI(new Game(new Hexxagon(4, 10)))
      )(),
      querySelector('#react_mount_point')
  );
}
