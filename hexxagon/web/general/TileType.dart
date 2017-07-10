enum TileType
{
  PLAYER_ONE, PLAYER_TWO, EMPTY, FORBIDDEN, OUT_OF_FIELD
}

class TileTypes
{
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
      case TileType.FORBIDDEN:
        return "FORBIDDEN";
      case TileType.OUT_OF_FIELD:
        return "OUT_OF_FIELD";
    }
    throw new Exception();
  }

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
