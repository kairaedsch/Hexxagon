import 'Hexxagon.dart';

class HexxagonStats
{
  int jumps;
  int copies;
  int capturedStones;

  HexxagonStats()
  {
    jumps = 0;
    copies = 0;
    capturedStones = 0;
  }

  HexxagonStats.clone(HexxagonStats hexxagonStats)
  {
    jumps = hexxagonStats.jumps;
    copies = hexxagonStats.copies;
    capturedStones = hexxagonStats.capturedStones;
  }

  Map<String, String> toMap(Hexxagon hexxagon, int player)
  {
    Map<String, String> map = new Map();
    map["Steine"] = hexxagon.countTilesOfType(player).toString();
    map["Sprünge"] = jumps.toString();
    map["Kopien"] = copies.toString();
    map["Eingenommene Steine"] = capturedStones.toString();
    return map;
  }
}