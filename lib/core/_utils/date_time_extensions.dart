import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toDisplay() {
    return DateFormat('dd/MM/yyyy kk:mm').format(this);
  }

  String toDisplayDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
