import 'package:personel_app/core/_utils/string_extensions.dart';

enum Gender {
  male,
  female;

  @override
  String toString() => this.name.split('.').last;

  static Gender? fromString(String string) {
    try {
      return Gender.values.firstWhere((gender) => gender.name.toLowerCase() == string.toLowerCase());
    } catch (ex) {
      return null;
    }
  }
}

extension GenderExtensions on Gender {
  String convert() {
    return this == Gender.male ? "Erkek" : "Kadın";
  }

  String toDisplay() {
    return this.convert().toPascalCase();
  }

  String toServer() {
    return this.toString().toPascalCase();
  }
}
