class DateHelper {
  static String formatDateTime(DateTime datetime) {
    return "${datetime.day.toString().padLeft(2, '0')}/${datetime.month.toString().padLeft(2, '0')}/${datetime.year.toString()} ${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}";
  }

  static String formatDate(DateTime datetime) {
    return "${datetime.day.toString().padLeft(2, '0')}/${datetime.month.toString().padLeft(2, '0')}/${datetime.year.toString()}";
  }

  static String formatTime(DateTime datetime) {
    return "${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}";
  }
}
