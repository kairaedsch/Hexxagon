class TileType
{
  static int PLAYER_ONE = 0;
  static int PLAYER_TWO = 1;
  static int EMPTY = 2;
  static int FORBIDDEN = 3;

  static String toName(int tileType)
  {
    switch(tileType)
    {
      case 0: return "PLAYER_ONE";
      case 1: return "PLAYER_TWO";
      case 2: return "EMPTY";
      case 3: return "FORBIDDEN";
    }
  }
}