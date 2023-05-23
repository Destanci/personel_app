enum Gender {
  male,
  female;

  @override
  String toString() => this.name.split('.').last;

  static Gender fromString(String string) {
    return Gender.values.firstWhere((gender) => gender.name == string.toLowerCase());
  }
}
