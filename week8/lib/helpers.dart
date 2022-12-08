int mapDynamicToInt(dynamic d) {
  return int.parse(d.toString());
}

List<int> mapListDynamicToListInt(List<dynamic> l) {
  return l.map((e) => mapDynamicToInt(e)).toList();
}
List<List<int>> map2dListDynamicToListIntInt(List<dynamic> l) {
  return l.map((e) => mapListDynamicToListInt(e)).toList();
}