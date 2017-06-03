import 'dart:core';

class Array2D
{
  List<List<int>> array;

  Array2D(int width, int height, int defaultValue)
  {
    array = new List.generate(width, (_) => new List.filled(height, defaultValue));
  }

  operator [](int x) => array[x];
  }