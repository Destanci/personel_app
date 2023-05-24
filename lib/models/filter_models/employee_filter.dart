import 'package:personel_app/core/enums/gender_enum.dart';

class EmployeeFilter {
  double? minAge;
  double? maxAge;
  Gender? gender;
  List<int>? departmentIds;
  List<int>? positionIds;

  EmployeeFilter({
    this.minAge,
    this.maxAge,
    this.gender,
    this.departmentIds,
    this.positionIds,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (minAge != null && minAge! > 0) map["MinAge"] = minAge;
    if (maxAge != null && maxAge! > 0) map["MaxAge"] = maxAge;
    if (gender != null) map["Gender"] = gender.toString();
    if (departmentIds != null && departmentIds!.length > 0) map["DepartmentIds"] = departmentIds;
    if (positionIds != null && positionIds!.length > 0) map["PositionIds"] = positionIds;
    return map;
  }
}
