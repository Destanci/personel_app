class PagedRequest {
  int draw;
  int start;
  int length;

  RequestSearch? search = RequestSearch(value: '');
  List<RequestOrder> order;
  PagedRequest({
    required this.start,
    required this.length,
    this.search,
    this.order = const [],
    this.draw = 0,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (draw >= 0) map["Draw"] = draw;
    if (start >= 0) map["Start"] = start;
    if (length >= 0) map["Length"] = length;

    if (search != null) map["Search"] = search!.toMap();
    if (order.length > 0) map["Order"] = order.map((e) => e.toMap()).toList();
    return map;
  }
}

class RequestOrder {
  String columnName;
  String dir;

  RequestOrder({
    required this.columnName,
    this.dir = 'asc',
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (columnName.isNotEmpty) map["ColumnName"] = columnName;
    if (dir.isNotEmpty) map["Dir"] = dir;
    return map;
  }
}

class RequestSearch {
  String value;
  String? regex;
  RequestSearch({
    required this.value,
    this.regex,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (value.isNotEmpty) map["Value"] = value;
    if (regex != null && regex!.isNotEmpty) map["Regex"] = regex;
    return map;
  }
}
