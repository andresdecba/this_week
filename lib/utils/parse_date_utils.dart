import 'package:intl/intl.dart';

abstract class ParseDateUtils {
  /// de string a DateTime
  static DateTime stringToDate(String date) {
    return DateTime.parse(date);
  }

  /// de DateTime a string "05-12-2022"
  static String dateToString(DateTime date) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(date); //DateFormat('yyyy-MM-dd – kk:mm')
    return formattedDate;
  }

  /// de DateTime to "05 DECEMBER"
  static String dateToAbbreviateString(DateTime date) {
    String formattedDate = DateFormat('d/MM/yy').format(date);
    return formattedDate;
  }
}
