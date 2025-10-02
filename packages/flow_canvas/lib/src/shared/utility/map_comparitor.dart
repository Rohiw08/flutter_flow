import 'dart:ui';

bool areMapsEqual(Map<String, Offset> map1, Map<String, Offset> map2) {
  if (map1.length != map2.length) {
    return false;
  }
  for (final key in map1.keys) {
    if (!map2.containsKey(key) || map1[key] != map2[key]) {
      return false;
    }
  }
  return true;
}
