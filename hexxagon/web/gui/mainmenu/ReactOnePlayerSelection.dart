import 'package:over_react/over_react.dart';

import '../../general/Intelligence.dart';

import 'ReactTwoPlayerSelection.dart';

@Factory()
UiFactory<ReactOnePlayerSelectionProps> ReactOnePlayerSelection;

@Props()
class ReactOnePlayerSelectionProps extends UiProps
{
  List<Intelligence> intelligences;
  int selected;
  ReactTwoPlayerSelectionComponent father;
  bool playerOne;
}

@Component()
class ReactOnePlayerSelectionComponent extends UiComponent<ReactOnePlayerSelectionProps>
{
  ReactElement render()
  {
    Intelligence intelligences = props.intelligences[props.selected];
    return (Dom.div()
      ..className = "playerContainer"
    )(
        (Dom.div()
          ..className = "arrow arrowUp"
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
          }
          ..title = "Change player"
          )(),
        (Dom.div()
          ..className = "playerInner"
        )(
            (Dom.div()
              ..className = "playerImage"
              ..style =
              {
                "backgroundImage": "url('${intelligences.isHuman ? "human.png" : "robot-${intelligences.strength}.png"}')",
              })(),
            (Dom.div()
              ..className = "playerText"
            )(
                intelligences.isHuman ? intelligences.name : "AI ${intelligences.strengthName}"
                ,
                Dom.br()()
                ,
                intelligences.isHuman ? "" : intelligences.name

            )
        ),
        (Dom.div()
          ..className = "arrow arrowDown"
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
          }
          ..title = "Change player"
        )()
    );
  }
}