import '../general/TilePosition.dart';
import '../general/TileType.dart';
import 'Hexxagon.dart';

class HexxagonWithStats extends Hexxagon
{
  HexxagonStatsData _hexxagonStatsPlayerOne;
  HexxagonStatsData _hexxagonStatsPlayerTwo;

  HexxagonWithStats(int size) : super(size)
  {
    _hexxagonStatsPlayerOne = new HexxagonStatsData();
    _hexxagonStatsPlayerTwo = new HexxagonStatsData();
  }

  @override
  void move(TilePosition from, TilePosition to)
  {
    super.move(from, to);
    HexxagonStatsData hexxagonStats = currentPlayer == TileType.PLAYER_ONE ? _hexxagonStatsPlayerOne : _hexxagonStatsPlayerTwo;
    int distance = from.getMaxDistanceTo(to);
    if (distance == 2)
    {
      hexxagonStats.jumps++;
    }
    else
    {
      hexxagonStats.copies++;
    }
  }

  @override
  Map<String, String> getStatsOf(int player)
  {
    return (player == TileType.PLAYER_ONE ? _hexxagonStatsPlayerOne : _hexxagonStatsPlayerTwo).toMap(this, player);
  }
}

class HexxagonStatsData
{
  int jumps;
  int copies;

  HexxagonStatsData()
  {
    jumps = 0;
    copies = 0;
  }

  HexxagonStatsData.clone(HexxagonStatsData hexxagonStats)
  {
    jumps = hexxagonStats.jumps;
    copies = hexxagonStats.copies;
  }

  Map<String, String> toMap(Hexxagon hexxagon, int player)
  {
    Map<String, String> map = new Map();
    map["Steine"] = hexxagon.countTilesOfType(player).toString();
    map["Sprünge"] = jumps.toString();
    map["Kopien"] = copies.toString();
    return map;
  }
}