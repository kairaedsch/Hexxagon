enum TileType
{
  PLAYER_ONE, PLAYER_TWO, EMPTY, FORBIDDEN, OUT_OF_FIELD
}

String TileTypeToName(TileType tileType)
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