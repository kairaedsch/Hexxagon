import 'dart:core';

import 'package:dartson/dartson.dart';

@Entity()
class Array2D
{
  List<List<int>> array;

  Array2D();

  Array2D.normal(int width, int height, int defaultValue)
  {
    array = new List.generate(width, (_) => new List.filled(height, defaultValue));
  }

  operator [](int x) => array[x];
  }