import 'dart:math';

/// Offers sizes about a hexagon grid.
class HexagonGrid
{
  /// The width of the container, in which the grid should fit.
  final int gridContainerWidth;

  /// The width of the container, in which the grid should fit.
  final int gridContainerHeight;

  /// The amount of rows in the grid.
  final int gridRows;

  /// The amount of columns in the grid.
  final int gridColumns;

  /// Create a new HexagonGrid with a given container size anf a given row and column amount.
  HexagonGrid(this.gridContainerWidth, this.gridContainerHeight, this.gridColumns, this.gridRows);

  /// The border between two columns.
  double get borderColumns => min(gridContainerWidth / 200, gridContainerHeight / 200);

  /// The border between two rows.
  double get borderRows => borderColumns / 2;

  /// The "a" value with a value, so that the grid is as wide as the container.
  double get _aFromWidth => (gridContainerWidth - (gridColumns * 2 + 1) * borderColumns * 2) / (gridColumns * 2 * 1.5);

  /// The "a" value with a value, so that the grid is as high as the container.
  double get _aFromHeight => ((gridContainerHeight - (gridRows / 2 - 1) * borderRows * 2) / (gridRows + 1)) / (0.5 * sqrt(3));

  /// The "a" value with a value, so that the grid fits in the container. The "a" value is the half width of a hexagon.
  double get _a => min(_aFromHeight, _aFromWidth);

  /// The width of a hexagon.
  double get tileWidth => _a * 2;

  /// The height of a hexagon.
  double get tileHeight => sqrt(3) * _a;

  /// The left margin between two tiles.
  double get tileMarginLeft => _a + borderColumns * 2;

  /// The top margin between two tiles.
  double get tileMarginTop => -(sqrt(3) * _a) / 2 + borderRows;

  /// The left margin of each even row.
  double get rowEvenMarginLeft => -_a - borderColumns;

  /// The left margin of each odd row.
  double get rowOddMarginLeft => _a / 2;

  /// The width of the grid.
  double get gridWidth => gridColumns * (tileWidth + tileMarginLeft) + rowOddMarginLeft;

  /// The width of the grid, if the tiles form a circle.
  double get gridWidthIfRound => gridWidth + (((gridColumns / 2) % 1 == 0) ? -1 : 1) * (_a * 1.5);

  /// The height of the grid.
  double get gridHeight => gridRows * (tileHeight + tileMarginTop);
}