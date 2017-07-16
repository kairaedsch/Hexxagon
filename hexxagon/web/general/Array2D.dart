import 'dart:core';

/// A 2D array.
class Array2D<T>
{
  /// The array.
  List<List<T>> array;

  /// Creates a new 2D array with the given size and default Value.
  Array2D(int width, int height, T defaultValue)
  {
    array = new List.generate(width, (_) => new List.filled(height, defaultValue));
  }

  /// Creates a new empty 2D array.
  Array2D.empty(int width, int height)
  {
    array = new List.generate(width, (_) => new List(height));
  }

  /// The value of the 2D array at the given position.
  operator [](int x) => array[x];
}