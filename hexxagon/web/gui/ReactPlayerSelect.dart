import '../game/Hexxagon.dart';
import '../general/Player.dart';
import '../general/TilePosition.dart';
import 'GameGUI.dart';
import '../general/Move.dart';
import 'Hexagon.dart';
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
  int initialSelected;
}

@State()
class ReactPlayerSelectState extends UiState
{
  int selected;
}

@Component()
class ReactPlayerSelectComponent extends UiStatefulComponent<ReactPlayerSelectProps, ReactPlayerSelectState>
{
  @override
  getInitialState()
  {
    return (newState()
      ..selected = props.initialSelected
    );
  }

  ReactElement render()
  {
    Player player = props.players[state.selected];
    return (Dom.div()
      ..className = "playerContainer")
      (
        (Dom.div()
          ..className = "arrow arrowUp"
          ..onClick = (e)
          {
            this.setState((Map prevState, Map props)
            {
              ReactPlayerSelectState state = newState()
                ..addAll(prevState);
              state.selected = (state.selected + 1) % this.props.players.length;
              return state;
            });
          })(),
        (Dom.div()
          ..className = "playerInner")
          (
            (Dom.div()
              ..className = "playerImage"
              ..style =
              {
                "backgroundImage": "url('${player.image}')",
              })(),
            (Dom.div()
              ..className = "playerText")(player.name)
        ),
        (Dom.div()
          ..className = "arrow arrowDown"
          ..onClick = (e)
          {
            this.setState((Map prevState, Map props)
            {
              ReactPlayerSelectState state = newState()
                ..addAll(prevState);
              state.selected = (state.selected - 1 + this.props.players.length) % this.props.players.length;
              return state;
            });
          })()
    );
  }
}