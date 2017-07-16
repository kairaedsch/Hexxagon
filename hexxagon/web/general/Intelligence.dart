import 'Board.dart';
import 'Move.dart';

/// A Method to be called to make a move.
typedef void MoveCallback(Move move);

/// An intelligence who can make a move on a board.
abstract class Intelligence<B extends Board>
{
  /// If this intelligence is human or not.
  bool get isHuman;

  /// The name of this intelligence.
  String get name;

  /// The strength of this intelligence.
  int get strength;

  /// The strength of this intelligence as Text.
  String get strengthName
  {
    switch(strength)
    {
      case 1: return "very easy";
      case 2: return "easy";
      case 3: return "medium";
      case 4: return "hard";
      case 5: return "extrem";
    }
  }

  /// Let this intelligence call the given moveCallback method, when it has found a move for the current player on the given board.
  void move(B board, MoveCallback moveCallback);
}