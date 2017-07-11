import 'dart:html';

import 'package:over_react/over_react.dart';

import '../../general/Intelligence.dart';

import '../game/logic/GUI.dart';
import 'ReactOnePlayerSelection.dart';

@Factory()
UiFactory<ReactTwoPlayerSelectionProps> ReactTwoPlayerSelection;

@Props()
class ReactTwoPlayerSelectionProps extends UiProps
{
  GUI gui;
  List<Intelligence> intelligences;
}

@State()
class ReactTwoPlayerSelectionState extends UiState
{
  int selectedPlayerOne;
  int selectedPlayerTwo;
}

@Component()
class ReactTwoPlayerSelectionComponent extends UiStatefulComponent<ReactTwoPlayerSelectionProps, ReactTwoPlayerSelectionState>
{
  @override
  getInitialState()
  {
    return (newState()
      ..selectedPlayerOne = 0
      ..selectedPlayerTwo = 4
    );
  }

  void componentWillMount()
  {
    super.componentWillMount();
    props.gui.addStateChangeListener(()
    => setState(state));
  }

  ReactElement render()
  {
    props.gui.playerOne = props.intelligences[state.selectedPlayerOne];
    props.gui.playerTwo = props.intelligences[state.selectedPlayerTwo];
    if (props.gui.isPlayerSelection)
    {
      querySelector(".mainMenuOverlay").classes
        ..remove("hide")
        ..add("unhide");
    }
    else
    {
      querySelector(".mainMenuOverlay").classes
        ..add("hide")
        ..remove("unhide");
    }
    return (Dom.div()
      ..className = "playerSelectionContainer"
    )(
        (Dom.div()
          ..className = "player playerOne"
        )(
            (ReactOnePlayerSelection()
              ..intelligences = props.intelligences
              ..selected = state.selectedPlayerOne
              ..father = this
              ..playerOne = true)()),
        (Dom.div()
          ..className = "playerBetween"
        )(
            "VS"
        ),
        (Dom.div()
          ..className = "player playerTwo"
        )(
            (ReactOnePlayerSelection()
              ..intelligences = props.intelligences
              ..selected = state.selectedPlayerTwo
              ..father = this
              ..playerOne = false)()
        )
    );
  }

  void changePlayerOne(int delta)
  {
    this.setState((Map prevState, Map props)
    {
      ReactTwoPlayerSelectionState state = newState()
        ..addAll(prevState);
      state.selectedPlayerOne = (state.selectedPlayerOne + delta) % this.props.intelligences.length;
      return state;
    });
  }

  void changePlayerTwo(int delta)
  {
    this.setState((Map prevState, Map props)
    {
      ReactTwoPlayerSelectionState state = newState()
        ..addAll(prevState);
      state.selectedPlayerTwo = (state.selectedPlayerTwo + delta) % this.props.intelligences.length;
      return state;
    });
  }
}