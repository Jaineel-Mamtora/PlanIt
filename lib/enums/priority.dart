enum Priority {
  None,
  Low,
  High,
  Critical,
}

Map<int, String> priorityMap = {
  0: 'None',
  1: 'Low',
  2: 'High',
  3: 'Critical',
};

Map<int, String> priorityAssetMap = {
  0: 'assets/icons/radio_green_enable.svg',
  1: 'assets/icons/radio_yellow_enable.svg',
  2: 'assets/icons/radio_red_enable.svg',
};

String getPriorityString(int index) {
  return priorityMap[index];
}

int getPriorityIndex(String priority) {
  int index = priorityAssetMap.keys
      .firstWhere((k) => priorityAssetMap[k] == priority, orElse: () => null);
  return index;
}
