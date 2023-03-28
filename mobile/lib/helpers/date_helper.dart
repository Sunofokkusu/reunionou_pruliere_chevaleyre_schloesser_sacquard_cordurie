class DateHelper {
  static String formatDate(DateTime datetime) {
    return "${datetime.day.toString().padLeft(2, '0')}/${datetime.month.toString().padLeft(2, '0')}/${datetime.year.toString()} ${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}";
  }
}
