import 'package:over_react/over_react.dart';

import '../general/Player.dart';
import 'ReactPlayerSelection.dart';

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