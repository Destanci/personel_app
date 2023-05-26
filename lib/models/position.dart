class Position {
  int? id;
  String? name;

  Position({this.id, this.name});

  Position.fromMap(Map<String, dynamic> map) {
    if (map["Id"] is int) {
      id = map["Id"];
    }
    if (map["Name"] is String) {
      name = map["Name"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["Id"] = id;
    map["Name"] = name;
    return map;
  }
}
