/// A type of a tile.
enum TileType
{
  /// A tile of the first player.
  PLAYER_ONE,

  /// A tile of the second player.
  PLAYER_TWO,

  /// A empty tile.
  EMPTY,

  /// A blocked tile.
  BLOCKED,

  /// A tile out of the allowed board field.
  OUT_OF_FIELD
}

/// A utility class for TileTypes.
class TileTypes
{
  /// The name of a TileType.
  static String toName(TileType tileType)
  {
    switch (tileType)
    {
      case TileType.PLAYER_ONE:
        return "PLAYER_ONE";
      case TileType.PLAYER_TWO:
        return "PLAYER_TWO";
      case TileType.EMPTY:
        return "EMPTY";
      case TileType.BLOCKED:
        return "BLOCKED";
      case TileType.OUT_OF_FIELD:
        return "OUT_OF_FIELD";
    }
    throw new Exception();
  }

  /// The other player of the given player.
  static TileType other(TileType tileType)
  {
    if (tileType == TileType.PLAYER_ONE)
    {
      return TileType.PLAYER_TWO;
    }
    if (tileType == TileType.PLAYER_TWO)
    {
      return TileType.PLAYER_ONE;
    }
    throw new Exception();
  }
}
