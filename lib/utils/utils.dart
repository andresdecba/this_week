import 'package:intl/intl.dart';

class Utils {
  /// de string a DateTime
  static DateTime parseStringToDate(String date) {
    return DateTime.parse(date);
  }

  /// de DateTime a string "05-12-2022"
  static String parseDateToString(DateTime date) {
    String formattedDate = DateFormat('EEEE dd-MM-yyyy – kk:mm').format(date); //DateFormat('yyyy-MM-dd – kk:mm')
    return formattedDate;
  }

  /// de DateTime a string corto "05-12-2022"
  static String parseDateTimeToShortFormat(DateTime date) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    return formattedDate;
  }

  /// de DateTime to "05 DECEMBER"
  static String dateToAbbreviateString(DateTime date) {
    String formattedDate = DateFormat('d/MM/yy').format(date);
    return formattedDate;
  }

  static int createNotificationId() {
    // las notificaciones aceptan un id de hasta 9 numeros
    String number = DateTime.now().millisecondsSinceEpoch.toString();
    int startValue = number.length - 9;
    int trimmedId = int.parse(number.substring(startValue, number.length));
    return trimmedId;
  }

  // static DateTime createTime(){

  //   tz.initializeTimeZones();
  //   tz.setLocalLocation(
  //     tz.getLocation(
  //       await FlutterNativeTimezone.getLocalTimezone(),
  //     ),
  //   );
  // }
}
