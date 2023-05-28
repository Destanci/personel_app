extension StringExtensions on String {
  String toPascalCase() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
