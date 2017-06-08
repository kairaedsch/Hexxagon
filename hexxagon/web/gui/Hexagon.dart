import 'dart:math';

class Hexagon
{
  int _gridWidth;
  int _gridHeight;
  int _gridRows;
  int _gridColumns;

  Hexagon(this._gridWidth, this._gridHeight, this._gridColumns, this._gridRows);

  double get borderColumns => min(_gridWidth / 200, _gridHeight / 200);

  double get borderRows => borderColumns / 2;

  double get _aFromWidth => (_gridWidth - (_gridColumns + 1) * borderColumns * 2) / (_gridColumns * 1.5);

  double get _aFromHeight => ((_gridHeight - (_gridRows - 1) * borderRows * 2) / (_gridRows + 1)) / (0.5 * sqrt(3));

  double get _a => min(_aFromHeight, _aFromWidth);

  double get tileWidth => _a * 2;

  double get tileHeight => sqrt(3) * _a;

  double get tileMarginLeft => _a + borderColumns * 2;

  double get tileMarginTop => -(sqrt(3) * _a) / 2 + borderRows;

  double get rowEvenMarginLeft => -_a - borderColumns;

  double get rowOddMarginLeft => _a / 2;

  double get gridPaddingTop => _a - borderColumns;

  double get gridWidth => (_gridColumns * 1.5 + 0.5) * (_a + borderColumns * 2);
}