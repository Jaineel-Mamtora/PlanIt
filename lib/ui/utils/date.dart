int dateTimeToEpoch(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day)
      .millisecondsSinceEpoch;
}

DateTime epochToDateTime(int epochTime) {
  return DateTime.fromMillisecondsSinceEpoch(epochTime);
}
