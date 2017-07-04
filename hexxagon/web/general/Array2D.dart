import 'dart:core';

class Array2D<T>
{
  List<List<T>> array;

  Array2D(int width, int height, T defaultValue)
  {
    array = new List.generate(width, (_) => new List.filled(height, defaultValue));
  }

  Array2D.empty(int width, int height)
  {
    array = new List.generate(width, (_) => new List(height));
  }

  operator [](int x) => array[x];
  }