import 'package:intl/intl.dart';

class DateFormatterUtil {

  factory DateFormatterUtil() {
    return _instance;
  }
  const DateFormatterUtil._();

  static const DateFormatterUtil _instance = DateFormatterUtil._();

  static String formatDate(
    String format,
    DateTime? date, [
    bool showTimezone = false,
  ]) {
    if (date == null) {
      return '';
    }
    final formatted = DateFormat(
      format,
      'id_ID',
    ).format(date);

    if (!showTimezone) {
      return formatted;
    }

    return '$formatted ${date.timeZoneName}';
  }
}
