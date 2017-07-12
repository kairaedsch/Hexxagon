import 'dart:math';

class HexagonGrid
{
  final int gridContainerWidth;
  final int gridContainerHeight;
  final int gridRows;
  final int gridColumns;

  HexagonGrid(this.gridContainerWidth, this.gridContainerHeight, this.gridColumns, this.gridRows);

  double get borderColumns => min(gridContainerWidth / 200, gridContainerHeight / 200);

  double get borderRows => borderColumns / 2;

  double get _aFromWidth => (gridContainerWidth - (gridColumns * 2 + 1) * borderColumns * 2) / (gridColumns * 2 * 1.5);

  double get _aFromHeight => ((gridContainerHeight - (gridRows / 2 - 1) * borderRows * 2) / (gridRows + 1)) / (0.5 * sqrt(3));

  double get _a => min(_aFromHeight, _aFromWidth);

  double get tileWidth => _a * 2;

  double get tileHeight => sqrt(3) * _a;

  double get tileMarginLeft => _a + borderColumns * 2;

  double get tileMarginTop => -(sqrt(3) * _a) / 2 + borderRows;

  double get rowEvenMarginLeft => -_a - borderColumns;

  double get rowOddMarginLeft => _a / 2;

  double get gridWidth => gridColumns * (tileWidth + tileMarginLeft) + rowOddMarginLeft;

  double get gridWidthIfRound => gridWidth + (((gridColumns / 2) % 1 == 0) ? -1 : 1) * (_a * 1.5);

  double get gridHeight => gridRows * (tileHeight + tileMarginTop);
}