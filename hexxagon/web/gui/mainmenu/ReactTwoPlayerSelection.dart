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
  /// The GUI which always contains the current GUI state with data.
  GUI gui;

  /// The intelligences which are available to select.
  List<Intelligence> intelligences;
}

@State()
class ReactTwoPlayerSelectionState extends UiState
{
  /// The selection index for the first intelligence.
  int selectedPlayerOne;

  /// The selection index for the second intelligence.
  int selectedPlayerTwo;
}

/// React Component to display the player-selection of both players
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

  @override
  void componentWillMount()
  {
    super.componentWillMount();
    props.gui.addGUIStateChangeListener(() => setState(state));
  }

  @override
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
              ..intelligence = props.intelligences[state.selectedPlayerOne]
              ..changePlayer = changePlayerOne)()),
        (Dom.div()
          ..className = "playerBetween"
        )(
            "VS"
        ),
        (Dom.div()
          ..className = "player playerTwo"
        )(
            (ReactOnePlayerSelection()
              ..intelligence = props.intelligences[state.selectedPlayerTwo]
              ..changePlayer = changePlayerTwo)()
        )
    );
  }

  /// Change Player One.
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

  /// Change Player Two.
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