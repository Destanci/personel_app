class DataResponse {
  int? draw;
  int? recordsTotal;
  int? recordsFiltered;
  dynamic data;

  DataResponse({
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  DataResponse.fromMap(Map<String, dynamic> map) {
    if (map["Draw"] is int) {
      draw = map["Draw"];
    }
    if (map["RecordsTotal"] is int) {
      recordsTotal = map["RecordsTotal"];
    }
    if (map["RecordsFiltered"] is int) {
      recordsFiltered = map["RecordsFiltered"];
    }

    data = map["Data"];
  }
}
