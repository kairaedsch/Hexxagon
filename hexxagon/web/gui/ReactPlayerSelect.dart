import '../game/Hexxagon.dart';
import '../general/Player.dart';
import '../general/TilePosition.dart';
import 'GameGUI.dart';
import '../general/Move.dart';
import 'Hexagon.dart';
import 'ReactPlayerSelection.dart';
import 'ReactTileGrid.dart';
import '../general/TileType.dart';
import 'dart:html';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' as react_client;
import 'package:over_react/over_react.dart';
import 'ReactTile.dart';

@Factory()
UiFactory<ReactPlayerSelectProps> ReactPlayerSelect;

@Props()
class ReactPlayerSelectProps extends UiProps
{
  List<Player> players;
  int selected;
  ReactPlayerSelectionComponent father;
  bool playerOne;
}

@Component()
class ReactPlayerSelectComponent extends UiComponent<ReactPlayerSelectProps>
{
  ReactElement render()
  {
    Player player = props.players[props.selected];
    return (Dom.div()
      ..className = "playerContainer"
    )(
        (Dom.div()
          ..className = "arrow arrowUp"
          ..onClick = (e)
          {
            if (props.playerOne)
            {
              props.father.changePlayerOne(-1);
            }
            else
            {
              props.father.changePlayerTwo(-1);
            }
          })(),
        (Dom.div()
          ..className = "playerInner"
        )(
            (Dom.div()
              ..className = "playerImage"
              ..style =
              {
                "backgroundImage": "url('${player.image}')",
              })(),
            (Dom.div()
              ..className = "playerText"
            )(
                player.name
            )
        ),
        (Dom.div()
          ..className = "arrow arrowDown"
          ..onClick = (e)
          {
            if (props.playerOne)
            {
              props.father.changePlayerOne(1);
            }
            else
            {
              props.father.changePlayerTwo(1);
            }
          })()
    );
  }
}