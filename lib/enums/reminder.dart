enum Reminder {
  None,
  In24Hours,
  AnHourBefore,
  FifteenMinutesBefore,
}

Map<int, String> reminderMap = {
  -1: 'None',
  0: '5 mins before',
  1: '30 mins before',
  2: '1 hour before',
};

List<String> reminders = [
  '5 mins before',
  '30 mins before',
  '1 hour before',
];

Map<int, int> reminderInMillisecondsMap = {
  0: 300000,
  1: 1800000,
  2: 3600000,
};

String getReminderString(int index) {
  return reminderMap[index];
}

int getReminderMilliseconds(int index) {
  return reminderInMillisecondsMap[index];
}

int getReminderIndex(String reminder) {
  int index = reminderMap.keys
      .firstWhere((k) => reminderMap[k] == reminder, orElse: () => null);
  return index;
}
