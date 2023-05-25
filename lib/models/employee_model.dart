class Employee {
  int? id;
  String? name;
  String? surname;
  DateTime? birthdayDate;
  String? gender;
  String? email;
  String? phone;
  String? address;
  int? departmentId;
  String? departmentName;
  int? positionId;
  String? positionName;
  String? title;
  DateTime? hireDate;
  String? about;
  dynamic picturePath;

  Employee(
      {this.id,
      this.name,
      this.surname,
      this.birthdayDate,
      this.gender,
      this.email,
      this.phone,
      this.address,
      this.departmentId,
      this.departmentName,
      this.positionId,
      this.positionName,
      this.title,
      this.hireDate,
      this.about,
      this.picturePath});

  Employee.fromMap(Map<String, dynamic> map) {
    if (map["Id"] is int) {
      id = map["Id"];
    }
    if (map["Name"] is String) {
      name = map["Name"];
    }
    if (map["Surname"] is String) {
      surname = map["Surname"];
    }
    if (map["BirthdayDate"] is String) {
      birthdayDate = DateTime.parse(map["BirthdayDate"]);
    }
    if (map["Gender"] is String) {
      gender = map["Gender"];
    }
    if (map["Email"] is String) {
      email = map["Email"];
    }
    if (map["Phone"] is String) {
      phone = map["Phone"];
    }
    if (map["Address"] is String) {
      address = map["Address"];
    }
    if (map["DepartmentId"] is int) {
      departmentId = map["DepartmentId"];
    }
    if (map["DepartmentName"] is String) {
      departmentName = map["DepartmentName"];
    }
    if (map["PositionId"] is int) {
      positionId = map["PositionId"];
    }
    if (map["PositionName"] is String) {
      positionName = map["PositionName"];
    }
    if (map["Title"] is String) {
      title = map["Title"];
    }
    if (map["HireDate"] is String) {
      hireDate = DateTime.parse(map["HireDate"]);
    }
    if (map["About"] is String) {
      about = map["About"];
    }
    picturePath = map["PicturePath"];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (id != null && id! > 0) map["Id"] = id;
    if (name != null && name!.isNotEmpty) map["Name"] = name;
    if (surname != null && surname!.isNotEmpty) map["Surname"] = surname;
    if (birthdayDate != null) map["BirthdayDate"] = birthdayDate.toString();
    if (gender != null) map["Gender"] = gender;
    if (email != null && email!.isNotEmpty) map["Email"] = email;
    if (phone != null && phone!.isNotEmpty) map["Phone"] = phone;
    if (address != null && address!.isNotEmpty) map["Address"] = address;
    if (departmentId != null && departmentId! > 0) map["DepartmentId"] = departmentId;
    if (departmentName != null && departmentName!.isNotEmpty) map["DepartmentName"] = departmentName;
    if (positionId != null && positionId! > 0) map["PositionId"] = positionId;
    if (positionName != null && positionName!.isNotEmpty) map["PositionName"] = positionName;
    if (title != null && title!.isNotEmpty) map["Title"] = title;
    if (hireDate != null) map["HireDate"] = hireDate.toString();
    if (about != null && about!.isNotEmpty) map["About"] = about;
    if (picturePath != null && picturePath!.isNotEmpty) map["PicturePath"] = picturePath;
    return map;
  }
}
