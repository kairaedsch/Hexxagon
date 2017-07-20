import 'package:over_react/over_react.dart';

import '../../general/Intelligence.dart';

/// A Method to be called to change the selected player.
typedef void ChangePlayer(int delta);

@Factory()
UiFactory<ReactOnePlayerSelectionProps> ReactOnePlayerSelection;

@Props()
class ReactOnePlayerSelectionProps extends UiProps
{
  /// The currently selected intelligence.
  Intelligence intelligence;

  /// The Method to be called to change the selected player/intelligence.
  ChangePlayer changePlayer;
}

/// React Component to display the player-selection of one player
@Component()
class ReactOnePlayerSelectionComponent extends UiComponent<ReactOnePlayerSelectionProps>
{
  @override
  ReactElement render()
  {
    return (Dom.div()
      ..className = "playerContainer"
    )(
        (Dom.div()
          ..className = "arrow arrowUp"
          ..onClick = ((e) => props.changePlayer(1))
          ..title = "Change player"
          )(),
        (Dom.div()
          ..className = "playerInner"
        )(
            (Dom.div()
              ..className = "playerImage"
              ..style =
              {
                "backgroundImage": "url('images/${props.intelligence.isHuman ? "human.png" : "robot-${props.intelligence.strength}.png"}')",
              })(),
            (Dom.div()
              ..className = "playerText"
            )(
                props.intelligence.isHuman ? props.intelligence.name : "AI ${props.intelligence.strengthName}"
                ,
                Dom.br()()
                ,
                props.intelligence.isHuman ? "" : props.intelligence.name

            )
        ),
        (Dom.div()
          ..className = "arrow arrowDown"
          ..onClick = ((e) => props.changePlayer(-1))
          ..title = "Change player"
        )()
    );
  }
}